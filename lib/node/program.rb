# frozen_string_literal: true

module Node
  class Program < Abstract
    attr_reader :function

    def parse!
      @function = Function.new(tokens).parse!

      if @function.id != 'main'
        raise ParseError,
              format('root function must be called main, found %s', @function.id)
      end

      self
    end
  end
end
