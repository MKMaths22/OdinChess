# frozen-string-literal: true

# CheckForCheck class monitors whether either King is in check (to see if stalemate/checkmate when
# no legal moves.) Also used by the Move class to verify legality re. check issues.
class CheckForCheck
  include Miscellaneous

  attr_accessor :colour, :poss_board_array, :king_square

  def initialize(poss_board_array, colour)
    @colour = colour
    # colour is the colour of the King we are asking about
    @hypoth_board = Board.new(poss_board_array, other_colour(colour))
    # we want to ask whether if it is the other side to move, could they capture
    # the King, neglecting check issues on their own King?
    @king_square = nil
  end

  def king_in_check?
    self.king_square = find_our_king
    current_square = [-1, 7]
    hash = @hypoth_board.next_square_with_piece_to_move(current_square)
    # the pieces being found have the opposite colour to our king.
    while hash
      return true if hash['piece'].capture_king_possible?(hash['square'], @king_square, @hypoth_board)

      hash = @hypoth_board.next_square_with_piece_to_move(hash['square'])
    end
    false
  end

  def find_our_king
    current_square = [-1, 7]
    # ensures that the next_square is [0, 0] to start the search.
    found = false
    until found
      current_square = next_square(current_square)
      poss_piece = @hypoth_board.get_piece_at(current_square)
      found = true if poss_piece&.colour == colour && poss_piece.is_a?(King)
    end
    current_square
  end
end
