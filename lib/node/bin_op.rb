# frozen_string_literal: true

module Node
  class BinOp < Abstract
    attr_reader :operator, :left, :right

    def initialize(tokens, operator:, left:, right:)
      super(tokens)
      @operator = operator
      @left = left
      @right = right
    end

    def parse!
      self
    end

    def gen!
      buf = String.new
      buf << left.gen!
      buf << "push %rax\n"

      buf << right.gen!
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

    def graph!(graph, parent)
      s = graph.add_nodes(object_id.to_s, label: "BinOp(#{operator.value})")
      graph.add_edges(parent, s)

      left.graph!(graph, s)
      right.graph!(graph, s)
    end
  end
end
