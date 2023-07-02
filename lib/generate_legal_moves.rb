# frozen_string_literal: true

# GenerateLegalMoves class is responsible for finding a single legal move to let us know that 
# the game is not over, or finding all legal moves for a computer player.
class GenerateLegalMoves

  include Miscellaneous

  attr_accessor :board

  def initialize(board)
    @board = board
  end

end