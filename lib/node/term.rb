# frozen_string_literal: true

module Node
  class Term < Abstract
    def parse!
      factor = Factor.new(tokens).parse!

      token = tokens.peek

      return BinOp.new(tokens, operator: tokens.next, left_expr: factor).parse! if token.high_op?

      factor
    end

    def gen!
      raise 'not implemented'
    end
  end
end
