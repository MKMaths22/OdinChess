# frozen-string-literal: true

require 'yaml'
require './board'
require './player'
require './display_board'
require './check_for_check'
require './result'
require './piece'
require './pawn'
require './other_pieces'
require './miscellaneous'
require './move'
require './change_the_board'
require './generate_legal_moves'

# Game class takes care of overall progress of the game, asking players their names at the start.
# Also responsible for saving the game.
# This is how Player objects are created and all of the other objects the Board object, which creates the Pieces.
class Game
  include Miscellaneous

  attr_accessor :white, :black, :board, :result, :colour_moving, :legal_moves, :saved, :moving_name, :not_moving_name, :check_status

  def initialize
    @board = Board.new
    @white = nil
    @black = nil
    @result = Result.new(make_the_hash(board.store_position))
    @colour_moving = 'White'
    @display_board = DisplayBoard.new
    @legal_moves = GenerateLegalMoves.new(board).find_all_legal_moves
    @saved = false
    @moving_name = nil
    @not_moving_name = nil
    @check_status = false
  end

  def play_game
    @saved ? name_the_players : create_the_players
    # when loading a saved game, reminds us who it playing and if in check.
    self.saved = false
    # if reloading a saved game, this variable must be changed.
    turn_loop
  end

  def name_the_players
    puts "#{white.name} has the White pieces and #{black.name} is playing Black."
    puts "It is #{colour_moving} to move#{remind_check}."
  end

  def remind_check
    @check_status ? ' and they are in Check' : ''
  end

  def turn_loop
    one_turn until result.game_over? || @saved
  end

  def one_turn
    @display_board.show_the_board(board)
    next_move = enter_move_or_save_game
    save_the_game if next_move == 'save'
    resign_the_game if next_move == 'resign'
    # next_move is a either a 'save' or 'resign' string or a Move object which knows the 'start_square',
    # 'finish_square', 'colour', 'board' object, 'vector' (which is just subtract_vector(finish_square,
    # start_square)), 'our_piece (the piece that is moving)', 'other_piece' which is nil unless it is
    # a conventional capturing move, 'en_passent' which is Boolean (the only non-conventional capturing
    # move) and 'castling' which is either false or gives the string of the form e.g. 'Black_0-0-0'
    return unless next_move.is_a?(Move)

    boolean = next_move.pawn_move_or_capture?
    player_of_the_move = next_move.colour == 'White' ? white : black
    ChangeTheBoard.new(next_move, board, player_of_the_move).update_the_board
    # player needed in case they give input for pawn promotion
    # the #update_the_board method communicates with the move object next_move and the
    # @board to get the board to update itself, including changing its @colour_moving. The
    # @colour_moving in Game class gets toggled next.
    # board.colour_moving is the next player to move
    toggle_colours
    self.legal_moves = GenerateLegalMoves.new(board).find_all_legal_moves
    consequences_of_move(boolean)
  end

  def update_moving_name
    self.moving_name = get_player_name_from_colour(colour_moving)
  end

  def update_not_moving_name
    self.not_moving_name = get_player_name_from_colour(other_colour(colour_moving))
  end

  def resign_the_game
    result.declare_resignation(moving_name, not_moving_name)
  end

  def enter_move_or_save_game
    puts "Enter your move, #{moving_name}, in the format 'e4g6' for the starting square and finishing square, or type 'save' or 'resign' to save/resign the game."
    @colour_moving == 'White' ? white.get_legal_move(board, legal_moves) : black.get_legal_move(board, legal_moves)
  end

  def consequences_of_move(boolean)
    # boolean for whether the move was a (pawn move or capture) or not.
    self.check_status = CheckForCheck.new(board.board_array, board.colour_moving).king_in_check?

    legal_moves.size.positive? ? declare_check : mate_or_mate(result)
    # mate_or_mate will declare stalemate or checkmate when there are no legal moves

    # now, to store the Board totally accurately, we need to check, if there ARE en_passent
    # possibilities IN THEORY created by a pawn moving two squares,
    # are there REALLY any legal en_passent moves? If not, we tell the Board
    # to reset its en_passent possibilities after all. This precision will allow
    # three-fold repitition to trigger correctly
    if board.any_en_passent_in_theory?
      board.reset_en_passent unless legal_moves.any?(&:en_passent)
    end
    boolean ? result.reset_moves_count : result.increase_moves_count
    result.declare_fifty_move_draw(not_moving_name, moving_name) if result.fifty_move_rule_draw?

    result.wipe_previous_positions if boolean
    result.add_position(board.store_position)
    result.declare_repitition_draw(not_moving_name, moving_name) if result.repitition_draw?
    result.declare_insuff_material_draw(not_moving_name, moving_name) if board.insuff_material_draw?
    @display_board.show_the_board(board) if result.game_over?
  end

  def declare_check
    puts check_message(moving_name) if @check_status
  end

  def toggle_colours
    self.colour_moving = other_colour(colour_moving)
    update_moving_name
    update_not_moving_name
    board.toggle_colours
    # the colour_moving variable in the Board class needs to be toggled separately
  end

  def save_the_game
    self.saved = true
    puts "#{moving_name}, please choose a name for the saved game."
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    Dir.chdir('saved_games')
    name = make_save_name
    saved_game_as_yaml = YAML.dump(self)
    file_for_saving = File.new("#{name}.txt", 'w')
    file_for_saving.puts saved_game_as_yaml
    file_for_saving.close
    puts "Game saved in 'saved_games/#{name}.txt"
    Dir.chdir('..')
  end

  def make_save_name
    name_tried = gets
    if already_used?(name_tried)
      puts 'There is already a saved game with that name. Please choose another.'
      return make_save_name
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
    self.moving_name = white.name
    puts 'And now input the name of the player playing Black. Or enter "C" for a computer player.'
    input = gets.strip
    self.black = make_human_or_computer('Black', input)
    self.not_moving_name = black.name
  end

  def make_human_or_computer(colour, input)
    input.upcase == 'C' ? Computer.new(colour) : Player.new(colour, input)
  end

  def get_player_name_from_colour(colour)
    colour == 'White' ? white.name : black.name
  end

  def mate_or_mate(result_object)
    @check_status ? result_object.declare_checkmate(not_moving_name, moving_name) : result_object.declare_stalemate(not_moving_name, moving_name)
  end
end
