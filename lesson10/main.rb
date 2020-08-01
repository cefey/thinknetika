require_relative './company.rb'
require_relative './instance_counter.rb'
require_relative './station.rb'
require_relative './route.rb'
require_relative './train.rb'
require_relative './passenger_train.rb'
require_relative './passenger_wagon.rb'
require_relative './cargo_train.rb'
require_relative './cargo_wagon.rb'
require_relative './wagon.rb'
require_relative './railroad.rb'
require_relative './seed.rb'
require_relative './accessors.rb'
require_relative './validation.rb'

system('clear')

rr = RailRoad.new
rr.seed

rr.main_menu
