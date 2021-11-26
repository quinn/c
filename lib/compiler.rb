# frozen_string_literal: true

class Compiler
  attr_accessor :ast
  attr_reader :input, :tokens

  def initialize(input)
    @input = input
  end

  def self.from_filepath(filepath)
    new(File.open(filepath))
  end

  def tokens=(tokens)
    @tokens = tokens.dup
  end
end
