require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'
require_relative 'station'
require_relative 'object_selector'

class RailRoadFabric
  include ObjectSelector
  def initialize
    @trains = []
    @wagons = []
    @stations = []
    @routes = []
  end

  def create_train(type)
    puts 'Enter train number'
    number = gets.chomp

    train = type == 1 ? PassengerTrain.new(number) : CargoTrain.new(number)
    @trains << train
    puts "Passenger train №#{number} has been created" if type == 1
    puts "Cargo train №#{number} has been created" if type == 2
    train_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_wagon(type)
    puts 'Enter wagon number'
    number = gets.chomp
    puts 'Enter seats count/ volume at the wagon'
    count = gets.chomp.to_i
    create_train_temp(type, number, count)
    wagon_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_train_temp(type, number, count)
    param = [number, count]
    wagon = type == 1 ? PassengerWagon.new(*param) : CargoWagon.new(*param)
    @wagons << wagon
    puts "Passenger wagon №#{number} has been created" if type == 1
    puts "Cargo wagon №#{number} has been created" if type == 2
  end

  def create_station
    puts 'Enter station name'
    name = gets.chomp

    @stations << Station.new(name)
    puts "Station '#{@stations.last.name}' has been created"
    station_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_route_temp(start, finish)
    @routes << Route.new(start, finish)
    puts "Route '#{start.name}' -> '#{finish.name}' has been created"
  end

  def create_route
    raise 'Error: Create at least 2 stations' if @stations.length < 2

    puts 'Start station:'
    start = select_station(@stations)
    puts 'End station:'
    finish = select_station(@stations)
    create_route_temp(start, finish)
    station_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def station_block(station)
    raise 'No stations created yet' if @stations.empty?

    station.each_train do |train|
      print "Train number:#{train.number}. Type: #{train.type}."
      puts "Wagons count: #{train.wagons.count}"
    end
  end

  def trains_on_station
    station = select_station(@stations)
    station_block(station)
  rescue RuntimeError => e
    puts e.message
  ensure
    station_control_menu
  end

  def wagons_of_train
    raise 'No trains created yet' if @trains.empty?

    train = select_train(@trains)
    train_block(train)
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def train_block(train)
    train.each_wagon do |wagon|
      print "Wagon number: #{wagon.number}. Type: #{wagon.type}. "
      if wagon.type == :passenger
        puts "Free seats count: #{wagon.free_volume}. "\
             "Reserved seats count: #{wagon.reserved_volume}"
      else
        puts "Reserved volume: #{wagon.reserved_volume}. "\
             "Free volume: #{wagon.free_volume}"
      end
    end
  end
end
