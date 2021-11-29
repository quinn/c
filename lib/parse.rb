# frozen_string_literal: true

class ParseError < StandardError; end

class Parse
  attr_reader :compiler
  attr_accessor :curnode

  def initialize(compiler)
    @compiler = compiler
    @ast = Node::Program.new(compiler.tokens)
    @curnode = @ast
  end

  def parse!
    @curnode.parse!
  end
end
