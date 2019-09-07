require_relative 'instance_counter.rb'
class Station
  include InstanceCounter

  @@all_stations = []

  attr_reader :name, :trains
  def initialize(name)
    @name = name
    @trains = []
    @@all_stations << self
    register_instance
  end

  def self.all
    @@all_stations
  end

  def take_train(train)
    if trains.include?(train)
      false
    else
      trains << train
    end
  end

  def show_trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def depart_train(train)
    trains.delete(train)
  end
end

