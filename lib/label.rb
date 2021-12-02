# frozen_string_literal: true

Label = Class.new do
  def next
    @label ||= 0
    "_l#{@label += 1}"
  end
end.new
