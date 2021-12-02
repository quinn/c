# frozen_string_literal: true

class GenerateError < StandardError; end

class Generate
  attr_reader :compiler

  def initialize(compiler)
    @compiler = compiler
  end

  def gen!
    main = compiler.ast.function
    main.gen!
  end
end
