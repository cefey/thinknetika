class Route
  include InstanceCounter
  include Validation
  attr_reader :stations, :first, :last

  validate :first, :presence
  validate :last, :presence

  def initialize(first, last)
    @first = first
    @last = last
    validate!
    @stations = [first, last]
    register_instance
  end

  def station_add(station)
    @stations.insert(-2, station)
    puts "Станция #{station.name} добавлена в маршрут"
  end

  def station_remove(station)
    @stations.delete(station)
  end

  def show_route
    puts "Станции на маршруте #{@stations[0]} - #{@stations[-1]}"
    @stations.each_with_index { |stations, i| puts "#{i + 1}. #{stations}" }
    puts
  end
end
