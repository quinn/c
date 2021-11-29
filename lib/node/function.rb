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
        if token.type == Token::END_BLOCK
          raise ParseError, format('missing return') if @statements.empty?

          break
        end

        raise ParseError, 'unexpected end of function' if tokens.empty?

        @statements << Statement.new(tokens).parse!

        raise ParseError, 'unexpected end of function' if tokens.empty?

        token = tokens.next
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

    private

    def return_types
      ['int']
    end
  end
end
