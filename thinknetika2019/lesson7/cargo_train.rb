class CargoTrain < Train
  attr_reader :type
  def initialize(number)
    super(number)
    @type = :cargo
  end

  private

  def attach_wagon(wagon)
    raise 'К этому поезду можно прицепить только грузовой вагон' unless wagon.class == CargoWagon

    super(wagon)
  end
end
