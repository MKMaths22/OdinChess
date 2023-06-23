# frozen-string-literal: true

# At first various Piece classes will repeat each other. Refactor repitition out at the end
class Piece
  
include Miscellaneous
  
  attr_accessor :colour, :movement_vectors

  def initialize (colour)
    @colour = colour
    @movement_vectors = get_vectors
  end

  def move_legal?(board, start, finish)
    # start and finish are arrays of 2 co-ordinates for use in the board_array
    # of the board
  end

  def same_square_error
    "Finishing square cannot be the same as starting square. Please try again."
  end

  def piece_move_error
    "The #{self.class} does not move like that. Please try again."
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
    vector_tried = subtract_vector(finish, start)
    if vector_tried = [0, 0]
      puts same_square_error
      return false
    end
    unless movement_vectors.include?(vector_tried)
      puts piece_move_error
      return false
    end
    squares_between = find_squares_between(start, vector_tried)capture_or_not = board.pieces_allow_move(start, finish, colour, squares_between)
    return false unless capture_or_not
    # if capture_or_not is truthy, it is either 'capture' or 'not_capture'
    # This distinction may not be relevant for the algorithm overall
    return false if board.check_for_check(start, finish, colour)
    true
  end

  def subvector?(big_vector, small_vector)
    big_vector.each_with_index do |big_num, index|
      return false unless small_vector[index].between?(1, big_num - 1) || small_vector[index].between?(big_num + 1, -1)
      # each value of small_vector must lie strictly between the 
      # corresponding value of big_vector and zero, with the same sign
    end
    true
  end
  
  def find_squares_between(start, vector)
    squares_between = []
    movement_vectors.each do |movement|
      squares_between.push(add_vector(start, movement)) if subvector?(vector, movement)
    end
  end

end

class Rook < Piece

end