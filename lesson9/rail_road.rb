# frozen_string_literal: true

require_relative 'rail_road_fabric'

class RailRoad < RailRoadFabric
  def change_route(act)
    route = select_route(@routes)
    station = select_station(@stations)
    act == 'add' ? add_station(route, station) : delete_station(route, station)
    station_control_menu
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def add_station(route, station)
    puts 'Enter station position on the route'
    position = get_action_id(@stations.length)

    route.add_station(station, position)
    puts 'Station has been added to the route'
  end

  def delete_station(station, route)
    route.delete_station(station)
    puts 'Station has been deleted from the route'
  end

  def change_train(action)
    train = select_train(@trains)
    wagon = select_wagon(@wagons)

    action == 'add' ? add_wagon(train, wagon) : delete_wagon(train, wagon)
  rescue RuntimeError => e
    puts e.message
  ensure
    wagon_control_menu
  end

  def add_wagon(train, wagon)
    train.attach_wagon!(wagon)
    puts 'The wagon has been attached to the train'
  end

  def delete_wagon(train, wagon)
    train.detach_wagon!(wagon)
    puts 'The wagon has been detached from the train'
  end

  def move_train(action)
    train = select_train(@trains)

    action == 'next' ? train.go_to_next : train.go_to_previous
    puts "The train moved to station #{train.current_station.name}"
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def train_route
    train = select_train(@trains)
    route = select_route(@routes)
    train.take_route(route)
    puts "Train assigned route '#{route.start.name}' -> '#{route.finish.name}'"
  rescue RuntimeError => e
    puts e.message
  ensure
    train_control_menu
  end

  def take_place_at_wagon
    wagon = select_wagon(@wagons)
    wagon.type == :passenger ? book_seat(wagon) : book_volume(wagon)
  rescue RuntimeError => e
    puts e.message
  ensure train_control_menu
  end

  def book_volume(wagon)
    puts 'How much volume need to reserve?'
    volume = gets.chomp.to_i
    wagon.book_volume(volume)
    puts 'Volume successfully reserved'
  end

  def book_seat(wagon)
    wagon.book_seat
    puts 'Seat successfully reserved'
  end
end
