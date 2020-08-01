require_relative 'instance_count'
require_relative 'validator'

class Route
  include InstanceCount
  include Validator

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
    raise 'Начало и конец маршрута не могут быть изменены' unless (2..@route.length).include? position

    @route.insert(position - 1, station)
  end

  def delete_station(station)
    raise 'Начало и конец маршрута не могут быть изменены' if [@start, @finish].include? station

    @route.delete(station)
  end

  def print_route
    @route.each { |x| puts x.name }
  end
end
