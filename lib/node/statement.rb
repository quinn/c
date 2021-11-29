# frozen_string_literal: true

module Node
  class Statement < Abstract
    attr_reader :is_return, :expression

    def parse!
      token = tokens.peek

      if token.type == Token::KEYWORD && token.value == 'return'
        @is_return = true
        tokens.next
      end

      @expression = Expression.new(tokens).parse!

      token = tokens.next
      raise ParseError, format('expected terminator, got %s', token) unless token.type == Token::TERM

      self
    end

    def gen!
      <<~ASM
        #{expression.gen!}
        #{is_return ? 'ret' : ''}
      ASM
    end

    def graph!(graph, parent)
      s = graph.add_nodes("Statement(#{is_return ? 'return' : ''})")
      graph.add_edges(parent, s)
      expression.graph!(graph, s)
    end
  end
end
