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
  
  attr_accessor :white, :black, :board, :result, :colour_moving, :legal_moves, :saved
  
  def initialize(board = Board.new, white = nil, black = nil, result = Result.new(make_the_hash(board.store_position)))
    @board = board
    @white = white
    @black = black
    @result = result
    @colour_moving = 'White'
    @display_board = DisplayBoard.new
    @legal_moves = GenerateLegalMoves.new(board).find_all_legal_moves
    @saved = false
  end
  
  def play_game
   # legal_moves.each_with_index do |move, index|
   #   puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}." if move.class.to_s == 'Move'
   #   puts "The move has class #{move.class.to_s}"
      # puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}."
    # end
   
    create_the_players unless saved
  
    puts "It is #{colour_moving} to move." if saved
    # result.previous_positions.keys.each { |key| puts key }
    self.saved = false
    # if reloading a saved game, this variable must be changed 
    turn_loop
  end

  def turn_loop
      one_turn until result.game_over? || @saved

  end

  def one_turn
    # puts "There are #{legal_moves.size} legal moves."
    # puts "#{colour_moving} is the colour to Move."
    @display_board.show_the_board(board)
    next_move = enter_move_or_save_game
    save_the_game if next_move == 'save'
    resign_the_game if next_move == 'resign'
    # next_move is a either nil or a Move object which knows the input 'string' that started it from the Player, 'start_square', 'finish_square', 'colour', 'board' object, 'vector' (which is just subtract_vector(finish_square, start_square)), 'our_piece (the piece that is moving)', 'other_piece' which is nil unless it is a conventional capturing move, 'en_passent' which is Boolean (the only non-conventional capturing move) and 'castling' which is either false or gives the string of the form e.g. 'Black_0-0-0'
    # puts "next_move has start square #{next_move.start_square} and ends at #{next_move.finish_square}"
    if next_move.kind_of?(Move)
      boolean = next_move.pawn_move_or_capture?
      # p "The value of boolean is #{boolean} for pawn move or capture."
      player_of_the_move = next_move.colour == 'White' ? white : black 
      ChangeTheBoard.new(next_move, board, player_of_the_move).update_the_board
    # the #update_the_board method communicates with the move object next_move and the @board to get the board to update itself, including changing its @colour_moving. The
    # @colour_moving in Game class gets toggled later
    # board.colour_moving is the next player
      self.legal_moves = GenerateLegalMoves.new(board).find_all_legal_moves
      consequences_of_move(boolean)
      toggle_colours
    end
  end

  def resign_the_game
    moving_name = get_player_name_from_colour(colour_moving)
    other_name = get_player_name_from_colour(other_colour(colour_moving))
    result.declare_resignation(moving_name, other_name)
  end

  def enter_move_or_save_game
    player_name = (@colour_moving == 'White') ? white.name : black.name
    puts "Enter your move, #{player_name}, in the format 'e4g6' for the starting square and finishing square, or type 'save' or 'resign' to save/resign the game."
    next_move = @colour_moving == 'White' ? white.get_legal_move(board, legal_moves) : black.get_legal_move(board, legal_moves)
  end

  def consequences_of_move(boolean)
    # boolean for whether the move was a pawn move or capture
    check_status = CheckForCheck.new(board.board_array, board.colour_moving).king_in_check?
    # puts "The value of check_status is #{check_status}"
  
    moving_name = get_player_name_from_colour(colour_moving)
    other_name = get_player_name_from_colour(other_colour(colour_moving))
    mate_or_mate(check_status, result, moving_name, other_name) unless legal_moves.size.positive?
    # now, to store the Board totally accurately, we need to check, if there ARE en_passent possibilities IN THEORY created by a pawn moving two squares,
    # are there REALLY any legal en_passent moves? If not, we tell the Board to reset its en_passent possibilities after all. This precision will allow
    # three-fold repitition to trigger correctly 
    if board.any_en_passent_in_theory?
      board.reset_en_passent unless legal_moves.any? { |move| move.en_passent }
    end
    boolean ? result.reset_moves_count : result.increase_moves_count
    result.declare_fifty_move_draw(moving_name, other_name) if result.fifty_move_rule_draw?
    
    result.wipe_previous_positions if boolean
    result.add_position(board.store_position)
    # puts "moving_name = #{moving_name}. other_name = #{other_name}."
    result.declare_repitition_draw(moving_name, other_name) if result.repitition_draw?
    result.declare_insuff_material_draw(moving_name, other_name) if board.insuff_material_draw?
    @display_board.show_the_board(board) if result.game_over?
  end

  def toggle_colours
    # puts "toggle_colours is working"
    self.colour_moving = other_colour(colour_moving)
    # the colour_moving variable in the Board class needs to be toggled separately
  end

  def save_the_game
    self.saved = true
    player_name = get_player_name_from_colour(colour_moving)
    puts "#{player_name}, please choose a name for the saved game."
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    Dir.chdir('saved_games')
    name = get_save_name
    # puts "name for saving file = #{name}"
    saved_game_as_yaml = YAML.dump(self)
    file_for_saving = File.new("#{name}.txt", 'w')
    file_for_saving.puts saved_game_as_yaml
    file_for_saving.close
    puts "Game saved in 'saved_games/#{name}.txt"
    Dir.chdir('..')
    # require input to name the saved game
    # check if that name is already used (input needs to be validated)
    # then save the Board, Result, Player classes (any others) to chosen_name.txt in saved_games directory, creating
    # the directory if necessary
  end

  def get_save_name
    name_tried = gets
    if already_used?(name_tried)
      puts "There is already a saved game with that name. Please choose another."
      return get_save_name
    end
    name_tried
  end

  def already_used?(name)
    File.exist?("#{name}.txt")
  end
   
  def create_the_players
    puts 'Please input the name of the player with the White pieces. Alternatively, enter "C" for a computer player.'
    input = gets.strip
    self.white = make_human_or_computer('White', input)
    puts 'And now input the name of the player playing Black. Or enter "C" for a computer player.'
    input = gets.strip
    self.black = make_human_or_computer('Black', input)
  end

  def make_human_or_computer(colour, input)
    input.upcase == 'C' ? Computer.new(colour) : Player.new(colour, input)
  end

  def get_player_name_from_colour(colour)
    colour == 'White' ? white.name : black.name
  end

  def mate_or_mate(check_status, result_object, moving_name, other_name)
    check_status ? result_object.declare_checkmate(moving_name, other_name) : result_object.declare_stalemate(moving_name, other_name)
  end

end


