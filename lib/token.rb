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
  ADD = :ADD
  MULT = :MULT
  DIV = :DIV
  AND = :AND
  OR = :OR
  EQ = :EQ
  NE = :NE
  LT = :LT
  GT = :GT
  LTE = :LTE
  GTE = :GTE
  ASSIGN = :ASSIGN

  class List
    attr_reader :arr

    def initialize(arr)
      @arr = arr
    end

    def next
      arr.shift
    end

    def peek
      arr[0]
    end

    # this feels wrong, but i'm not sure how to discern assignment from reference
    def double_peek
      arr[1]
    end

    def empty?
      arr.empty?
    end
  end

  def self.keywords
    %w[
      int
      return
    ]
  end

  def self.var_declaration_keywords
    %w[
      int
    ]
  end

  attr_reader :type, :value

  def expect!(expected_type)
    type == expected_type || raise(ParseError, "expected #{expected_type}, got #{self}")
    self
  end

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

  def var_declaration?
    keyword? && self.class.var_declaration_keywords.include?(value)
  end

  def keyword?
    type == KEYWORD
  end

  def to_s
    format('<Token::%<type>s `%<value>s`>', **to_hash)
  end

  def operator?
    [BIT_COMP, NEG, BANG, ADD, MULT, DIV].include? type
  end

  def low_op?
    [ADD, NEG].include? type
  end

  def high_op?
    [MULT, DIV].include? type
  end

  def un_op?
    [BIT_COMP, NEG, BANG].include? type
  end

  def bin_op?
    [ADD, NEG, MULT, DIV].include? type
  end

  def equality_op?
    [EQ, NE].include? type
  end

  def relational_op?
    [GT, LT, GTE, LTE].include? type
  end
end
