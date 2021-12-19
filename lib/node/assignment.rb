# frozen_string_literal: true

module Node
  class Assignment < Abstract
    attr_reader :var_name, :expression

    def parse!
      @var_name = tokens.next.expect!(Token::ID).value
      tokens.next.expect!(Token::ASSIGN)
      @expression = Expression.new(tokens).parse!
      self
    end
  end
end
