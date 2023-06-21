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

require 'yaml'

class Game
  
  attr_accessor :white, :black, :board, :result, :colour_moving
  
  def initialize(board = Board.new, white = Player.new('White', nil), black = Player.new('Black', nil), result = Result.new)
    @board = board
    @white = white
    @black = black
    @result = result
    @colour_moving = 'White'
    @valid_move = ValidMove.new
    @display_board = DisplayBoard.new
  end

  def play_game
    welcome
    offer_reload if games_saved?
    name_the_players unless white.name
    turn_loop




  end
  
  def welcome
    puts 'Welcome to Chess!'
    sleep(2)
  end

  def turn_loop
      one_turn until result.is_game_over?

  end

  def one_turn
    @display_board.show_the_board
    player_name = @colour_moving == 'White' ? white.name : black.name
    puts "Enter your move, #{player_name}, in the format 'e4g6' for the starting square and finishing square"
    next_move = @colour_moving == 'White' ? white.get_move(board) : black.get_move(board)
    # next_move is a string like 'e3f5' in which we purely list two squares on the board


    
    toggle_colours
  end

  def toggle_colours
    colour_moving = @colour_moving == 'White' ? 'Black' : 'White'
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

  def reload(array, number)
    # the number is the actual place in the array enumerated from 0, not the number displayed (which is 1 higher)
    # this method TO BE WRITTEN 
  end

  def save_the_game
    # require input to name the saved game
    # check if that name is already used (input needs to be validated)
    # then save the Board, Result, Player classes (any others) to chosen_name.txt in saved_games directory, creating
    # the directory if necessary
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

class Player
  
  attr_accessor :colour, :name
  
  def initialize(colour, name = nil)
    @colour = colour
    @name = name
  end

  def get_move(valid_move, board)
    # valid_input method collects input and validates it to be in a form such as 'b1c3'
    proposed_move = gets.strip
    valid_move.all_valid?(proposed_move, @colour_moving, board) ? proposed_move : get_move
    # write these in Legal class valid_input(proposed_move) && board.our_piece?(proposed_move, @colour_moving) && board.can_it_go_there?(proposed_move, @colour_moving) && board.is_it_legal?(proposed_move, @colour_moving)
    # our_piece method verifies whether we have a piece on the start square
    # can_it_go_there verifies if the piece can physically move to the end square regardless of check issues
    # piece_moving_error unless @board.can_it_go_there?(proposed_move, @colour_moving)
    # king_in_check_error unless @board.is_it_legal?(proposed_move, @colour_moving)
  end



end

class DisplayBoard
  def show_the_board

  end

end

class ValidMove
  def all_valid?(maybe_move, colour, board)
    return false unless valid_input?(maybe_move)
    
    moving_piece = our_piece?(maybe_move, colour, board)
    return false unless moving_piece  
    # our_piece returns the piece

    start_square = board.string_to_coords(maybe_move[0, 2])
    # start_square given in co-ordinates the board array can accept
    final_square = board.string_to_coords(maybe_move[2, 2])
    
    return false unless moving_piece.is_move_legal?(board, maybe_move)
    
    # The class of the piece takes care of the remaining tests because
    # type of piece dictates if move is possible and board class lets us
    # know if pieces in the way, Castling, En Passent possibilities 

    true
  end
  
  def valid_input?(string)
    string = string.downcase
    ok_letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ok_numbers = ['1', '2', '3', '4', '5', '6', '7', '8']
    valid = true
    valid = false unless ok_letters.include?(string[0]) && ok_letters.include?(string[2])
    valid = false unless ok_numbers.include?(string[1]) && ok_numbers.include?(string[3])
    puts input_error(string) unless valid
    valid
  end

  def input_error(string)
    "#{string} is not acceptable input. Please type the algebraic notation for starting square and finishing square such as 'g1f3'. Castling is a King move."
  end

  def our_piece?(move, colour, board)
    possible_piece = board.string_to_square(move[0,2])
      unless possible_piece
        puts no_piece_error(move)
        return false
      end
      unless possible_piece.colour = colour
        puts wrong_piece_error(move, colour)
        return false
      end
    possible_piece  
  end

  def no_piece_error(move)
    "There is no piece on the square #{move[0,2]}. Please input a valid move."
  end

  def wrong_piece_error(move, colour)
    "That piece is #{other_colour(colour)}. Please input a valid move for #{colour}."
  end

  def other_colour(colour)
    colour == 'White' ? 'Black' : 'White'
  end

end


class Result
  
  attr_accessor :previous_positions, :half_moves_count

  def initialize(previous_positions = {}, half_moves_count = 0)
    @previous_positions = previous_positions
    @half_moves_count = moves_count
  end

  def add_position(position)
    # the positions stored are snapshots of the board object, which capture the current position with
    # whose turn it is to move and any en passent or castling opportunities
    previous_positions[position] += 1
  end

  def wipe_previous_positions
    # this occurs if a pawn moves or a piece is captured
    previous_positions = {}
  end

  def increase_moves_count
    half_moves_count += 1
  end

  def reset_moves_count
    half_moves_count = 0
  end
  
  def is_game_over?

  end

end

class Board
  
  attr_accessor :board_array, :castling_rights, :en_passent
  
  def initialize(board_array = NEW_BOARD_ARRAY)
    @board_array = NEW_BOARD_ARRAY
    @castling_rights = { 'White_0-0-0' => true, 'White_0-0' => true, 'Black_0-0-0' => true, 'Black_0-0' => true }
    @en_passent = {}
    # if there is an en_passent possibility maybe it is denoted by the square on which the
    # pawn can be taken 
  end

NEW_BOARD_ARRAY = [ [Rook.new('White'), Knight.new('White'), Bishop.new('White'), Queen.new('White'), King.new('White'), Bishop.new('White'), Knight.new('White'), Rook.new('White')], Array.new(8, Pawn.new('White')), Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8, Pawn.new('Black')), [Rook.new('Black'), Knight.new('Black'), Bishop.new('Black'), Queen.new('Black'), King.new('Black'), Bishop.new('Black'), Knight.new('Black'), Rook.new('Black')]]

  def string_to_coords(string)
    # accepts a string of the form 'e4' and returns co-ordinates for use in the board_array
    [string[1].to_i - 1, char_to_num(string[0])]
  end

  def string_to_square(string)
    # accepts a string of the form 'c6' and returns the contents of that square 
    board_array.dig(string[1].to_i - 1, char_to_num(string[0]))
  end

  def char_to_num(char)
    ok_letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ok_letters.index(char)
  end

end


