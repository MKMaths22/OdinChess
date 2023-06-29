# frozen-string-literal: true

class CheckForCheck

include Miscellaneous

  attr_accessor :colour, :poss_board_array, :error_message
  
  def initialize(poss_board_array, colour, error_message = general_into_check_error)
    @colour = colour
    @poss_board_array = poss_board_array
    @error_message = error_message
  end

  def king_in_check?
    boolean = boolean_only_king_in_check?
    puts error_message if boolean
    boolean
  end
  
  def boolean_only_king_in_check?
    coords_hash = find_both_king_coords
    return true if adjacent?(coords_hash[:our_king], coords_hash[:other_king])
    
    king_square = coords_hash[:our_king]
    # puts "king_square = #{king_square}"
    return true if any_hostile_knights?(king_square)
    
    return true if any_hostile_orthogonals?(king_square)

    return true if any_hostile_diagonals?(king_square)

    return true if any_hostile_pawns?(king_square)

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
        return true if poss_piece.kind_of?(Knight) && poss_piece.colour != colour
      end
    end
    false
  end

  def find_first_piece(square, direction)
    # returns the first piece encountered in direction e.g. [x, y] from square which
    # is also given as a coordinate vector. Returns nil if hits the edge of the board 
    # without finding a piece.
    current_coords = add_vector(square, direction)
      while on_the_board?(current_coords)
        poss_piece = get_item(poss_board_array, current_coords)
        return poss_piece if poss_piece 
        current_coords = add_vector(current_coords, direction)
      end
      return nil
  end
  
  def any_hostile_orthogonals?(square)
    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |direction|
      poss_piece = find_first_piece(square, direction)
      if poss_piece
        return true unless poss_piece.colour == colour || poss_piece.is_a?(Knight) || poss_piece.is_a?(Pawn) || poss_piece.is_a?(Bishop) || poss_piece.is_a?(King)
        # we already dealt with adjacent Kings case in find_both_king_coords so this works
      end
    end
    false
  end

  def any_hostile_diagonals?(square)
    [[1, -1], [1, 1], [-1, 1], [-1, -1]].each do |direction|
      poss_piece = find_first_piece(square, direction)
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
        return true if poss_piece.kind_of?(Pawn) && poss_piece.colour != colour
      end
    end
  false
  end

end


