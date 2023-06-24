# frozen-string-literal: true

class CheckForCheck

include Miscellaneous

  attr_accessor :colour, :poss_board_array
  
  def initialize(colour, poss_board_array)
    @colour = colour
    @poss_board_array = poss_board_array
  end

  def king_in_check?
    coords_hash = find_both_king_coords
    return true if adjacent?(coords_hash[:our_king], coords_hash[:other_king])
    
    king_square = coords_hash[:our_king]
    return true if any_hostile_knights?(king_square)

    return true if any_hostile_orthogonals?(king_square)

    return true if any_hostile_diagonals?(king_square)

    return true if any_hostile_pawns?(king_square)

    # poss_board_array is an actual or hypothetical board position given in the
    # format of the Board class @board_array variable. We are checking whether the King
    # of colour 'colour' is in check.
  end

  def find_both_king_coords
    output = {}
    poss_board_array.each_with_index do |file, file_index|
      file.each_with_index do |piece, rank_index|
        if piece.kind_of?(King) 
          output[:our_king] = [file, rank] if piece.colour == colour
        else output[:other_king] = [file, rank]
        end
      end
    end
  end

  def any_hostile_knights?(square)
    KNIGHT_VECTORS.each do |vector|
      poss_square = add_vector(square, vector)
      if poss_square.on_the_board?
        poss_piece = get_item(poss_board_array, poss_square)
        return true if poss_piece.kind_of?(Knight) && poss_piece.colour != colour
      end
    end
  end

  def find_first_piece(square, direction)
    # returns the first piece encountered in direction e.g. [x, y] from square which
    # is also given as a coordinate vector. Returns nil if hits the edge of the board 
    # without finding a piece.
    current_coords = add_vector(square, direction)
      while current_coords.on_the_board?
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
        return true unless poss_piece.colour == colour || piece.is_a?(Knight) || piece.is_a?(Pawn) || piece.is_a?(Bishop) || piece.is_a?(King)
        # we already dealt with adjacent Kings case in find_both_king_coords so this works
      end
    end

  end

  def any_hostile_diagonals?(square)
    [[1, -1], [1, 1], [-1, 1], [-1, -1]].each do |direction|
      poss_piece = find_first_piece(square, direction)
      if poss_piece
        return true unless poss.piece.colour == colour || piece.is_a?(Knight) || piece.is_a?(Pawn) || piece.is_a?(Rook) || piece.is_a?(King)
        # pawns will be dealt with separately
      end
    end
  end

  def any_hostile_pawns?(square)
    danger_vectors = colour == 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
    danger_vectors.each do |vector| 
      poss_square = add_vector(square, vector)
      if poss_square.on_the_board? 
        poss_piece = get_item(poss_board_array, poss_square)
        return true if poss_piece.kind_of?(Pawn) && poss_piece.colour != colour
      end
    end
  end

end


