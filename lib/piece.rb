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
  
  attr_accessor :colour, :capture_vectors, :non_capture_vectors
  
  def initialize(colour)
    @colour = colour
    @moved = false
    @capture_vectors = get_captures(colour)
    @non_capture_vectors = get_non_captures(colour)
  end

  def pawn_capture_error
    "Pawns don't capture like that. Please try again."
  end

  def get_captures(colour)
    colour = 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
  end

  def get_non_captures(colour)
    colour = 'White' ? [[0, 1], [0, 2]] : [[0, -1], [0, -2]]
  end
  
  def move_legal?(board, start, finish)
    vector_tried = subtract_vector(finish, start)
    if vector_tried = [0, 0]
      puts same_square_error
      return false
    end
    
    unless capture_vectors.include?(vector_tried) || non_capture_vectors.include?(vector_tried)
      puts piece_move_error
      return false
    end

    capture_vectors.include?(vector_tried) ? capture_legal?(board, start, finish) : non_capture_legal?(board, start, finish, vector_tried)
  end

  def non_capture_legal?(board, start, finish, vector)
    squares_between = find_squares_between(start, finish, vector)
    
    return false unless board.pieces_between_allow_move?(start, finish, squares_between)

    poss_piece_at_finish = board.get_piece_at(finish)
      if poss_piece_at_finish
        puts poss_piece_at_finish.colour == colour? piece_in_the_way_error : pawn_capture_error
        return false
      end

    return false if board.check_for_check(start, finish, colour)
    
    true
  end

  def find_squares_between(start, finish, vector)
    return [] if vector[1].between?(-1, 1)
    
    [[0, 1]] if vector[1].positive?
    [[0, -1]] if vector[1].negative?
  end
  
  def capture_legal?(board, start, finish)
    poss_piece_at_finish = board.get_piece_at(finish)
      if poss_piece_at_finish && poss_piece_at_finish.colour == colour
        puts capture_own_piece_error
        return false
      end

      if poss_piece_at_finish
        # in this case the piece is one we can capture
        return !board.check_for_check(start, finish, colour)
      end

      # now definitely no piece on finish square
      unless board.en_passent?(finish)
        puts piece_move_error
        return false
      end

      return !board.check_for_check(start, finish, colour, true)
  end
  
  
  # if moved && [2, -2].include?(vector_tried[1])
   #   puts piece_move_error
   #   return false
   # end

    # at this stage the vector_tried is a valid one for the
    # pawn's colour but we still don't know if it is
    # trying to capture or not
    finish_piece = board.get_piece_at(finish)
      
    #unless finish_piece
    #  unless vector_tried[0].zero?
   #     puts piece_move_error
    #    return false
   #   end
   #     squares_between = find_squares_between(start, vector_tried)
   #     return false unless board.pieces_allow_move(start, finish, colour, squares_between)
        # pawn move is not a capture in this case
   # end
      
   # if finish_piece && finish_piece.colour == colour
    #  puts piece_in_the_way_error
   #   return false
   # end

   # if finish_piece
   #   # in this case finish_piece is of the opposite colour
   #  if vector_tried[0].zero?
    #    puts piece_move_error
   #   end
   # end

   # return false if board.check_for_check(start, finish, colour)
    
   # true
 # end

  



end