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
require './board.rb'
require './player.rb'
require './display_board.rb'
require './check_for_check.rb'
require './result.rb'
require './piece.rb'
require './miscellaneous.rb'
require './move.rb'
require './change_the_board.rb'
require './generate_legal_moves.rb'

class Game

include Miscellaneous
  
  attr_accessor :white, :black, :board, :result, :colour_moving, :legal_moves
  
  def initialize(board = Board.new, white = Player.new('White', nil), black = Player.new('Black', nil), result = Result.new(make_the_hash(board.store_position)))
    @board = board
    @white = white
    @black = black
    @result = result
    @colour_moving = 'White'
    @display_board = DisplayBoard.new
    @legal_moves = GenerateLegalMoves.new(board).find_all_legal_moves
  end

  def play_game
   # legal_moves.each_with_index do |move, index|
   #   puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}." if move.class.to_s == 'Move'
   #   puts "The move has class #{move.class.to_s}"
      # puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}."
    # end
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
      one_turn until result.game_over?

  end

  def one_turn
    puts "There are #{legal_moves.size} legal moves."
    puts "#{colour_moving} is the colour to Move."
    @display_board.show_the_board(board)
    player_name = (@colour_moving == 'White') ? white.name : black.name
    puts "Enter your move, #{player_name}, in the format 'e4g6' for the starting square and finishing square. Or type 'save' to save the game."
    
    
    next_move = @colour_moving == 'White' ? white.get_legal_move(board, legal_moves) : black.get_legal_move(board, legal_moves)
    unless next_move
      save_the_game
      # how to stop the one_turn and turn_loop from continuing?
    end
    # next_move is a either nil or a Move object which knows the input 'string' that started it from the Player, 'start_square', 'finish_square', 'colour', 'board' object, 'vector' (which is just subtract_vector(finish_square, start_square)), 'our_piece (the piece that is moving)', 'other_piece' which is nil unless it is a conventional capturing move, 'en_passent' which is Boolean (the only non-conventional capturing move) and 'castling' which is either false or gives the string of the form e.g. 'Black_0-0-0'
    puts "next_move has start square #{next_move.start_square} and ends at #{next_move.finish_square}"
    update_board = ChangeTheBoard.new(next_move, board, white.name, black.name)
    update_board.update_the_board
    # the #update_the_board method communicates with the move object next_move and the @board to get the board to update itself, including changing its @colour_moving. The
    # @colour_moving in Game class gets toggled later
    check_status = CheckForCheck.new(board.board_array, board.colour_moving, '')
    check_hash = check_status.king_in_check?
    # puts "The value of check_hash is #{check_hash}"
    # board.colour_moving is the next player
    find_moves = GenerateLegalMoves.new(board)
    self.legal_moves = find_moves.find_all_legal_moves
    moving_name = get_player_name_from_colour(colour_moving)
    other_name = get_player_name_from_colour(other_colour(colour_moving))
    mate_or_mate(check_status, result, moving_name, other_name) unless legal_moves.size.positive?
    # now, to store the Board totally accurately, we need to check, if there ARE en_passent possibilities IN THEORY created by a pawn moving two squares,
    # are there REALLY any legal en_passent moves? If not, we tell the Board to reset its en_passent possibilities after all. This precision will allow
    # three-fold repitition to trigger correctly 
    if board.any_en_passent_in_theory?
      board.reset_en_passent unless legal_moves.any? { |move| move.en_passent }
    end
    boolean = next_move.pawn_move_or_capture?
    puts "The value of boolean is #{boolean} for pawn move or capture."
    boolean ? result.reset_moves_count : result.increase_moves_count
    result.declare_fifty_move_draw(moving_name, other_name) if result.fifty_move_rule_draw?
    
    result.wipe_previous_positions if boolean
    result.add_position(board.store_position)
    result.declare_repitition_draw(moving_name, other_name) if result.repitition_draw?
    result.declare_insuff_material_draw(moving_name, other_name) if board.insuff_material_draw?
    @display_board.show_the_board(board) if result.game_over?
    toggle_colours
  end

  def toggle_colours
    puts "toggle_colours is working"
    self.colour_moving = other_colour(colour_moving)
    # the colour_moving variable in the Board class needs to be toggled separately
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
    puts "save_the_game is working"
    # require input to name the saved game
    # check if that name is already used (input needs to be validated)
    # then save the Board, Result, Player classes (any others) to chosen_name.txt in saved_games directory, creating
    # the directory if necessary
  end
   
  def name_the_players
    puts 'Please input the name of the player with the White pieces.'
    input = gets.strip
    white.set_name(input)
    puts 'And now input the name of the player playing Black.'
    input = gets.strip
    black.set_name(input)
  end

  def get_player_name_from_colour(colour)
    colour == 'White' ? white.name : black.name
  end

  def mate_or_mate(check_for_check_object, result_object, moving_name, other_name)
    check_for_check_object.king_in_check? ? result_object.declare_checkmate(moving_name, other_name) : result_object.declare_stalemate(moving_name, other_name)
  end

end


