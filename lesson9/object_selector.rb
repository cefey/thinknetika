module ObjectSelector
  def get_action_id(final, start = 0)
    case action = gets.chomp
    when 'q' then exit
    else
      id = action.to_i
      raise 'Select a number from the list' unless (start..final).cover? id

      id
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def station_list(stations)
    raise 'No stations created yet' if stations.empty?

    puts 'Existing stations:'
    stations.each.with_index(1) { |station, i| puts "#{i}. #{station.name}" }
  end

  def route_list(routes)
    raise 'No routes created yet' if routes.empty?

    puts 'Existing routes:'
    routes.each.with_index(1) do |route, index|
      puts "#{index}. #{route.start.name} -> #{route.finish.name}"
    end
  end

  def train_list(trains)
    raise 'No trains created yet' if trains.empty?

    puts 'Existing trains:'
    trains.each.with_index(1) do |train, index|
      puts "#{index}. Train №#{train.number}. Type #{train.type}"
    end
  end

  def wagon_list(wagons)
    raise 'No wagons created yet' if wagons.empty?

    puts 'Existing wagon:'
    wagons.each.with_index(1) do |wagon, index|
      puts "#{index}. Wagon №#{wagon.number}. Type #{wagon.type}"
    end
  end

  def select_train(trains)
    puts 'Select a train' unless trains.empty?
    train_list(trains)

    index = get_action_id(trains.length, 1)
    trains[index - 1]
  end

  def select_wagon(wagons)
    raise 'No wagons created yet' if wagons.empty?

    wagon_list(wagons)

    index = get_action_id(wagons.length, 1)
    wagons[index - 1]
  end

  def select_station(stations)
    puts 'Select a station' unless stations.empty?
    station_list(stations)

    index = get_action_id(stations.length, 1)
    stations[index - 1]
  end

  def select_route(routes)
    puts 'Select a route' unless routes.empty?
    route_list(routes)

    index = get_action_id(routes.length, 1)
    routes[index - 1]
  end

  def select_train_type
    puts 'Select an action'
    puts '1. Create a passenger train'
    puts '2. Create a cargo train'
    get_action_id(2, 1)
  end

  def select_wagon_type
    puts 'Select an action'
    puts '1. Create a passenger wagon'
    puts '2. Create a cargo wagon'
    get_action_id(2)
  end

  def read_file(filename)
    file = File.open("./#{filename}")
    file.each { |str| puts str }
    file.close
  end

  def main_menu_action
    read_file('main_menu_text.txt')
    get_action_id(3)
  end

  def train_menu_action
    read_file('train_menu_text.txt')
    get_action_id(5)
  end

  def wagon_menu_action
    read_file('wagon_menu_text.txt')
    get_action_id(4)
  end

  def station_menu_action
    read_file('station_menu_text.txt')
    get_action_id(5)
  end
end
