# frozen_string_literal: true

module Node
  class Abstract
    attr_reader :tokens

    def initialize(tokens)
      @tokens = tokens
    end
  end
end
