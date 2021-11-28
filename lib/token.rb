# frozen_string_literal: true

class Token
  BLOCK = :BLOCK
  END_BLOCK = :END_BLOCK
  PAREN = :PAREN
  END_PAREN = :END_PAREN
  KEYWORD = :KEYWORD
  CONST = :CONST
  TERM = :TERM
  ID = :ID
  NEG = :NEG
  BIT_COMP = :BIT_COMP
  BANG = :BANG

  def self.keywords
    %w[
      int
      return
    ]
  end

  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def to_hash
    {
      type: @type,
      value: @value
    }
  end

  def to_s
    format('<Token::%<type>s %<value>s', **to_hash)
  end

  def operator?
    [BIT_COMP, NEG, BANG].include? type
  end
end
