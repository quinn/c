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

      op_prefix =
        <<~ASM
          #{left.gen!}
          push %rax
          #{right.gen!}
          pop %rbx
        ASM

      cmp_prefix =
        <<~ASM
          #{op_prefix}
          cmp %rax, %rbx
          mov $0, %rax
        ASM

      buf <<
        case operator.type
        when Token::ADD
          <<~ASM
            #{op_prefix}
            add %rbx, %rax
          ASM
        when Token::NEG
          <<~ASM
            #{op_prefix}
            sub %rax, %rbx
            mov %rbx, %rax
          ASM
        when Token::MULT
          <<~ASM
            #{op_prefix}
            imul %rbx, %rax
          ASM
        when Token::DIV
          <<~ASM
            #{op_prefix}
            mov %rax, %rcx
            mov %rbx, %rax
            cqo
            idiv %rcx
          ASM
        when Token::EQ
          <<~ASM
            #{cmp_prefix}
            sete %al
          ASM
        when Token::NE
          <<~ASM
            #{op_prefix}
            cmp %rax, %rbx
            mov $0, %rax
            sete %al
            cmp $0, %rax
            sete %al
          ASM
        when Token::GT
          <<~ASM
            #{cmp_prefix}
            setg %al
          ASM
        when Token::GTE
          <<~ASM
            #{cmp_prefix}
            setge %al
          ASM
        when Token::LT
          <<~ASM
            #{cmp_prefix}
            setl %al
          ASM
        when Token::LTE
          <<~ASM
            #{cmp_prefix}
            setle %al
          ASM
        when Token::OR
          right_clause = Label.next
          to_end = Label.next
          <<~ASM
              #{left.gen!}
              cmp $0, %rax
              je #{right_clause}
              jmp #{to_end}
            #{right_clause}:
              #{right.gen!}
            #{to_end}:
          ASM
        when Token::AND
          right_clause = Label.next
          to_end = Label.next
          <<~ASM
              #{left.gen!}
              cmp $0, %rax
              jne #{right_clause}
              jmp #{to_end}
            #{right_clause}:
              #{right.gen!}
              cmp $0, %eax
              mov $0, %eax
              setne %al
            #{to_end}:
          ASM
        else
          raise GenerateError, "unkown token #{operator}"
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
