# frozen_string_literal: true

require_relative 'instance_count'
require_relative 'validator'

class Route
  include InstanceCount
  include Validator

  @routes = []
  class << self
    attr_accessor :routes
  end

  attr_accessor :route
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @route = [start, finish]
    self.class.routes << self
    register_instance
  end

  def add_station(station, place)
    raise 'Start and end cannot be changed' unless (2..@route.size).cover? place

    @route.insert(place - 1, station)
  end

  def delete_station(station)
    raise 'Cannot change start and finish' if [@start, @finish].include? station

    @route.delete(station)
  end

  def print_route
    @route.each { |x| puts x.name }
  end
end
