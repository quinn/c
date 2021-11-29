# frozen_string_literal: true

module Node
  class Expression < Abstract
    def parse!
      term = Term.new(tokens).parse!

      token = tokens.peek

      return BinOp.new(tokens, operator: tokens.next, left_expr: term).parse! if token.low_op?

      term
    end

    def gen!
      raise 'not implemented'
    end
  end
end
