class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, 'passenger')
  end
end
