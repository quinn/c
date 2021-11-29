# frozen_string_literal: true

module Cmd
  module_function

  def compile_from_argv!
    gen! ARGV.last
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
end
