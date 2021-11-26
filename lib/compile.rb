# frozen_string_literal: true

class Compile
  attr_reader :compiler

  def initialize(compiler)
    @compiler = compiler
  end

  def compile!
    raise 'not implemented'
  end
end
