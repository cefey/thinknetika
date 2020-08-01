class Wagon
  attr_reader :number, :train

  def initialize(number)
    @number = number
    @train = nil
  end

  def attached?
    train
  end

  def attach_to_train(train)
    unless attached?
      @train = train if train.wagons.include? self
    end
  end

  def detach_from_train(train)
    @train = nil if @train == train
  end
end

