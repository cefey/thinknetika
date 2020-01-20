# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :type

  def initialize(number, volume)
    super(number, volume)
    @type = :cargo
  end

  def book_volume(volume)
    raise 'Not enough free space' if @free_volume < volume

    super(volume)
  end
end
