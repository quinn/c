# frozen_string_literal: true

module Node
  class RelationalExp < Abstract
    def parse!
      additive = AdditiveExp.new(tokens).parse!

      loop do
        token = tokens.peek
        break unless token.relational_op?

        op = tokens.next
        right = AdditiveExp.new(tokens).parse!

        additive = BinOp.new(tokens, operator: op, left: additive, right: right).parse!
      end

      additive
    end
  end
end
