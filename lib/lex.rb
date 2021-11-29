# frozen_string_literal: true

class Lex
  attr_accessor :tokens, :curconst
  attr_reader :compiler

  def initialize(compiler)
    @tokens = []
    @curconst = String.new
    @compiler = compiler
  end

  def lex!
    compiler.input.each_char do |char|
      if /[a-zA-Z0-9]/ =~ char
        curconst << char
        next
      end

      if curconst.length.positive?
        tokens <<
          if Token.keywords.include? curconst
            [Token::KEYWORD, curconst]
          elsif curconst =~ /^[0-9]+$/
            [Token::CONST, curconst]
          else
            [Token::ID, curconst]
          end

        self.curconst = String.new
      end

      token =
        case char
        when '{' then [Token::BLOCK, char]
        when '}' then [Token::END_BLOCK, char]
        when '(' then [Token::PAREN, char]
        when ')' then [Token::END_PAREN, char]
        when ';' then [Token::TERM, char]
        when '-' then [Token::NEG, char]
        when '~' then [Token::BIT_COMP, char]
        when '!' then [Token::BANG, char]
        when '+' then [Token::ADD, char]
        when '*' then [Token::MULT, char]
        when '/' then [Token::DIV, char]
        when /\s/ then next
        else
          raise format('unknown token %s', char.inspect)
        end

      tokens << token
    end

    tokens.map { |t| Token.new(*t) }
  end
end
