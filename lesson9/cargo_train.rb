# frozen_string_literal: true

class CargoTrain < Train
  @trains = {}
  attr_reader :type
  def initialize(number)
    super(number)
    @type = :cargo
  end

  private

  def attach_wagon(wagon)
    raise 'Wrong type of wagon' unless wagon.class == CargoWagon

    super(wagon)
  end
end
