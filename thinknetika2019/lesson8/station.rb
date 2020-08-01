require_relative 'instance_count'
require_relative 'validator'

class Station
  include InstanceCount
  include Validator

  STATION_NAME_FORMAT = /^\w+$/.freeze
  @@stations = []

  def self.all
    @@stations
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def each_train
    raise 'На станции нет поездов' if trains.empty?

    trains.each { |train| yield train }
  end

  def take_train(train)
    @trains << train if train.current_station == self
  end

  def trains_count(type)
    @trains.count { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train)
  end

  def validate!
    raise 'Неверный формат названия станции' if @name !~ STATION_NAME_FORMAT
    raise 'Название станции должно содержать минимум два символа' if @name.length < 2
  end
end
