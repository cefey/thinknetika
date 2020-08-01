require_relative './route.rb'
require_relative './accessors.rb'
class Train
  include Company
  include InstanceCounter
  include Accessors
  include Validation

  attr_accessor :wagons, :route, :speed, :current_station
  attr_reader :number, :type
  attr_accessor_with_history :speed
  strong_attr_accessor :name, String

  NUMBER_FORMAT = /^\w{3}-?{1}\w{2}$/i

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  @@all_trains = {}

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @@all_trains[self.number] = self
    validate!
    register_instance
  end

  def block_wagon(&block)
    if block_given?
      @wagons.each(&block)
    else
      puts 'Блок не передан'
    end
  end

  def self.find(number)
    puts @@all_trains[number]
  end

  def route_set(route)
    @route = route
    @current_station = @route.stations.first
    @station_index = @route.stations.index(@current_station)
    @route.stations.first.accept_train(self)
  end

  def speedup
    @speed += 10
    puts "Поезд №#{@number}. Текущая скорость #{@speed} км/ч"
  end

  def stop
    @speed = 0
    puts "Поезд №#{@number}. Текущая скорость #{@speed} км/ч"
  end

  def train_length
    puts "Количество вагонов в поезде: #{@wagons.size}"
  end

  def wagons_add(wagon)
    if @type != wagon.type
      puts 'Тип вагона не совпадает с типом поезда'
    elsif @speed > 0
      puts 'Остановите поезд, чтобы прицепить вагоны'
    else
      @wagons << wagon
      puts 'Вагон прицеплен!'
      train_length
    end
  end

  def wagons_remove(wagon)
    if @speed > 0
      puts 'Остановите поезд, чтобы отцепить вагоны'
    elsif @wagons.include? wagon
      @wagons.delete(wagon)
      puts @wagons
      puts 'Вагон отцеплен!'
      train_length
    else
      puts 'Такого вагона не существует'
    end
  end

  def station_first?
    @current_station == @route.stations.first
  end

  def station_last?
    @current_station == @route.stations.last
  end

  def station_next
    if station_last?
      puts "Поезд №#{@number} находится на конечной станции"
    else
      @station_next = @route.stations[@station_index + 1]
    end
  end

  def station_prev
    if station_first?
      puts "Поезд №#{@number} находится на конечной станции"
    else
      @station_prev = @route.stations[@station_index - 1]
    end
  end

  def move_next
    if station_last?
      puts "Поезд №#{@number} находится на конечной станции маршрута"
    else
      @station_index += 1
      move
    end
  end

  def move_prev
    if station_first?
      puts "Поезд №#{@number} находится на начальной станции маршрута"
    else
      @station_index -= 1
      move
    end
  end

  protected

  def move
    @current_station.trains.delete(self)
    @next_station = @route.stations[@station_index]
    puts "Поезд № #{@number} был отправлен со станции '#{@current_station.name}'
     в сторону станции '#{@next_station.name}' "
    @prev_station = @current_station
    @current_station = @next_station
    @current_station.accept_train(self)
  end
end
