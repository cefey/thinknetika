require_relative 'instance_count'

class Route
  include InstanceCount

  @@routes = []

  attr_accessor :route
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @route = [start, finish]
    @@routes << self
    register_instance
  end

  def add_station(station, position)
    @route.insert(position - 1, station) if (2..@route.length).include? position
  end

  def delete_station(station)
    @route.delete(station) unless [@start, @finish].include? station
  end

  def print_route
    @route.each { |x| puts x.name }
  end
end
