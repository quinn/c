# frozen_string_literal: true

class ParseError < StandardError; end

class Node
  attr_reader :tokens

  def initialize(tokens)
    @tokens = tokens
  end
end

class Program < Node
  def parse!
    @function = Function.new(tokens).parse!

    raise ParseError, format('root function must be called main, found %s', @function.id) if @function.id != 'main'

    self
  end
end

class Statement < Node
  def parse!
    token = tokens.shift

    if token.type == Token::KEYWORD && token.value == 'return'
      @return = true
    else
      tokens.unshift(token)
    end

    @expression = Expression.new(tokens).parse!

    self
  end
end

class Expression < Node
  def parse!
    token = tokens.shift
    raise ParseError, format('unexepected, got %<type>s : %<value>s', **token) unless token.type == Token::CONST

    @constant_value = token.value

    token = tokens.shift
    raise ParseError, format('expected terminator, got %<type>s : %<value>s', **token) unless token.type == Token::TERM

    self
  end
end

class Function < Node
  attr_reader :return_type, :id

  def parse!
    @statements = []

    token = tokens.shift

    unless token.type == Token::KEYWORD && return_types.include?(token.value)
      raise ParseError, format('invalid function return type %<type>s : %<value>s', **token)
    end

    @return_type = token.value

    token = tokens.shift
    raise ParseError, format('expected function name, got %<type>s : %<value>s', **token) unless token.type == Token::ID

    @id = token.value

    token = tokens.shift
    raise ParseError, format('expected args, got %<type>s : %<value>s', **token) unless token.type == Token::PAREN

    token = tokens.shift
    raise ParseError, format('expected args, got %<type>s : %<value>s', **token) unless token.type == Token::END_PAREN

    token = tokens.shift
    raise ParseError, format('expected args, got %<type>s : %<value>s', **token) unless token.type == Token::BLOCK

    loop do
      if token.type == Token::END_BLOCK
        raise ParseError, format('missing return') if @statements.empty?

        break
      end

      raise ParseError, 'unexpected end of function' if tokens.empty?

      @statements << Statement.new(tokens).parse!

      raise ParseError, 'unexpected end of function' if tokens.empty?

      token = tokens.shift
    end

    self
  end

  def return_types
    ['int']
  end
end

class Parse
  attr_reader :compiler
  attr_accessor :curnode

  def initialize(compiler)
    @compiler = compiler
    @ast = Program.new(compiler.tokens)
    @curnode = @ast
  end

  def parse!
    @curnode.parse!
  end
end
