# frozen-string-literal: true

# IllegalMoveCount class keeps track of which moves have been illegal.
# This is good for testing purposes, in which a GameInputs object feeds moves
# in to a Game automatically. The two names of non-computer players are inputted
# first, then all subsequent inputs count 1, 2, 3... as 'moves', except for any inputs
# such as 'N', 'Q' etc. to choose the piece for promoting a pawn to.
class IllegalMoveCount

  attr_accessor :which_moves_illegal, :total_move_count

  def initialize
    @which_moves_illegal = []
    @total_move_count = 0
  end

  def increment_total_move_count
    self.total_move_count = @total_move_count + 1
  end

  def record_legal_move
    increment_total_move_count
  end

  def record_illegal_move
    increment_total_move_count
    self.which_moves_illegal.push(@total_move_count)
  end

  def report_illegal_moves
    @which_moves_illegal
  end
end
