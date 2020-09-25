require_relative 'game'
#-------Initialize new Game
@game = Game.new
#------Describe game-logic methods for console interface
def greeting
  puts " Please write down your name:"
  _name = gets.chomp
end

def question
  puts "1. pass  2. one more card  3. open cards"
  gets.chomp.to_i
end

def question_after_pass
  puts "1. one more card  2. open cards"
  gets.chomp.to_i
end

def print_cards(player)
  cards = player.cards.size
  cards.times { print " " + "----" + " " }
  puts
  cards.times { print "|" + "    " + "|" }
  puts
  player.cards.each do |card_name|
    print "|" + "#{card_name.name}" + "|"
  end
  puts
  cards.times { print "|" + "    " + "|" }
  puts
  cards.times { print " " + "----" + " " }
  puts
end

def open_cards_dealer
  print_cards(@game.dealer)
  puts "#{@game.dealer.print_score}"
end

def open_cards_gamer
  print_cards(@game.gamer)
  puts "#{@game.gamer.print_score}"
end

def print_hidden_cards
  cards = @game.dealer.cards.size
  cards.times { print " " + "----" + " " }
  puts
  cards.times { print "|" + "    " + "|" }
  puts
  cards.times { print "|" + " ** " + "|" }
  puts
  cards.times { print "|" + "    " + "|" }
  puts
  cards.times { print " " + "----" }
  puts
end

def open_cards
  system("clear")
  puts " Dealer's card :"
  open_cards_dealer
  puts "Your cards :"
  open_cards_gamer
  puts "#{@game.final_calculation}"
end

def make_desicion(answer)
  case answer
    # pass
    when 1
    @game.dealer_desicion
    make_desicion(question_after_pass + 1)
    # ask 3d card
    when 2
      @game.give_3d_card
      @game.dealer_desicion
      open_cards
      # ask to open cards
    when 3
      open_cards
    else
      @game.dealer_desicion
  end
end

def play
  #We should clear hands and score since 2d round
  @game.clear_hands
  #Give first 2 cards to gamer and 2 for dealer
  @game.give_first_cards
  system("clear")
  puts " Dealer's card :"
  print_hidden_cards
  puts "Your cards :"
  open_cards_gamer
  make_desicion(question)
  gets
end

#-----Program starts here-----
greeting
loop do
  system ('clear')
  puts "Your balance is #{@game.gamer.money} USD"
  if @game.gamer.can_continue?
    gets
    play
    puts 'Will you play again y/n'
    answer = gets.chomp.to_str
    break if answer == 'n'
  else
    break
  end
end
