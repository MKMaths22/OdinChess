# frozen_string_literal: true

class Move

include Miscellaneous

  def initialize

  end

# this #our_piece makes no sense yet! 

def our_piece(move, colour, board)
  possible_piece = board.string_to_square(move[0,2])
    unless possible_piece
      puts no_piece_error(move)
      return false
    end
    unless possible_piece.colour = colour
      puts wrong_piece_error(move, colour)
      return false
    end
  possible_piece  
end

end