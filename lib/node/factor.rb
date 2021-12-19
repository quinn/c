# frozen_string_literal: true

module Node
  class Factor < Abstract
    attr_reader :constant_value, :var_name

    def parse!
      token = tokens.peek
      return UnOp.new(tokens).parse! if token.un_op?

      token = tokens.next
      if token.type == Token::CONST

        @constant_value = token.value

        return self
      elsif token.type == Token::ID

        @var_name = token.value

        return self
      elsif token.type != Token::PAREN
        raise ParseError, format('unexepected `(`, got %s', token)
      end

      expr = Expression.new(tokens).parse!

      token = tokens.next
      raise ParseError, format('unexepected, got %s', token) unless token.type == Token::END_PAREN

      expr
    end

    def gen!
      raise GenerateError, 'missing expression' unless constant_value

      <<~ASM
        mov    $#{constant_value}, %rax
      ASM
    end

    def graph!(graph, parent)
      s = graph.add_nodes("Factor(#{constant_value})")
      graph.add_edges(parent, s)
    end
  end
end
