# frozen-string-literal: true

class ValidMove
  
include Miscellaneous
  
  def all_valid?(maybe_move, colour, board)
    # maybe_move is the raw input from the player
    return false unless valid_input?(maybe_move)
    
    moving_piece = our_piece(maybe_move, colour, board)
    return false unless moving_piece  
    # our_piece returns the piece
    # can include string_to_coords in a module so this ValidMove class can use it directly
    start_square = string_to_coords(maybe_move[0, 2])
    # start_square given in co-ordinates the board array can accept
    final_square = string_to_coords(maybe_move[2, 2])
    
    return false unless moving_piece.move_legal?(board, start_square, final_square)
    
    # The class of the piece takes care of the remaining tests because
    # type of piece dictates if move is possible and board class lets us
    # know if pieces in the way, Castling, En Passent possibilities 

    return { 'start' => start_square, 'finish' => final_square }
  end

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