# frozen_string_literal: true

module Node
  class Term < Abstract
    def parse!
      factor = Factor.new(tokens).parse!

      loop do
        token = tokens.peek
        break unless token.high_op?

        op = tokens.next
        right = Factor.new(tokens).parse!

        factor = BinOp.new(tokens, operator: op, left: factor, right: right).parse!
      end

      factor
    end

    def gen!
      raise 'not implemented'
    end

    def graph!(_graph, _parent)
      raise 'not implemented'
    end
  end
end
