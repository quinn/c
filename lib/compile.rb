# frozen_string_literal: true

class Function
  def compile!
    <<~ASM
      .globl #{id}
      #{id}:
      #{statements.map(&:compile!).join("\n")}
    ASM
  end
end

class Statement
  def compile!
    <<~ASM
      #{expression.compile!}
      #{is_return ? 'ret' : ''}
    ASM
  end
end

class Operator
  def compile!
    case token.type
    when Token::NEG
      <<~ASM
        neg     %eax
      ASM
    when Token::BIT_COMP
      <<~ASM
        not     %eax
      ASM
    when Token::BANG
      <<~ASM
        cmpl   $0, %eax
        movl   $0, %eax
        sete   %al
      ASM
    else
      raise GenerateError, "unkown operator token #{operator.type}"
    end
  end
end

class Expression
  def compile!
    if operator
      <<~ASM
        #{expression.compile!}
        #{operator.compile!}
      ASM
    elsif constant_value
      <<~ASM
        movl    $#{constant_value}, %eax
      ASM
    end
  end
end

class Compile
  attr_reader :compiler

  def initialize(compiler)
    @compiler = compiler
    @buf = ''
  end

  def compile!
    main = compiler.ast.function
    main.compile!
  end
end
