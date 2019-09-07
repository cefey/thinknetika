require_relative 'instance_counter.rb'
class Route
  include InstanceCounter

  attr_reader :stations
  def initialize(station_from, station_to)
    @station_from = station_from
    @station_to = station_to
    @stations = [station_from, station_to]
  end

  def add_intermediate(intermediate_station, next_station)
    stations.insert(stations.index(next_station), intermediate_station)
  end

  def delete_station(station)
    stations.delete(station)
  end
end

