require_relative './wagon.rb'
class CargoWagon < Wagon
  attr_reader :capacity, :capacity_taken

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number, capacity)
    super(number, 'cargo')
    @capacity = capacity
    @capacity_taken = 0
  end

  def capacity_take(v)
    @capacity_taken += v if (@capacity_taken + v) <= @capacity
  end

  def capacity_left
    @capacity - @capacity_taken
  end
end
