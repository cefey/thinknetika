# frozen_string_literal: true

class PassengerTrain < Train
  NUMBER_FORMAT = /\w{3}-?{1}\w{2}$/.freeze

  def initialize(number)
    super(number, 'passenger')
  end

  def validate!
    raise "Number can't be nil" unless number
    raise 'Number has invalid format' if number !~ NUMBER_FORMAT
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
