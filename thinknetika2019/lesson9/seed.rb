# frozen_string_literal: true

module Seed
  def seed
    # Moscow - Spb
    @stations << station1 = Station.new('Москва')
    @stations << station2 = Station.new('Тверь')
    @stations << station3 = Station.new('Вышнийволочек')
    @stations << station4 = Station.new('Бологоемосковское')
    @stations << station5 = Station.new('Окуловка')
    @stations << station6 = Station.new('Малаявишера')
    @stations << station7 = Station.new('Санктпетербург')

    # Omsk - Nobosibirsk
    @stations << station8 = Station.new('Омск')
    @stations << station9 = Station.new('Татарская')
    @stations << station10 = Station.new('Озерокарачинское')
    @stations << station11 = Station.new('Барабинск')
    @stations << station12 = Station.new('Убинская')
    @stations << station13 = Station.new('Каргат')
    @stations << station14 = Station.new('Чулымская')
    @stations << station15 = Station.new('Обь')
    @stations << station16 = Station.new('Новосибирск')

    @trains << train1 = CargoTrain.new('R45EW')
    @trains << train2 = CargoTrain.new('F89-6G')
    @trains << train3 = CargoTrain.new('C58-4F')
    @trains << train4 = CargoTrain.new('G21-F0')
    @trains << train5 = CargoTrain.new('N4511')
    @trains << train6 = CargoTrain.new('N4551')
    @trains << train7 = PassengerTrain.new('L84-O5')
    @trains << train8 = PassengerTrain.new('K65-4P')
    @trains << train9 = PassengerTrain.new('U47Y1')
    @trains << train10 = PassengerTrain.new('P0T01')
    @trains << train11 = PassengerTrain.new('O6524')

    @unused_wagons << wagon1 = CargoWagon.new('c11-11')
    @unused_wagons << wagon2 = CargoWagon.new('c22-22')
    @unused_wagons << wagon3 = CargoWagon.new('c33-33')
    @unused_wagons << wagon4 = CargoWagon.new('c44-44')
    @unused_wagons << wagon5 = CargoWagon.new('c55-55')
    @unused_wagons << wagon6 = CargoWagon.new('c66-66')
    @unused_wagons << wagon7 = PassengerWagon.new('p11-11')
    @unused_wagons << wagon8 = PassengerWagon.new('p22-22')
    @unused_wagons << wagon9 = PassengerWagon.new('p33-33')
    @unused_wagons << wagon10 = PassengerWagon.new('p44-44')
    @unused_wagons << wagon11 = PassengerWagon.new('p55-55')
    @unused_wagons << wagon12 = PassengerWagon.new('p66-66')

    @stations[0].accept_train(trains[0])
    @stations[0].accept_train(trains[1])
    @stations[0].accept_train(trains[2])
    @stations[0].accept_train(trains[3])

    @routes << route1 = Route.new(station1, station7)
    route1.station_add(station5)
    route1.station_add(station3)
    route1.station_add(station4)
    @routes << route2 = Route.new(station8, station16)
    route2.station_add(station9)
    route2.station_add(station11)
    route2.station_add(station15)
  end
end
