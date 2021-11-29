# frozen_string_literal: true

require 'ruby-graphviz'

class Graph
  attr_reader :compiler

  def initialize(compiler)
    @compiler = compiler
  end

  def graph!
    g = GraphViz.new(:G, type: :digraph)
    compiler.ast.graph!(g)
    g.output(png: 'hello_world.png')
  end
end
