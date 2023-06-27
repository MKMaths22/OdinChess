# frozen-string-literal: true

class Result
  
  attr_accessor :previous_positions, :half_moves_count

  def initialize(previous_positions = {}, half_moves_count = 0)
    @previous_positions = previous_positions
    @half_moves_count = half_moves_count
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