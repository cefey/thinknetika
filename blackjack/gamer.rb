require_relative 'player'
class Gamer < Player
  def initialize
    super
  end

  def print_score
    "Your scores: #{@score}"
  end

  def can_continue?
  @money > 0
  end

end
