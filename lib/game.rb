# frozen-string-literal: true

# Game class takes care of overall progress of the game, asking players their names at the start. Also responsible for saving the game.  
# This is how Player objects are created and all of the other objects the Board object, which creates the Pieces.

# Player class: each Player has a @colour attribute which is either 'White' or 'Black' and a name attribute. 

#Board class: Board initialized with the starting position (using dependency injection) @position is a 2-D array 8 x 8 with nil for empty squares and Piece objects otherwise.
# Castling rights/en Passent possibilities are accounted for & whose turn it is.

#Piece class is superclass of #Pawn, #Bishop,#Rook, #Queen, #Knight, #King. Each piece has a @colour' and the subclasses all have same-named methods for determining if moves are 'legal' for moving/capturing, not accounting for where
# other pieces are or if own king is in Check.

# DisplayBoard class responsible for showing the board.

# Result class takes care of monitoring previous positions (for 3-fold repitition) and how many moves with no captures/pawn moves (for 50 move rule).

# Check class monitors whether either King is in check. Also to check if own King would be in check.

# The procedure for determining if a move is legal

class Game
  
  attr_accessor :white, :black, :board
  
  def initialize(board = Board.new, white = Player.new('White', nil), black = Player.new('Black', nil), result = Result.new)
    @board = board
    @white = white
    @black = black
    @result = result
    @valid_move = ValidMove.new
  end

  def play_game
    welcome
    offer_reload if games_saved?
    name_the_players unless white.name


  end
  
  def welcome
    puts 'Welcome to Chess!'
    sleep(2)
  end

  def games_saved?
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    Dir.empty?('saved_games') ? false : true
  end

  def game_or_games(num)
    num > 1 ? 'some saved games' : 'a saved game'
  end
  
  def offer_reload
    Dir.chdir('saved_games')
    names_available = Dir['./*'].map { |string| string[2..-5] }
    # which removes "./" and ".txt" just outputting the names chosen when games were saved
    puts "I have found #{game_or_games(names_available.size) }."
    list(names_available)
    puts "Type the number of a saved game to reload it, or anything else for a new game."
    value = gets.strip
    reload_or_new(names_available, value)
  end

  def list(array)
    array.each_with_index do |name, index|
      puts "#{index.to_i + 1}.  #{name}"
    end
  end

  def reload_or_new(array, string)
    number = string.to_i - 1
    # if the string was not of numerical form, number will be -1 which is not valid for reloading anyway!
    names_available[number] ? reload(names_available, number) : Game.new.play_game
  end
   
  def name_the_players
    puts 'Please input the name of the player with the White pieces.'
    input = gets.strip
    @white.set_name(input)
    puts 'And now input the name of the player playing Black.'
    input = gets.strip
    @black.set_name(input)
  end

end


