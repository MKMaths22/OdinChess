# frozen-string-literal: true

class Result
  
  attr_accessor :previous_positions, :half_moves_count

  def initialize(previous_positions, half_moves_count = 0)
    # MAYBE SHOULD INITIALIZE WITH STARTING POSITION IN PREVIOUS_POSITIONS HASH, depends how one_turn loop ends up ordered in Game class,
    # check initial position is not missed
    @previous_positions = previous_positions
    @half_moves_count = half_moves_count
    @game_over = false
  end

  def add_position(position)
    # the positions stored are snapshots of the board object, which capture the current position with
    # whose turn it is to move and any en passent or castling opportunities
    previous_positions[position] += 1
    declare_repitition_draw if previous_positions[position] == 3
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

  def fifty_move_rule_draw?
    half_moves_count == 100
  end
  
  def game_over?
    @game_over
  end

  def declare_checkmate
    @game_over = true
  end

  def declare_stalemate
    @game_over = true
  end

  def declare_fifty_move_draw 
    @game_over = true
  end 

  def declare_repitition_draw
    @game_over = true
  end

end