# frozen_string_literal: true

# GenerateLegalMoves class is responsible for finding a single legal move to let us know that 
# the game is not over, or finding all legal moves for a computer player.
class GenerateLegalMoves

  include Miscellaneous

  attr_accessor :board, :hash_if_in_check

  def initialize(board, hash_if_in_check)
    @board = board  
    @hash_if_in_check = hash_if_in_check
    @colour_moving = board.colour_moving
    # that hash takes the form { 'our_king_square' => king_square, 'checking_piece_square' => checking_piece_square, 'squares_between' => squares_between } or = false if we are not in check.
    # The board.colour_moving is the colour of the player whose turn it is to move
  end

  def legal_move_exists?
    true if find_all_legal_moves(board, true).size.positive?
    false
  end
  
  def find_all_legal_moves(board, get_just_one = false)
    # outputs either an array of Move objects, which contains just one if get_just_one is true, or no items if there are no legal moves
    output = []
    hash_from_board = board.next_square_with_piece_to_move([0, 0])
    while hash_from_board
      current_square = hash_from_board['square']
      current_piece = hash_from_board['piece']
      output.push(current_piece.get_all_legal_moves_from(current_square, board))
      return output[0] if output[0] && get_just_one
      hash_from_board = board.next_square_with_piece(current_square)
    end
    output
  end

end