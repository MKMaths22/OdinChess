# frozen_string_literal: true

# GenerateLegalMoves class is responsible for finding a single legal move to let us know that 
# the game is not over, or finding all legal moves for a computer player.
class GenerateLegalMoves

  include Miscellaneous

  attr_accessor :board, :colour_moving

  def initialize(board)
    @board = board
    @colour_moving = board.colour_moving
    # The board.colour_moving is the colour of the player whose turn it is to move
  end

  # def legal_move_exists?
   # true if find_all_legal_moves(true).size.positive?
   # false
 # end
  
  def find_all_legal_moves(get_just_one = false)
    # outputs either an array of Move objects, which contains just one if get_just_one is true, or no items if there are no legal moves
    puts "find_all_legal_moves is working"
    output = []
    hash_from_board = board.next_square_with_piece_to_move([-1, 7])
    # starting from [-1, 7] makes [0, 0] the next square, so it works out!
    while hash_from_board
      current_square = hash_from_board['square']
      current_piece = hash_from_board['piece']
      puts "We have a piece of type #{current_piece.class.to_s} at #{current_square}"
      output.concat(current_piece.get_all_legal_moves_from(current_square, board))
      return output[0] if output[0] && get_just_one
      hash_from_board = board.next_square_with_piece_to_move(current_square)
    end
    puts "#{output.size} legal moves found. They are as follows:"
    output.each do |move|
      puts "Start at #{move.start_square}, finish at #{move.finish_square}."
    end
    output
  end

end