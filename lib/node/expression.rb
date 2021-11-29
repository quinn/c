# frozen_string_literal: true

module Node
  class Expression < Abstract
    def parse!
      term = Term.new(tokens).parse!

      loop do
        token = tokens.peek
        break unless token.low_op?

        op = tokens.next
        right = Term.new(tokens).parse!

        term = BinOp.new(tokens, operator: op, left: term, right: right).parse!
      end

      term
    end

    def gen!
      raise 'not implemented'
    end

    def graph!(_graph, _parent)
      raise 'not implemented'
    end
  end
end
