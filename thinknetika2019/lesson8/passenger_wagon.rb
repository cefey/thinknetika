class PassengerWagon < Wagon
  attr_reader :type

  def initialize(number, volume)
    super(number, volume)
    @type = :passenger
  end

  def book_volume
    raise 'Все места уже заняты' if free_volume.zero?

    super(1)
  end
end
