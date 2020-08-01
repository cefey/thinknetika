require_relative 'station.rb'
require_relative 'train.rb'
require_relative 'route.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_train.rb'
require_relative 'wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'

class RailRoad
  attr_accessor :trains, :stations
  def initialize
    @trains = []
    @stations = []
  end

  def main_menu
    puts 'Выберите действие: '
    puts '1. Меню станций '
    puts '2. Меню поездов '
    puts '0. Выйти из программы'

    choice = gets.chomp

    case choice
    when '1'
      stations_menu
    when '2'
      trains_menu
    when '0'
      exit
    else
      error_message
    end
  end

  private

  def stations_menu
    puts 'Сделайте выбор'
    puts '1. Создать станцию'
    puts '2. Удалить станцию'
    puts '3. Показать список созданных станций'
    puts '0. Главное меню'

    choice = gets.chomp

    case choice
    when '1'
      create_station
      stations_menu
    when '2'
      delete_station
      stations_menu
    when '3'
      station_list
      stations_menu
    when '0'
      main_menu
    else
      error_message
    end
  end

  def create_station
    puts 'Введите название станици'
    station_name = gets.chomp.to_s
    station = Station.new(station_name)
    @stations << station
    puts "Станция #{station_name} успешно создана"
  end

  def find_station(station_name)
    @stations.find { |station| station.name == station_name }
  end

  def station_list
    if @stations.empty?
      puts 'Список станций пуст'
    else
      @stations.each { |station| puts station.name }
    end
  end

  def delete_station
    puts 'Все созданные станции'
    station_list
    puts 'Введите название станции, которую нужно удалить'
    station_name = gets.chomp.to_s
    @stations.delete(find_station(station_name))
    puts "Станция #{station_name} успешно удалена"
  end

  def error_message
    puts 'Введены некорректные данные.Проверьте введенные данные'
    main_menu
  end

  def trains_menu
    puts 'Сделайте выбор'
    puts '1. Создать поезд'
    puts '2. Назначить маршрут поезду'
    puts '3. Отправить поезд по маршруту вперед'
    puts '4. Отправить поезд по маршруту назад'
    puts '5. Прицепить вагон'
    puts '6. Отцепить вагон'
    puts '7. Добавить станцию в маршрут'
    puts '8. Удалить станцию из маршрута'
    puts '9. Показать все созданные поезда'
    puts '0. Главное меню'

    choice = gets.chomp

    case choice
    when '1'
      create_train
      trains_menu
    when '2'
      give_route
      trains_menu
    when '3'
      train_forward
      trains_menu
    when '4'
      train_backward
      trains_menu
    when '5'
      add_wagon
      trains_menu
    when '6'
      remove_wagon
      trains_menu
    when '7'
      add_station_in_route
      trains_menu
    when '8'
      delete_station_from_route
      trains_menu
    when '9'
      station_list
      trains_menu
    when '0'
      main_menu
    else
      error_message
    end
  end

  def create_train
    puts 'Выберите тип поезда'
    puts '1. Пассажирский'
    puts '2. Грузовой'
    choice = gets.chomp
    puts 'Введите номер поезда'
    train_number = gets.chomp

    case choice
    when '1'
      train = PassengerTrain.new(train_number)
      @trains << train
    when '2'
      train = CargoTrain.new(train_number)
      @trains << train
    else
      error_message
    end
    puts "Поезд #{train_number} успешно создан"
  end

  def give_route
    puts 'Выберите поезд'
    trains_list
    train_number = gets.chomp
    puts 'Все созданные станции'
    station_list
    puts 'Введите начальную станцию'
    station_name_from = gets.chomp.to_s
    puts 'Введите конечную станцию'
    station_name_to = gets.chomp.to_s
    route = Route.new(find_station(station_name_from), find_station(station_name_to))
    find_train(train_number).take_route(route)
    puts 'Маршрут назначен'
  end

  def find_train(train_number)
    @trains.find { |train| train.number == train_number }
  end

  def trains_list
    @trains.each { |train| puts train.number }
  end

  def add_wagon
    trains_list
    puts 'Введите номер поезда'
    train_number = gets.chomp
    if find_train(train_number).type == :cargo
      wagon = CargoWagon.new
    elsif find_train(train_number).type == :passenger
      wagon = PassengerWagon.new
    end
    find_train(train_number).add_wagon(wagon)
    puts 'Вагон успешно добавлен'
    puts "У поезда #{train_number} - #{find_train(train_number).wagons.size} вагонов"
  end

  def remove_wagon
    puts 'Введите номер поезда'
    trains_list
    train_number = gets.chomp
    find_train(train_number).remove_wagon
    puts 'Вагон успешно отцеплен'
    puts "У поезда #{train_number} - #{find_train(train_number).wagons.size} вагонов"
  end

  def train_forward
    trains_list
    puts 'Введите номер поезда'
    train_number = gets.chomp
    find_train(train_number).forward
  end

  def train_backward
    trains_list
    puts 'Введите номер поезда'
    train_number = gets.chomp
    find_train(train_number).backward
  end

  def add_station_in_route
    trains_list
    puts 'Введите номер поезда'
    train_number = gets.chomp
    puts 'Введите название промежуточной станции'
    station_list
    station_name = gets.chomp
    puts 'Введите название следующей станции'
    next_station_name = gets.chomp
    find_train(train_number).route.add_intermediate(find_station(station_name), find_station(next_station_name))
    puts 'Промежуточная станция успешно добавлена'
  end

  def delete_station_from_route
    trains_list
    puts 'Введите номер поезда'
    train_number = gets.chomp
    puts 'Введите название промежуточной станции'
    station_list
    station_name = gets.chomp
    find_train(train_number).route.delete_station(find_station(station_name))
    puts 'Промежуточная станция успешно удалена'
  end
end

