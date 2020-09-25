require_relative 'player'
class Dealer < Player
  MAX_SCORE = 17
  def initialize
    super
  end

  def print_score
    " Dealer's score : #{@score}"
  end

  def decide
    @score < MAX_SCORE
  end
end
