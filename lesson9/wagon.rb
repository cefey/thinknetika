# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'validator'

class Wagon
  include Manufacturer
  include Validator

  WAGON_NUMBER_FORMAT = /^[а-яa-z\d]{2,}/.freeze

  attr_reader :number, :train, :volume, :free_volume

  def initialize(number, volume)
    @number = number.to_s
    @train = nil
    @volume = volume.to_i
    @free_volume = volume.to_i
    validate!
  end

  def attached?
    train
  end

  def attach_to_train(train)
    raise "Wagon is already attached to train №#{@train.number}" if attached?

    @train = train if train.wagons.include? self
  end

  def detach_from_train(train)
    @train = nil if @train == train
  end

  def validate!
    raise 'Wagon number cannot be empty' unless number
    raise 'Wrong number format' if number.to_s !~ WAGON_NUMBER_FORMAT
    raise 'Wrong number: at least 2 symbols' if number.length < 2
  end

  def reserved_volume
    @volume - @free_volume
  end

  def book_volume(volume)
    raise 'The wagon is not yet attached to the train' unless attached?

    @free_volume -= volume
  end
end
