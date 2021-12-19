# frozen_string_literal: true

require 'pry'
require 'pry-stack_explorer'

module Cmd
  module_function

  def compile_from_argv!
    gen! ARGV.last
  end

  def graph_from_argv!
    graph! ARGV.last
  end

  def lex!(filepath)
    compiler = Compiler.from_filepath(filepath)

    lex = Lex.new(compiler)
    compiler.tokens = lex.lex!

    compiler
  end

  def parse!(filepath)
    compiler = lex!(filepath)

    parse = Parse.new(compiler)
    compiler.ast = parse.parse!

    compiler
  end

  def gen!(filepath)
    compiler = parse!(filepath)

    generate = Generate.new(compiler)
    generate.gen!
  end

  def graph!(filepath)
    compiler = parse!(filepath)

    graph = Graph.new(compiler)
    graph.graph!
  end
end
