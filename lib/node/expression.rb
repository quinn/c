# frozen_string_literal: true

module Node
  class Expression < Abstract
    def parse!
      if tokens.peek.type == Token::ID && tokens.double_peek.type == Token::ASSIGN
        assign = Assignment.new(tokens).parse!
        return assign
      end

      logical_and = LogicalAndExp.new(tokens).parse!

      loop do
        token = tokens.peek
        break unless token.type == Token::OR

        op = tokens.next

        right = LogicalAndExp.new(tokens).parse!

        logical_and = BinOp.new(tokens, operator: op, left: logical_and, right: right).parse!
      end

      logical_and
    end

    def gen!
      raise 'not implemented'
    end

    def graph!(_graph, _parent)
      raise 'not implemented'
    end
  end
end
