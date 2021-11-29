# frozen_string_literal: true

module Node
  class UnOp < Abstract
    attr_reader :operator, :factor

    def parse!
      token = tokens.next
      raise ParseError, "unexepected, got #{token}" unless token.un_op?

      @operator = token
      @factor = Factor.new(tokens).parse!

      self
    end

    def gen!
      factor.gen! <<
        case operator.type
        when Token::NEG
          <<~ASM
            neg     %rax
          ASM
        when Token::BIT_COMP
          <<~ASM
            not     %rax
          ASM
        when Token::BANG
          <<~ASM
            cmp   $0, %rax
            mov   $0, %rax
            sete   %al
          ASM
        else
          raise GenerateError, "unkown unary operator token #{operator}"
        end
    end

    def graph!(graph, parent)
      s = graph.add_nodes("UnOp(#{operator})")
      graph.add_edges(parent, s)

      factor.graph!(graph, s)
    end
  end
end
