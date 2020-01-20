# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :type

  def initialize(number, volume)
    super(number, volume)
    @type = :passenger
  end

  def book_volume
    raise 'No free seats' if free_volume.zero?

    super(1)
  end
  alias book_seat book_volume
end
