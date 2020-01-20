# frozen_string_literal: true

require_relative 'instance_count'
require_relative 'validator'

class Station
  include InstanceCount
  include Validator

  STATION_NAME_FORMAT = /^\w+$/.freeze
  @stations = []
  class << self
    attr_accessor :stations
    alias all stations
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.stations << self
    register_instance
  end

  def each_train
    raise 'There are no trains at the station' if trains.empty?

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
    raise 'Wrong name format' if @name !~ STATION_NAME_FORMAT
    raise 'Wrong name: At least 2 symbols' if @name.length < 2
  end
end
