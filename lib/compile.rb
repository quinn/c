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

class Expression
  def compile!
    <<~ASM
      movl    $#{constant_value}, %eax
    ASM
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
    puts main.compile!
  end
end
