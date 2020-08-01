require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'
require_relative 'station'

class RailRoad
  def initialize
    @trains = []
    @wagons = []
    @stations = []
    @routes = []
    puts 'Привет! Это маленькая приветственная инструкция.
На протяжении исполнения всей программы при выборе действия или объекта
0 - вернет Вас в главное меню
q - завершит исполнение'
  end

  def main_menu
    puts 'Выберите действие'
    puts '1. Перейти в меню управления поездами и вагонами'
    puts '2. Перейти в меню управления станциями и маршрутами'
    user_action = get_action_id(2)
    case user_action
    when 0
      exit
    when 1
      train_control_menu
    else
      station_control_menu
    end
  end

  def train_control_menu
    puts 'Выберите действие'
    puts '1. Cоздать новый поезд'
    puts '2. Cоздать новый вагон'
    puts '3. Прицепить вагон к поезду'
    puts '4. Отцепить вагон от поезда'
    puts '5. Назначить маршрут поезду'
    puts '6. Переместить поезд на следующую станцию'
    puts '7. Переместить поезд на предыдущую станцию'
    puts '8. Посмотреть список вагонов для поезда'
    puts '9. Занять место или объем в вагоне'
    train_action = get_action_id(9)

    case train_action
    when 0
      main_menu
    when 1
      create_train(select_train_type)
    when 2
      create_wagon(select_wagon_type)
    when 3
      change_train('add')
    when 4
      change_train('delete')
    when 5
      train_route
    when 6
      move_train('next')
    when 7
      move_train('previous')
    when 8
      wagons_of_train
    when 9
      take_place_at_wagon
    end
  end

  def station_control_menu
    puts 'Выберите действие'
    puts '1. Cоздать станцию'
    puts '2. Cоздать маршрут'
    puts '3. Добавить станцию в маршрут'
    puts '4. Удалить станцию из маршрута'
    puts '5. Посмотреть список поездов на станции'
    station_action = get_action_id(5)

    case station_action
    when 0
      main_menu
    when 1
      create_station
    when 2
      create_route
    when 3
      change_route('add')
    when 4
      change_route('delete')
    when 5
      trains_on_station
    end
  end

  def get_action_id(range_final)
    action = gets.chomp

    raise StandardError if action == 'q'
    return main_menu if action == '0'
    raise 'Что-то пошло не так, введите номер действия/объекта из списка' unless action.to_i.to_s == action
    raise 'Введите номер действия/объекта из списка' unless (0..range_final).cover? action.to_i

    action.to_i
  rescue RuntimeError => e
    puts e.message
    retry
  rescue StandardError
    exit
  end

  # Select an object or type

  def select_train
    puts 'Выберите поезд' unless @trains.empty?
    train_list

    index = get_action_id(@trains.length)
    @trains[index - 1]
  rescue RuntimeError => e
    puts e.message
    train_control_menu
  end

  def select_wagon
    raise 'Пока не создано ни одного вагона' if @wagons.empty?

    wagon_list

    index = get_action_id(@wagons.length)
    @wagons[index - 1]
  rescue RuntimeError => e
    puts e.message
    train_control_menu
  end

  def select_station
    puts 'Выберите станцию' unless @stations.empty?
    station_list

    index = get_action_id(@stations.length)
    @stations[index - 1]
  rescue RuntimeError => e
    puts e.message
    station_control_menu
  end

  def select_route
    puts 'Выберите маршрут' unless @routes.empty?
    route_list

    index = get_action_id(@routes.length)
    @routes[index - 1]
  rescue RuntimeError => e
    puts e.message
    station_control_menu
  end

  def select_train_type
    puts 'Выберите действие'
    puts '1. Cоздать пассажирский поезд '
    puts '2. Cоздать грузовой поезд'
    get_action_id(2)
  end

  def select_wagon_type
    puts 'Выберите действие'
    puts '1. Cоздать пассажирский вагон'
    puts '2. Cоздать грузовой вагон'
    get_action_id(2)
  end

  # Create an object

  def create_train(type)
    puts 'Введите номер поезда'
    number = gets.chomp

    train =
      case type
      when 1
        PassengerTrain.new(number)
      else
        CargoTrain.new(number)
      end
    @trains << train
    puts "Пассажирский поезд №#{number} успешно создан" if type == 1
    puts "Грузовой поезд №#{number} успешно создан" if type == 2
    train_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  rescue ArgumentError
    puts 'У поезда должен быть номер'
    retry
  end

  def create_wagon(type)
    puts 'Введите номер вагона'
    number = gets.chomp

    wagon =
      case type
      when 1
        puts 'Введите количество мест в вагоне'
        seats = gets.chomp.to_i
        PassengerWagon.new(number, seats)
      else
        puts 'Введите объем вагона (в куб.м)'
        volume = gets.chomp.to_i
        CargoWagon.new(number, volume)
      end
    @wagons << wagon
    puts "Пассажирский вагон №#{number} успешно создан" if type == 1
    puts "Грузовой вагон №#{number} успешно создан" if type == 2
    train_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  rescue ArgumentError
    puts 'У вагона должен быть номер'
    retry
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp

    @stations << Station.new(name)
    puts "Станция '#{@stations.last.name}' успешно создана"
    station_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_route
    return puts 'Для создания маршрута необходимо хотя бы две существующих станции' if @stations.length < 2

    puts 'Начальная станция:'
    start = select_station

    puts 'Конечная станция:'
    finish = select_station

    @routes << Route.new(start, finish)
    puts "Маршрут '#{start.name}' -> '#{finish.name}' успешно создан"
  rescue RuntimeError => e
    puts e.message
    retry
  ensure
    station_control_menu
  end

  # Object list

  def station_list
    raise 'Пока не создано ни одной станции' if @stations.empty?

    puts 'Существующие станции:'
    @stations.each.with_index(1) { |station, index| puts "#{index}. #{station.name}" }
  end

  def route_list
    raise 'Пока не создано ни одного маршрута' if @routes.empty?

    puts 'Существующие маршруты:'
    @routes.each.with_index(1) { |route, index| puts "#{index}. #{route.start.name} -> #{route.finish.name}" }
  end

  def train_list
    raise 'Пока не создано ни одного поезда' if @trains.empty?

    puts 'Существующие поезда:'
    @trains.each.with_index(1) { |train, index| puts "#{index}. Поезд №#{train.number}. Тип #{train.type}" }
  end

  def wagon_list
    raise 'Пока не создано ни одного вагона' if @wagons.empty?

    puts 'Существующие вагоны:'
    @wagons.each.with_index(1) { |wagon, index| puts "#{index}. Вагон №#{wagon.number}. Тип #{wagon.type}" }
  end

  def station_block(station)
    raise 'Пока не создано ни одной станции' if @stations.empty?

    station.each_train do |train|
      print "Номер поезда:#{train.number}. Тип:#{train.type}."
      puts "Количество вагонов: #{train.wagons.count}"
    end
  end

  def trains_on_station
    station = select_station
    station_block(station)
  rescue RuntimeError => e
    puts e.message
  ensure
    station_control_menu
  end

  def wagons_of_train
    train = select_train
    train_block(train)
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def train_block(train)
    raise 'Пока не создано ни одного поезда' if @trains.empty?

    train.each_wagon do |wagon|
      print "Номер вагона:#{wagon.number}. Тип:#{wagon.type}."
      if wagon.type == :passenger
        puts "Количество свободных мест: #{wagon.free_volume}. Количество занятых мест: #{wagon.reserved_volume}"
      else
        puts "Занимаемый объем: #{wagon.reserved_volume}. Свободный объем: #{wagon.free_volume}"
      end
    end
  end

  # Change object

  def change_route(action)
    route = select_route
    station = select_station

    if action == 'add'
      puts 'Введите позицию станции в маршруте'
      position = get_action_id(@stations.length)

      route.add_station(station, position)
      p 'Станция добавлена в маршрут'
    else
      route.delete_station(station)
      p 'Станция удалена из маршрута'
    end
    station_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def change_train(action)
    train = select_train
    wagon = select_wagon

    if action == 'add'
      train.attach_wagon!(wagon)
      puts 'Вагон успешно прицеплен к поезду'
    else
      train.detach_wagon!(wagon)
      puts 'Вагон успешно отцеплен от поезда'
    end
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def move_train(action)
    train = select_train

    if action == 'next'
      train.go_to_next
      puts "Поезд перемещен на станцию #{train.current_station.name}"
    else
      train.go_to_previous
      puts "Поезд перемещен на станцию #{train.current_station.name}"
    end
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def train_route
    train = select_train
    route = select_route
    train.take_route(route)
    puts "Поезду №#{train.number} назначен маршрут '#{route.start.name}' -> '#{route.finish.name}'"
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def take_place_at_wagon
    wagon = select_wagon
    if wagon.type == :passenger
      wagon.book_volume
      puts 'Место успешно забронировано'
    else
      puts 'Какой объем( в куб.м) необходимо занять?'
      volume = gets.chomp.to_i
      wagon.book_volume(volume)
      puts 'Указанный объем успешно занят'
    end
  rescue RuntimeError => e
    puts e.message
  ensure train_control_menu
  end
end

rr = RailRoad.new
rr.main_menu
