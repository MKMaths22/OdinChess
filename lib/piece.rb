# frozen-string-literal: true

require 'colorize'
# At first various Piece classes will repeat each other. Refactor repitition out at the end
class Piece
  
include Miscellaneous
  
attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings

  def initialize(colour)
    @colour = colour
    @movement_vectors = nil
    @base_vectors = nil
    @castling_vectors = []
  end

  def apply_colour(array_of_strings)
    colour_to_use = (colour == 'White' ? :light_white : :black)
    array_of_strings.map { |string| string.colorize(color: colour_to_use) } 
  end

  def get_movement_vectors(base_vectors)
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
  
  def move_like_that(vector, capture)
    # this method asks if the piece can move in the fashion of 'vector' subject to pieces getting in the way or own-King-in-check issues given
    # that 'capture' is a Boolean saying whether it is a capturing move
    # output is either false or a hash featuring castling and en passent keys 
    # which can have only at most one true value and a 'sub_vectors' which allows the Move class to ask the Board class which squares may have pieces
    # in the way.
    # Effectively if a Pawn is replying to this method it may say 'move is OK only if it is en_passent'

    output_hash = { 'castling' => false, 'en_passent' => false, 'sub_vectors' => [] }

    if castling_vectors.include?(vector)
      # can only be triggered in King class, otherwise there
      # are no castling vectors
      new_hash = add_castling_to_hash(vector, colour, output_hash)
      
      return output_hash
    end

    unless movement_vectors.include?(vector)
      puts piece_move_error
      return false
    end
    
    output_hash['sub_vectors'] = movement_vectors.select { |movement| subvector?(vector, movement) }
    output_hash
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

  def same_square_error
    "Finishing square cannot be the same as starting square. Please try again."
  end

  def piece_move_error
    "The #{self.class} does not move like that. Please try again."
  end
end

