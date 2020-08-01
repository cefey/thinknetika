require_relative 'manufacturer'
require_relative 'instance_count'
require_relative 'validator'

class Train
  include Manufacturer
  include InstanceCount
  include Validator

  TRAIN_NUMBER_FORMAT = /^[а-яa-z\d]{3}-?[а-яa-z\d]{2}$/i.freeze

  @@trains ||= {}

  def self.find(number)
    @@trains[number]
  end
  attr_accessor :number
  attr_reader :current_station, :speed, :wagons, :route

  def initialize(number)
    @number = number.to_s
    @wagons = []
    @speed = 0
    validate!
    @@trains[number] = self
    register_instance
  end

  def stop
    @speed = 0
  end

  def stopped?
    @speed.zero?
  end

  def increase_speed(speed)
    @speed += speed if speed.positive?
  end

  def attach_wagon!(wagon)
    raise 'Вагон не может быть прицеплен, пока поезд движется' unless stopped?

    attach_wagon(wagon)
  end

  def detach_wagon!(wagon)
    raise 'Вагон не может быть прицеплен, пока поезд движется' unless stopped?

    detach_wagon(wagon)
  end

  def take_route(route)
    @route = route.route
    @current_station = @route[0]
    @current_station.take_train(self)
  end

  def has_next_station?
    raise 'Поезд не назначен на маршрут' unless @current_station
    raise 'Текущая станция является последней в маршруте' if @current_station == @route.last

    true
  end

  def go_to_next
    has_next_station?
    @current_station.send_train(self)
    @current_station = @route[@route.index(@current_station) + 1]
    @current_station.take_train(self)
  end

  def has_previous_station?
    raise 'Поезд не назначен на маршрут' unless @current_station
    raise 'Текущая станция является первой в маршруте' if @current_station == @route.first

    true
  end

  def go_to_previous
    has_previous_station?
    @current_station.send_train(self)
    @current_station = @route[@route.index(@current_station) - 1]
    @current_station.take_train(self)
  end

  def next_station
    has_next_station?
  end

  def previous_station
    has_previous_station?
  end

  private

  # нельзя просто назначить маршрут, не назначив при этом начальную\конечную станцию
  attr_writer :route

  # прицепить вагон можно только при определенных условиях, отцепить тоже
  def attach_wagon(wagon)
    @wagons << wagon
    wagon.attach_to_train(self)
  end

  def detach_wagon(wagon)
    raise 'Вагон не был прицеплен к данному поезду' unless wagons.include? wagon

    @wagons.delete(wagon)
    wagon.detach_from_train(self)
  end

  def validate!
    raise 'Неверный формат номера поезда' if number.to_s !~ TRAIN_NUMBER_FORMAT
  end
end
