require_relative 'manufacturer'
require_relative 'validator'

class Wagon
  include Manufacturer
  include Validator

  WAGON_NUMBER_FORMAT = /^[а-яa-z\d]{2,}/.freeze

  attr_reader :number, :train

  def initialize(number)
    @number = number.to_s
    @train = nil
    validate!
  end

  def attached?
    train
  end

  def attach_to_train(train)
    raise "Вагон уже прицеплен к поезду №#{@train.number}" if attached?

    @train = train if train.wagons.include? self
  end

  def detach_from_train(train)
    @train = nil if @train == train
  end

  def validate!
    raise 'Номер вагона не может быть пустым' unless number
    raise 'Неверный формат номера вагона' if number.to_s !~ WAGON_NUMBER_FORMAT
    raise 'Слишком короткий номер вагона. Не менее двух символов' if number.length < 2
  end
end
