# frozen_string_literal: true

require_relative './wagon.rb'
class CargoWagon < Wagon
  NUMBER_FORMAT = /\w{3}-?{1}\w{2}$/.freeze
  attr_reader :capacity, :capacity_taken
  def initialize(number, capacity)
    super(number, 'cargo')
    @capacity = capacity
    @capacity_taken = 0
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

  def capacity_take(v)
    @capacity_taken += v if (@capacity_taken + v) <= @capacity
  end

  def capacity_left
    @capacity - @capacity_taken
  end
end
