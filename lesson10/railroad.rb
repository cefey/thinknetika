require_relative './seed.rb'
class RailRoad
  attr_accessor :trains, :routes, :stations, :unused_carriages, :first_station, :last_station
  attr_reader :station, :number

  include Seed
  include Validation
  
  validate :first_station, :presence
  validate :last_station, :presence

  def initialize
    @trains = []
    @routes = []
    @stations = []
    @unused_wagons = []
  end

  def train_menu
    all_trains
    print 'Выберите поезд (порядковый номер) или введите 0 для возврата в главное меню: '
    input = gets.chomp.to_i
    if input.zero?
      main_menu
    else
      @train = @trains[input - 1]
      puts "Выбран поезд #{@train.number}"
      puts '1. Назначить маршрут'
      puts '2. Добавить вагоны к поезду'
      puts '3. Отцепить вагоны от поезда'
      puts '4. Переместить поезд'
      puts '5. Выбрать другой поезд'
      puts '6. Создать другой поезд'
      puts '0. Главное меню'
      print 'Выберите пункт меню '
      input = gets.chomp.to_i
      case input
      when 1
        all_routes
        print 'Выберите маршрут: '
        route = gets.chomp.to_i
        @train.route_set(@routes[route - 1])
        train_menu
      when 2
        all_wagons
        print 'Выберите вагон: '
        wagon = gets.chomp.to_i
        @train.wagons_add(@unused_wagons[wagon - 1])
        train_menu
      when 3
        train_wagons
        print 'Выберите вагон: '
        wagon = gets.chomp.to_i
        @train.wagons_remove(@train.wagons[wagon - 1])
        train_menu
      when 4
        direction = ''
        until direction.zero?
          if @train.route.nil?
            puts 'Сначала назначьте маршрут'
            train_menu
          else
            move_train_menu
            direction = gets.chomp.to_i
            if direction == 1
              @train.move_next
            elsif direction == 2
              @train.move_prev
            end
          end
        end
      when 5
        train_menu
      when 6
        create_train
        train_menu
      when 0
        main_menu
      end
    end
  end

  def station_menu
    input = ''
    until input.nil?
      puts '1. Создать станцию'
      puts '2. Посмотреть список всех станций'
      puts '3. Посмотреть поезда на станции'
      puts '0. Главное меню'

      print 'Выберите пункт меню: '
      input = gets.chomp.to_i
      case input
      when 1
        create_station
        station_menu
      when 2
        all_stations
        station_menu
      when 3
        all_stations
        print 'Выберите станцию: '
        station = gets.chomp.to_i
        @stations[station - 1].trains_list
        station_menu
      end
    end
    main_menu
  end

  def route_menu
    puts '1. Создать маршрут'
    puts '2. Посмотреть список всех маршрутов'
    puts '3. Добавить станцию в маршрут'
    puts '0. Главное меню'
    print 'Выберите пункт меню: '
    input = gets.chomp.to_i
    case input
    when 1
      create_route
      route_menu
    when 2
      all_routes
      route_menu
    when 3
      all_routes
      puts
      print 'Выберите маршрут '
      route = gets.chomp.to_i
      all_stations
      print 'Выберите станцию '
      station = gets.chomp.to_i
      @routes[route - 1].station_add(@stations[station - 1])
    when 0
      main_menu
    end
    route_menu
  end

  def create_route
    puts 'Введите начальную станцию маршрута:'
    @first_station = gets.chomp
    @first_station = Station.new(@first_station)
    puts 'Введите конечную станцию маршрута:'
    @last_station = gets.chomp
    @last_station = Station.new(@last_station)
    @routes << Route.new(@first_station, @last_station)
    route_menu
  end

  def create_station
    print 'Введите название новой станции:'
    input = gets.chomp
    @stations << Station.new(input)
    station_menu
  end

  def create_train
    begin
    print 'Введите номер поезда: '
    number = gets.chomp
    print 'Выберите тип поезда (cargo, passenger):'
    type = gets.chomp
    if type == 'cargo'
      @trains << CargoTrain.new(number)
    elsif type == 'passenger'
      @trains << PassengerTrain.new(number)
    end
    raise unless type == 'cargo' || type == 'passenger'
  rescue StandardError => e
    puts e.to_s
    puts "Введите 'cargo' или 'passenger'"
    retry
  end
    begin
      train = Train.new(number, type)
    rescue StandardError => e
      puts e.to_s
      puts 'Неверный формат номера поезда'
      retry
    end
    train_menu
  end

  def all_stations
    @stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def move_train_menu
    puts '1. Вперед'
    puts '2. Назад'
    puts '0. Главное меню'
    print 'В какую сторону переместить поезд? '
  end

  def all_trains
    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number} | #{train.type}"
    end
  end

  def all_wagons
    @unused_wagons.each.with_index(1) do |wagon, index|
      puts "#{index}. #{wagon.number} - #{wagon.type}"
    end
  end

  def train_wagons
    @train.wagons.each.with_index(1) do |wagon, index|
      puts "#{index}. #{wagon.number} - #{wagon.type}"
    end
  end

  def all_routes
    @routes.each.with_index(1) do |route, index|
      puts "#{index}. #{route.stations[0].name} - #{route.stations[-1].name}"
      puts 'Включает станции: '
      route.stations.each do |station|
        puts station.name.to_s
      end
    end
  end

  def main_menu
    puts 'Программа управления железной дорогой'
    puts 'Выберите пункт меню, нажав соответствующую цифру'
    puts '1. Вывести информацию о поездах'
    puts '2. Вывести информацию о станциях'
    puts '3. Вывести информацию о маршрутах'
    puts '0. Выход'
    input = gets.chomp.to_i
    until input.zero?
      system('clear')
      if input == 1
        system('clear')
        train_menu
      elsif input == 2
        system('clear')
        station_menu
      elsif input == 3
        system('clear')
        route_menu
      else
        main_menu
      end
    end
    puts 'Пока.'
    exit
  end
end
