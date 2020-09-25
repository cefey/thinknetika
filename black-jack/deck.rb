require_relative 'card'

class Deck
  attr_reader :card_deck
  HEARTS =  "<3"
  TILES =   "<>"
  CLOVERS = "+ "
  PIKES =   "^ "

  def initialize
    @card_deck = []
    @drawn_card = []
    new_deck
  end

  def new_deck
    suits = [HEARTS, TILES, CLOVERS, PIKES]
    suits.each do |suit|
      Card::FACE_NUMBERS.each do |card|
        @card_deck << Card.new(card, suit)
      end
      Card::FACE_PICTURES.each do |card|
        @card_deck << Card.new(card, suit)
      end
      Card::FACE_ACES.each do |card|
        @card_deck << Card.new(card, suit)
      end
    end
    @card_deck.shuffle!
  end

  def draw
    card = @card_deck.first
    @drawn_card << card
    @card_deck.shift
    card
  end
end
