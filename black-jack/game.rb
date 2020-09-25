#Here should be game
require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'dealer'
require_relative 'gamer'
class Game
  attr_reader :gamer, :dealer

  def initialize
    #Create new deck and mix all cards
    @deck = Deck.new
    #Create new gamer
    @gamer = Gamer.new
    #Create new Dealer
    @dealer = Dealer.new
    #Each player makes a bet
    @gamer.make_a_bet
    @dealer.make_a_bet
  end

  def clear_hands
    @gamer.clear
    @dealer.clear
  end

  def give_first_cards
    2.times { give_a_card(@gamer) }
    2.times { give_a_card(@dealer) }
  end

  def give_a_card(player)
    player.get_card(@deck.draw)
  end

  def dealer_desicion
    give_a_card(@dealer) if @dealer.decide && @dealer.cards.size < 3
  end

  def final_calculation
    ds = @dealer.score
    gs = @gamer.score
    if ds > 21 && gs > 21
      ' You and Dealer lose 10 dollars'
    elsif ds < gs && gs < 22 || ds > 21
      @gamer.win_a_bet
      ' You win 10 dollars'
    elsif gs < ds && ds < 22 || gs > 21
      @dealer.win_a_bet
      ' You lose 10 dollars'
    else
      @dealer.dead_heat
      @gamer.dead_heat
      'Dead heat'
    end
  end

  def give_3d_card
    give_a_card(@gamer) if @gamer.cards.size < 3
  end

end
