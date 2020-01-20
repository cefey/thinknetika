require_relative 'rail_road'
class RailRoadManager < RailRoad
  def main_menu
    case main_menu_action
    when 0 then main_menu
    when 1 then train_control_menu
    when 2 then wagon_control_menu
    else station_control_menu
    end
  end

  def train_control_menu
    case train_menu_action
    when 0 then main_menu
    when 1 then create_train(select_train_type)
    when 2 then train_route
    when 3 then move_train('next')
    when 4 then move_train('previous')
    else wagons_of_train
    end
  end

  def wagon_control_menu
    case wagon_menu_action
    when 0 then main_menu
    when 1 then create_wagon(select_wagon_type)
    when 2 then change_train('add')
    when 3 then change_train('delete')
    else take_place_at_wagon
    end
  end

  def station_control_menu
    case station_menu_action
    when 0 then main_menu
    when 1 then create_station
    when 2 then create_route
    when 3 then change_route('add')
    when 4 then change_route('delete')
    else trains_on_station
    end
  end
end

rr = RailRoadManager.new
rr.main_menu
