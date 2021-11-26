# frozen_string_literal: true

module Cmd
  module_function

  def compile_from_argv!
    compile! ARGV.last
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

  def compile!(filepath)
    compiler = parse!(filepath)

    compile = Compile.new(compiler)
    compile.compile!
  end
end
