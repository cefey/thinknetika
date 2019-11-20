# frozen_string_literal: true

require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'
require_relative 'station'
require_relative 'manufacturer'

class RailRoadFabric
  attr_accessor :trains, :wagons, :stations, :routes

  def initialize
    @trains = []
    @wagons = []
    @stations = []
    @routes = []
  end

  def user_action
    loop do
      case option_number.to_i
      when 1
        create_train
      when 2
        create_wagon
      when 3
        create_station
      when 4
        create_route
      when 5
        change_route('add')
      when 6
        change_route('delete')
      when 7
        change_train('add')
      when 8
        change_train('delete')
      when 9
        move_train('next')
      when 10
        move_train('previous')
      when 11
        station_list
      when 12
        trains_on_station
      when 13
        train_route
      when 14
        exit
      else
        user_action
      end
    end
  end

  def option_number
    puts 'Чтобы создать поезд введите 1'
    puts 'Чтобы создать вагон введите 2'
    puts 'Чтобы создать станцию введите 3'
    puts 'Чтобы создать маршрут введите 4'
    puts 'Чтобы добавить станцию в маршрут введите 5'
    puts 'Чтобы удалить станцию из маршрут введите 6'
    puts 'Чтобы прицепить вагон к поезду введите 7'
    puts 'Чтобы отцепить вагон от поезда введите 8'
    puts 'Чтобы переместить поезд на следующую станцию введите 9'
    puts 'Чтобы переместить поезд на предыдущую станцию введите 10'
    puts 'Чтобы просмотреть список станций введите 11'
    puts 'Чтобы просмотреть список поездов на станциях введите 12'
    puts 'Чтобы назначить маршрут поезду введите 13'
    puts 'Чтобы выйти введите 14'
    gets.chomp
  end

  def create_train
    puts 'Чтобы создать пассажирский поезд введите 1'
    puts 'Чтобы создать грузовой поезд введите 2'
    type = gets.to_i
    puts 'Введите номер поезда'
    number = gets.to_i

    train =
      case type
      when 1
        PassengerTrain.new(number)
      when 2
        CargoTrain.new(number)
      else
        create_train
      end
    @trains << train
  end

  def create_wagon
    puts 'Чтобы создать пассажирский вагон введите 1'
    puts 'Чтобы создать грузовой вагон введите 2'
    type = gets.to_i
    puts 'Введите номер вагона'
    number = gets.to_i

    wagon =
      if type == 1
        PassengerWagon.new(number)
      elsif type == 2
        CargoWagon.new(number)
      else
        create_wagon
      end
    @wagons << wagon
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp.to_s

    @stations << Station.new(name)
  end

  def station_list
    puts 'Существующие станции:'
    @stations.each.with_index(1) { |station, index| puts "#{index} #{station.name}" }
  end

  def create_route
    puts 'Начальная станция:'
    start = select_station

    puts 'Конечная станция:'
    finish = select_station

    @routes << Route.new(start, finish)
  end

  def change_route(action)
    route = select_route
    station = select_station

    if action == 'add'
      puts 'Введите позицию станции в маршруте'
      position = gets.to_i

      route.add_station(station, position)
    else
      route.delete_station(station)
    end
  end

  def select_station
    puts 'Введите порядковый номер станции'
    station_list

    index = gets.to_i
    station = @stations[index - 1]

    return station if station

    select_station
  end

  def select_route
    puts 'Введите порядковый номер маршрута'
    route_list

    index = gets.to_i
    route = @routes[index - 1]

    return route if route

    select_route
  end

  def select_train
    puts 'Выберите поезд'
    train_list

    index = gets.to_i
    train = @trains[index - 1]

    return train if train

    select_train
  end

  def select_wagon
    puts 'Выберите вагон'
    wagon_list

    index = gets.to_i
    wagon = @wagons[index - 1]

    return wagon if wagon

    select_wagon
  end

  def route_list
    puts 'Существующие маршруты:'
    @routes.each.with_index(1) { |route, index| puts "#{index}) #{route.start.name} -> #{route.finish.name}" }
  end

  def train_list
    puts 'Существующие поезда:'
    @trains.each.with_index(1) { |train, index| puts "#{index}) #{train.number}" }
  end

  def wagon_list
    puts 'Существующие вагоны:'
    @wagons.each.with_index(1) { |wagon, index| puts "#{index}) #{wagon.number}" }
  end

  def change_train(action)
    train = select_train
    wagon = select_wagon

    if action == 'add'
      train.attach_wagon!(wagon)
    else
      train.detach_wagon!(wagon)
    end
  end

  def trains_on_station
    trains = select_station.trains
    puts 'Поезда, находящиеся на станции:'
    trains.each { |train| puts 'Поезд номер' + train.number.to_s }
  end

  def move_train(action)
    train = select_train

    if action == 'next'
      train.go_to_next
    else
      train.go_to_previous
    end
  end

  def train_route
    train = select_train
    route = select_route
    train.take_route(route)
  end
end
