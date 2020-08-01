# frozen_string_literal: true

class Wagon
  include Company
  attr_reader :number, :type
  NUMBER_FORMAT = /\w{3}-?{1}\w{2}$/.freeze

  def initialize(number, type)
    @number = number
    @type = type
    validate!
  end

  def validate!
    raise "Number can't be nil" unless number
    raise "Type can't be nil" unless type
    raise 'Type should be at least 4 symbols' if type.length < 4
    raise 'Number has invalid format' if number !~ NUMBER_FORMAT
    raise 'Type has invalid format' if type != 'cargo' && type != 'passenger'
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
