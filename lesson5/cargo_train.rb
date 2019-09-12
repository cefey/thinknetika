class CargoTrain < Train

  private

  def attach_wagon(wagon)
    super(wagon) if wagon.class == CargoWagon
  end
end

