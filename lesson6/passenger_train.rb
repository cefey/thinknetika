class PassengerTrain < Train

  private

  def attach_wagon(wagon)
    super(wagon) if wagon.class == PassengerWagon
  end
end
