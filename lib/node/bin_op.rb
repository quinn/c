# frozen_string_literal: true

module Node
  class BinOp < Abstract
    attr_reader :operator, :left_expr, :right_expr

    def initialize(tokens, operator:, left_expr:)
      super(tokens)
      @operator = operator
      @left_expr = left_expr
    end

    def parse!
      @right_expr = Expression.new(tokens).parse!
      self
    end

    def gen!
      buf << right_expr.gen!
      buf << "push %rax\n"

      buf = left_expr.gen!
      buf << "pop %rbx\n"

      case operator.type
      when Token::ADD
        buf << "add %rbx, %rax\n"
      when Token::NEG
        buf << "sub %rax, %rbx\n"
        buf << "mov %rbx, %rax\n"
      when Token::MULT
        buf << "imul %rbx, %rax\n"
      when Token::DIV
        buf << <<~ASM
          mov %rax, %rcx
          mov %rbx, %rax
          cqo
          idiv %rcx
        ASM
      end

      buf
    end
  end
end
