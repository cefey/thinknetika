require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
class Train
  include Manufacturer
  include InstanceCounter

  @@all_trains = {}

  attr_reader :wagons, :type, :number, :speed, :route
  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @@all_trains[number] = self
    register_instance
  end

  def self.find(number)
    @@all_trains[number]
  end

  def racing(new_speed)
    if new_speed.positive?
      @speed = new_speed
    else
      false
    end
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon unless move? || type != wagon.type
  end

  def remove_wagon
    @wagons.pop unless move? || @wagons.empty?
  end

  def count_wagons
    @wagons.size
  end

  def take_route(route)
    @route = route
    @route.stations[0].take_train(self)
  end

  def forward
    if next_station
      motion(@next_station)
    else
      false
    end
  end

  def backward
    if previous_station
      motion(@previous_station)
    else
      false
    end
  end

  def show_route
    [previous_station, current_station, next_station]
  end

  protected

  def current_station
    @current_station = @route.stations.find { |station| station.trains.include?(self) }
  end

  def previous_station
    if current_station == @route.stations[0]
      false
    else
      @previous_station = @route.stations[@route.stations.index(current_station) - 1]
    end
  end

  def next_station
    if current_station == @route.stations[-1]
      false
    else
      @next_station = @route.stations[@route.stations.index(current_station) + 1]
    end
  end
  #Отдельный метод движения (чтобы не повторять движение вперед или назад
  def motion(station) 
    @current_station.depart_train(self)
    station.take_train(self)
  end

  def move?
    @speed.positive?
  end
end

