require_relative 'card'
class Player
  attr_reader :score, :money, :cards

  def initialize
    @score = 0
    @money = 100
    @cards = []
  end

  def card_score_calculation(card)
    score = card.card_value.to_i if Card::FACE_NUMBERS.include?(card.card_value)
    score = 10 if Card::FACE_PICTURES.include?(card.card_value)
    #according the task we should check current player' score
    # before adding scores for aces, it may be 1 or 11
    if Card::FACE_ACES.include?(card.card_value)
      if @score > 10
        score = 1
      else
        score = 11
      end
    end
  score
  end

  def get_card(card)
    @score += card_score_calculation(card)
    @cards << card
  end

  def make_a_bet
    @money -= 10
  end

  def win_a_bet
    @money += 20
  end

  def dead_heat
    @money += 10
  end

  def clear
    @cards.clear
    @score = 0
  end

end
