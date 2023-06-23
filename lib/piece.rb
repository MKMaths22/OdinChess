# At first various Piece classes will repeat each other. Refactor repitition out at the end
class Piece
  def initialize (colour)
    @colour = colour 
  end

  def move_legal?(board, start, finish)
    # start and finish are arrays of 2 co-ordinates for use in the board_array
    # of the board
  end

end

class Bishop < Piece

  def initialize
    @movement_vectors = get_vectors
  end

  def get_vectors
    # outputs the vectors the piece can move in, assuming we don't go off the edge of 
    # the board. 
  end

  def get_subvectors(vector)
    # outputs the intermediate vector steps as a 2-D array so that we can tell the board class which
    # squares in between have to be checked for a move to be legal
  end
  
  def move_legal?(board, start, finish)
    direction = empty_board_move(start, finish)
    return false unless direction 
    # direction returns either false or [1,1], [1, -1], [-1, 1] or [-1, -1]

    capture_or_not = board.pieces_allow_move(start, finish, colour, direction)
    return false unless capture_or_not
    # if capture_or_not is truthy, it is either 'capture' or 'not_capture'
    # This distinction may not be relevant for the algorithm overall

    return false if board.check_for_check(start, finish, colour)
    true
  end

  def empty_board_move(start, finish)
    vector = [finish[0] - start[0], finish[1] - start[1]]
    if vector[0] == vector[1]
      return [1, 1] if vector[0] > 0
      return [-1, -1] if vector[0] < 0
      puts same_square_error
      return false
    end

    if vector[0] == -vector[1]
      return [1, -1] if vector[0] > 0
      return [-1, 1] if vector[0] < 0
    end
    puts bishop_move_error
    return false
  end

  def same_square_error
    "Finishing square cannot be the same as starting square. Please try again."
  end

  # for refactoring could use .class to name the piece in this error message below
  
  def bishop_move_error
    "The bishop does not move like that. Please try again."
  end

end

class Rook < Piece

end