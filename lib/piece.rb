# frozen-string-literal: true

# At first various Piece classes will repeat each other. Refactor repitition out at the end
class Piece
  
include Miscellaneous
  
  attr_accessor :colour, :movement_vectors

  def initialize(colour)
    @colour = colour
    @movement_vectors = get_vectors(base_vectors)
    @base_vectors = nil
  end

  def get_vectors(base_vectors)
    output = []
    base_vectors.each do |vector|
      (1..7).each do |num|
        output.push([num*vector[0], num*vector[1]])
      end
    end
    output
  end

  def get_subvectors(vector)
    movement_vectors.select { |movement| subvector?(vector, movement) }
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

  def magnitude_squared(vector)
    vector[0]*vector[0] + vector[1]*vector[1]
  end
  
  def subvector?(big_vector, small_vector)
      return false unless big_vector[1]*small_vector[0] == big_vector[0]*small_vector[1]
      (0...1).each do |num|
        return false if (big_vector[num]*small_vector[num]).negative?
      end
      return true if magnitude_squared(small_vector) < magnitude_squared(big_vector)
  end
  
  def find_squares_between(start, vector)
    squares_between = []
    movement_vectors.each do |movement|
      squares_between.push(add_vector(start, movement)) if subvector?(vector, movement)
    end
  end

  def same_square_error
    "Finishing square cannot be the same as starting square. Please try again."
  end

  def piece_move_error
    "The #{self.class} does not move like that. Please try again."
  end
end

class Bishop < Piece

  attr_accessor :base_vectors
  
  def initialize
    super
    @base_vectors = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  end

end

class Rook < Piece

  attr_accessor :base_vectors

  def initialize
    super
    @base_vectors = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  end

end

class Queen < Piece

  attr_accessor :base_vectors

  def initialize
    super
    @base_vectors = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
  end

end

class Knight < Piece

  def initialize(colour)
    @colour = colour
    @movement_vectors = KNIGHT_VECTORS
  end

  def find_squares_between
    # not strictly necessary, but for emphasis that knight moves
    # cannot be blocked by pieces in the way
    []
  end


end


class Pawn < Piece

  # pawn promotion dealt with separately under 'ConsequencesOfMove'
  # which may be a separate class?
  
  attr_accessor :colour, :movement_vectors
  
  def initialize(colour)
    @colour = colour
    @moved = false
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

  



end