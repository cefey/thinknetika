require_relative './wagon.rb'
class PassengerWagon < Wagon
  attr_reader :seats, :seats_taken

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number, seats)
    super(number, 'passenger')
    @seats = seats
    @seats_taken = 0
  end

  def seat_take
    @seats_taken += 1 if @seats_taken < @seats
  end

  def seat_left
    @seats -= @seats_taken
  end
end
