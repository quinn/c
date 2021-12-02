# frozen_string_literal: true

module Node
  class EqualityExp < Abstract
    def parse!
      relational = RelationalExp.new(tokens).parse!

      loop do
        token = tokens.peek
        break unless token.equality_op?

        op = tokens.next
        right = RelationalExp.new(tokens).parse!

        relational = BinOp.new(tokens, operator: op, left: relational, right: right).parse!
      end

      relational
    end

    def gen!
      raise 'not implemented'
    end

    def graph!(_graph, _parent)
      raise 'not implemented'
    end
  end
end
