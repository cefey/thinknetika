# frozen_string_literal: true

class PassengerTrain < Train
  @trains = {}
  attr_reader :type
  def initialize(number)
    super(number)
    @type = :passenger
  end

  private

  def attach_wagon(wagon)
    raise 'Wrong type of wagon' unless wagon.class == PassengerWagon

    super(wagon)
  end
end
