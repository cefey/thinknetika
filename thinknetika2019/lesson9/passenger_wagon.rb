# frozen_string_literal: true

require_relative './wagon.rb'
class PassengerWagon < Wagon
  NUMBER_FORMAT = /\w{3}-?{1}\w{2}$/.freeze
  attr_reader :seats, :seats_taken
  def initialize(number, seats)
    super(number, 'passenger')
    @seats = seats
    @seats_taken = 0
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

  def seat_take
    @seats_taken += 1 if @seats_taken < @seats
  end

  def seat_left
    @seats -= @seats_taken
  end
end
