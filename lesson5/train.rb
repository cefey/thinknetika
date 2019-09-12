class Train
  attr_reader :number, :current_station, :speed, :wagons, :route

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def stop
    @speed = 0
  end

  def stopped?
    @speed.zero?
  end

  def increase_speed(speed)
    @speed += speed if speed.positive?
  end

  def attach_wagon!(wagon)
    attach_wagon(wagon) if stopped?
  end

  def detach_wagon!(wagon)
    detach_wagon(wagon) if stopped?
  end

  def take_route(route)
    @route = route.route
    @current_station = @route[0]
    @current_station.take_train(self)
  end

  def has_next_station?
    @current_station && @current_station != @route.last
  end

  def go_to_next
    if has_next_station?
      @current_station.send_train(self)
      @current_station = @route[@route.index(@current_station) + 1]
      @current_station.take_train(self)
    else
      p 'There is no next station on the train route'
    end
  end

  def has_previous_station?
    @current_station && @current_station != @route.first
  end

  def go_to_previous
    if has_previous_station?
      @current_station.send_train(self)
      @current_station = @route[@route.index(@current_station) - 1]
      @current_station.take_train(self)
    else
      p 'There is no previous station on the train route'
    end
  end

  def next_station
    if has_next_station?
      puts "Next Station is #{@route[@route.index(@current_station) + 1].name}"
    else
      'There is no next station on the train route'
    end
  end

  def previous_station
    if has_previous_station?
      puts "Previous Station is #{@route[@route.index(@current_station) - 1].name}"
    else
      'There is no previous station on the train route'
    end
  end

  private

  # нельзя просто назначить маршрут, не назначив при этом начальную\конечную станцию
  attr_writer :route

  # прицепить вагон можно только при определенных условиях, отцепить тоже
  def attach_wagon(wagon)
    wagons << wagon
    wagon.attach_to_train(self)
  end

  def detach_wagon(wagon)
    wagons.delete(wagon)
    wagon.detach_from_train(self)
  end
end

