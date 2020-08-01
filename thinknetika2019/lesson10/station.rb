require_relative './validation.rb'
class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains
  NAME_FORMAT = /^[A-ZА-Я][a-zа-я]*/

  validate :name, :presence
  validate :name, :type, String
  validate :name, :format, NAME_FORMAT

  @@all_station = []

  def self.all
    puts @@all_station
  end

  def initialize(name)
    @name = name
    @trains = []
    @@all_station << self
    validate!
    register_instance
  end

  def block_train(&block)
    if block_given?
      @trains.each(&block)
    else
      puts 'Блок не передан'
    end
  end

  def accept_train(train)
    @trains << train unless @trains.include?(train)
    puts "Поезд № #{train.number} прибыл на станцию '#{@name}'"
    puts
  end

  def trains_list
    puts "На станции #{@name} в данный момент: "
    puts
    @trains.each do |train|
      puts "№ поезда: #{train.number}
      Тип поезда: '#{train.type}'
      Количество вагонов: #{train.wagons.size}"
    end
  end

  def trains_add(train)
    @trains << train
  end

  def trains_remove(train)
    @trains.delete(train)
  end

  def trains_type(type)
    @trains.count { |train| train.type == type }
  end
end