class Bishop < Piece

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors
  
  def initialize(colour)
    @colour = colour
    @base_vectors = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    @movement_vectors = get_movement_vectors(base_vectors)
    @castling_vectors = []
    @basic_display_strings = ['    o    ', '   ( )   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end

end

class Rook < Piece

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors

  def initialize(colour)
    @colour = colour
    @base_vectors = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    @movement_vectors = get_movement_vectors(base_vectors)
    @castling_vectors = []
    @basic_display_strings = ['  n_n_n  ', '  \   /  ', '  |   |  ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end

end

class Queen < Piece

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors

  def initialize(colour)
    @colour = colour
    @base_vectors = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @movement_vectors = get_movement_vectors(base_vectors)
    @castling_vectors = []
    @basic_display_strings = ['  ooooo  ', '   \ /   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end

end

class Knight < Piece

  attr_accessor :colour, :movement_vectors, :castling_vector, :base_vectors

  def initialize(colour)
    @colour = colour
    @movement_vectors = KNIGHT_VECTORS
    @castling_vectors = []
    @basic_display_strings = ['    __,  ', '  /  o\  ', '  \  \_> ', '  /__\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end

  def get_subvectors
    # not strictly necessary, but for emphasis that knight moves
    # cannot be blocked by pieces in the way
    []
  end


end

class Pawn < Piece

  # pawn promotion dealt with separately under 'ConsequencesOfMove'
  # which may be a separate class?
  
  attr_accessor :colour, :capture_vectors, :non_capture_vectors, :moved, :base_vectors
  
  def initialize(colour)
    @colour = colour
    @moved = false
    @capture_vectors = get_captures(colour)
    @non_capture_vectors = get_non_captures(colour)
    @castling_vectors = []
    @basic_display_strings = ['         ', '    o    ', '   ( )   ', '   |_|   ']
    @display_strings = apply_colour(@basic_display_strings)
  end

  def move_like_that(vector, capture)
    # this method asks if the Pawn can move in the fashion of 'vector' subject to pieces getting in the way or own-King-in-check issues given
    # that 'capture' is a Boolean saying whether it is a capturing move
    # output is either false or a hash featuring castling and en passent keys 
    # which can have only at most one true value and a 2-D array which is the value of the key 'sub_vectors' which allows the Move class to ask the Board class which squares may have pieces
    # in the way.
    # Effectively if a Pawn is replying to this method it may say 'move is OK only if it is en_passent'
    
    output_hash = { 'castling' => false, 'en_passent' => false, 'sub_vectors' => [] }

    unless capture_vectors.include?(vector) || non_capture_vectors.include?(vector)
      puts piece_move_error
      return false
    end
    
    non_capture_vectors.include?(vector) ? pawn_goes_straight_forwards(vector, output_hash, capture) : pawn_goes_diagonally(output_hash, capture)
  end
      
  def pawn_goes_straight_forwards(vector, hash, capture)
    
    if moved && !vector[1].between?(-1, 1)
      puts pawn_already_moved_error
      return false
    end

    if capture
      puts pawn_capture_error
      return false
    end
        
    hash['sub_vectors'] = non_capture_vectors.select { |movement| subvector?(vector, movement) }
        
    return hash
  end
  
  def pawn_goes_diagonally(hash, capture)
    # In this scenario there are no sub_vectors.

    # if not , Pawn class responds effectively saying move is 
    # OK subject to king_in_check issues if and only if it is en_passent.
    hash['en_passent'] = true unless capture
    hash
  end

  def pawn_capture_error
    "Pawns don't capture like that. Please try again."
  end

  def pawn_already_moved_error
    "Pawns can only go two squares if they haven't already moved. Please try again."
  end

  def get_captures(colour)
    colour == 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
  end

  def get_non_captures(colour)
    colour == 'White' ? [[0, 1], [0, 2]] : [[0, -1], [0, -2]]
  end
  
  # def move_legal?(board, start, finish)
  #  vector_tried = subtract_vector(finish, start)
  #  if vector_tried = [0, 0]
  #    puts same_square_error
  #    return false
  #  end
    
  #  unless capture_vectors.include?(vector_tried) || non_capture_vectors.include?(vector_tried)
   #   puts piece_move_error
    #  return false
  #  end

   # capture_vectors.include?(vector_tried) ? capture_legal?(board, start, finish) : non_capture_legal?(board, start, finish, vector_tried)
  # end

  # def non_capture_legal?(board, start, finish, vector)
  #  squares_between = find_squares_between(start, finish, vector)
    
   # return false unless board.pieces_between_allow_move?(start, finish, squares_between)

   # poss_piece_at_finish = board.get_piece_at(finish)
   #   if poss_piece_at_finish
   #     puts poss_piece_at_finish.colour == colour? piece_in_the_way_error : pawn_capture_error
    #    return false
   #   end

  #  return false if board.check_for_check(start, finish, colour)
    
  #  true
  # end

  # def find_squares_between(start, finish, vector)
  #  return [] if vector[1].between?(-1, 1)
    
  #  [[0, 1]] if vector[1].positive?
  #  [[0, -1]] if vector[1].negative?
  # end
  
  # def capture_legal?(board, start, finish)
  #  poss_piece_at_finish = board.get_piece_at(finish)
  #    if poss_piece_at_finish && poss_piece_at_finish.colour == colour
  #      puts capture_own_piece_error
  #      return false
  #    end

  #    if poss_piece_at_finish
        # in this case the piece is one we can capture
  #      return !board.check_for_check(start, finish, colour)
  #    end

      # now definitely no piece on finish square
  #    unless board.en_passent?(finish)
   #     puts piece_move_error
   #     return false
   #   end

  #    return !board.check_for_check(start, finish, colour, true)
  # end
end

class King < Piece

  attr_accessor :colour, :capture_vectors, :non_capture_vectors, :moved
  
  def initialize(colour)
    @colour = colour
    @movement_vectors = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    @castling_vectors = [[0, -2], [0, 2]]
    @basic_display_strings = ['    +    ', '   \ /   ', '   ( )   ', '   /_\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end

  def find_squares_between
    # not strictly necessary, but for emphasis that King moves
    # cannot be blocked by pieces in the way
    # Castling is dealt with separately in this regard
    []
  end
end