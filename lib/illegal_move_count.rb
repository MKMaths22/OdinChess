# frozen-string-literal: true

# IllegalMoveCount class simply keeps count of how many times there has been an illegal move 
# attempted. This can be good for testing purposes.
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