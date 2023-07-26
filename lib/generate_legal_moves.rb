# frozen_string_literal: true

# GenerateLegalMoves class is responsible for finding all of the legal moves in a given position.
class GenerateLegalMoves
  include Miscellaneous

  attr_accessor :board, :colour_moving

  def initialize(board)
    @board = board
    @colour_moving = board.colour_moving
    # The board.colour_moving is the colour of the player whose turn it is to move
  end

  def find_all_legal_moves
    # outputs either an array of Move objects, which contains just one if get_just_one is true, or no items if there are no legal moves
    output = []
    hash_from_board = board.next_square_with_piece_to_move([-1, 7])
    # starting from [-1, 7] makes [0, 0] the next square, so it works out!
    while hash_from_board
      current_square = hash_from_board['square']
      current_piece = hash_from_board['piece']
      output.concat(current_piece.get_all_legal_moves_from(current_square, board))
      hash_from_board = board.next_square_with_piece_to_move(current_square)
    end
    output
  end
end
