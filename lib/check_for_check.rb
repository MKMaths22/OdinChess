# frozen-string-literal: true

class CheckForCheck

include Miscellaneous

  attr_accessor :colour, :poss_board_array, :error_message, :king_square, :checking_piece_square, :squares_between
  
  def initialize(poss_board_array, colour, error_message = general_into_check_error)
    @colour = colour
    @poss_board_array = poss_board_array
    @error_message = error_message
    @king_square = nil
    @checking_piece_square = nil
    @squares_between = []
  end

  def king_in_check?(error = false)
    partly_boolean = partly_boolean_king_in_check?
    puts error_message if partly_boolean && error
    # the default behaviour is now NOT to put an error message because the error messages
    # are left over from the code which was checking a PARTICULAR move inputted by the player
    # and are not relevant for the new way which is of generating ALL legal moves
    partly_boolean
  end
  
  def output_hash
    { 'our_king_square' => king_square, 'checking_piece_square' => checking_piece_square, 'squares_between' => squares_between }
  end
  
  def partly_boolean_king_in_check?
    # outputs either false or a hash of { our_king_coords => king_square, checking_piece_coords => check_from_square, line_of_attack = 2_D array of coordinates of squares where check could be blocked } The return value features the details of ONE line of attack from A checking piece. It could be a double check, but we are just trying 
    # to provide minimum conditions for getting out of check
    coords_hash = find_both_king_coords
    return true if adjacent?(coords_hash[:our_king], coords_hash[:other_king])
    # the position would be illegal anyway, so no need to output more detailed information to help us get out of check
    
    self.king_square = coords_hash[:our_king]
    # puts "king_square = #{king_square}"
    return output_hash if any_hostile_knights?(king_square)
    
    
    return output_hash if any_hostile_orthogonals?(king_square)
    

    return output_hash if any_hostile_diagonals?(king_square)
    

    return output_hash if any_hostile_pawns?(king_square)

    false

    # poss_board_array is an actual or hypothetical board position given in the
    # format of the Board class @board_array variable. We are checking whether the King
    # of colour 'colour' is in check.
  end

  def find_both_king_coords
    output = {}
    poss_board_array.each_with_index do |file, file_index|
      file.each_with_index do |piece, rank_index|
        if piece.kind_of?(King)
          coords = [file_index, rank_index]
          piece.colour == colour ? output[:our_king] = coords : output[:other_king] = coords
        end
      end
    end
    output
  end

  def any_hostile_knights?(square)
    KNIGHT_VECTORS.each do |vector|
      poss_square = add_vector(square, vector)
      if on_the_board?(poss_square)
        poss_piece = get_item(poss_board_array, poss_square)
        if poss_piece.kind_of?(Knight) && poss_piece.colour != colour
          self.checking_piece_square = poss_square
          return true
        end
      end
    end
    false
  end

  def find_first_piece_and_squares_between(square, direction)
    # returns the first piece encountered in direction e.g. [x, y] from square which
    # is also given as a coordinate vector. Returns nil if hits the edge of the board 
    # without finding a piece.
    current_coords = add_vector(square, direction)
      while on_the_board?(current_coords)
        poss_piece = get_item(poss_board_array, current_coords)
        if poss_piece
          self.checking_piece_square = current_coords
          return poss_piece
        end
        self.squares_between.push(current_coords) 
        current_coords = add_vector(current_coords, direction)
      end
      self.squares_between = []
      # reset the instance variable ready for any future searches. The #output_hash 
      # method returns the squares_between that were found in the last search we made.
      # The checking_piece_square outputted also are the last ones found
      return nil
  end
  
  def any_hostile_orthogonals?(square)
    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |direction|
      poss_piece = find_first_piece_and_squares_between(square, direction)
      if poss_piece
        return true unless poss_piece.colour == colour || poss_piece.is_a?(Knight) || poss_piece.is_a?(Pawn) || poss_piece.is_a?(Bishop) || poss_piece.is_a?(King)
        # we already dealt with adjacent Kings case in find_both_king_coords so this works
        
      end
    end
    false
  end

  def any_hostile_diagonals?(square)
    [[1, -1], [1, 1], [-1, 1], [-1, -1]].each do |direction|
      poss_piece = find_first_piece_and_squares_between(square, direction)
      if poss_piece
        return true unless poss_piece.colour == colour || poss_piece.is_a?(Knight) || poss_piece.is_a?(Pawn) || poss_piece.is_a?(Rook) || poss_piece.is_a?(King)
        # pawns will be dealt with separately
      end
    end
    false
  end

  def any_hostile_pawns?(square)
    danger_vectors = colour == 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
    danger_vectors.each do |vector| 
      poss_square = add_vector(square, vector)
      if on_the_board?(poss_square) 
        poss_piece = get_item(poss_board_array, poss_square)
        if poss_piece.is_a?(Pawn) && poss_piece.colour != colour
          self.checking_piece_square = poss_square
          return true
        end
      end
    end
    false
  end

end


