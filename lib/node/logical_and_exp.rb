# frozen_string_literal: true

module Node
  class LogicalAndExp < Abstract
    def parse!
      equality = EqualityExp.new(tokens).parse!

      loop do
        token = tokens.peek
        break unless token.type == Token::AND

        op = tokens.next

        right = EqualityExp.new(tokens).parse!

        equality = BinOp.new(tokens, operator: op, left: equality, right: right).parse!
      end

      equality
    end
  end
end
