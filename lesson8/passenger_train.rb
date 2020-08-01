class PassengerTrain < Train
  attr_reader :type
  def initialize(number)
    super(number)
    @type = :passenger
  end

  private

  def attach_wagon(wagon)
    raise 'К этому поезду можно прицепить только пассажирский вагон' unless wagon.class == PassengerWagon

    super(wagon)
  end
end
