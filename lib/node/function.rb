# frozen_string_literal: true

module Node
  class Function < Abstract
    attr_reader :return_type, :id, :statements

    def parse!
      @statements = []

      token = tokens.next

      unless token.type == Token::KEYWORD && return_types.include?(token.value)
        raise ParseError, format('invalid function return type %s', token)
      end

      @return_type = token.value

      token = tokens.next
      raise ParseError, format('expected function name, got %s', token) unless token.type == Token::ID

      @id = token.value

      token = tokens.next
      raise ParseError, format('expected args, got %s', token) unless token.type == Token::PAREN

      token = tokens.next
      raise ParseError, format('expected args, got %s', token) unless token.type == Token::END_PAREN

      token = tokens.next
      raise ParseError, format('expected args, got %s', token) unless token.type == Token::BLOCK

      loop do
        if tokens.peek.type == Token::END_BLOCK
          raise ParseError, format('missing return') if @statements.empty?

          break
        end

        raise ParseError, 'unexpected end of function' if tokens.empty?

        statement = Statement.new(tokens).parse!
        @statements << statement
      end

      self
    end

    def gen!
      <<~ASM
        .globl #{id}
        #{id}:
        #{statements.map(&:gen!).join("\n")}
      ASM
    end

    def graph!(graph, parent)
      s = graph.add_nodes("Function(#{id})")
      graph.add_edges(parent, s)

      statements.each do |statement|
        statement.graph!(graph, s)
      end
    end

    private

    def return_types
      ['int']
    end
  end
end
