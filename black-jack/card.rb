class Card
  attr_reader :card_value, :name

  FACE_NUMBERS  =  [" 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9","10"]
  FACE_PICTURES = [" J", " Q", " K"]
  FACE_ACES     = [" A"]

  def initialize(card, suit)
    @name = "#{card + suit}"
    @card_value = card
  end

end
