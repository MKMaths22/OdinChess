# frozen-string-literal: true

require 'colorize'

# Piece class is superclass of #Pawn, #Bishop,#Rook, #Queen, #Knight, #King. Each piece has a @colour
# and the subclasses all have same-named methods for determining if moves are 'legal' for moving/
# capturing, not accounting for where other pieces are or if own king is in Check.
class Piece
  include Miscellaneous

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check

  def initialize(colour)
    @colour = colour
    @movement_vectors = nil
    @base_vectors = nil
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
  end

  def apply_colour(array_of_strings)
    colour_to_use = (colour == 'White' ? :light_white : :black)
    array_of_strings.map { |string| string.colorize(color: colour_to_use) }
  end

  def reset_moves_to_check
    self.moves_to_check_for_check = []
  end

  def on_the_board?(coords)
    coords[0].between?(0, 7) && coords[1].between?(0, 7)
  end

  def validate_square_for_moving(board, square)
    # asks if the Piece can move to the square 'square' on the 'board',
    # ignoring issues of check. This is not used for castling/en_passent.
    # Also tests whether the square is on the chessboard.
    # returns either false, 'capture' or 'non-capture'
    return false unless on_the_board?(square)

    poss_piece = board.get_piece_at(square)
    return 'non-capture' unless poss_piece

    poss_piece.colour == colour ? false : 'capture'
  end

  def capture_possible?(start_square, finish_square, board)
    # the piece in question is on 'start_square' in a Board object, 'board' and we want
    # to know if it can capture the King on the finish_square, ignoring
    # check issues on our own King.
    # This method is ONLY used when the opposition King is on the finish_square.
    if base_vectors
      base_vectors.each do |vector|
        square_to_try = add_vector(start_square, vector)
        while validate_square_for_moving(board, square_to_try) == 'non-capture'
          square_to_try = add_vector(square_to_try, vector)
        end
        return true if square_to_try == finish_square
      end
      false
    else
      # use movement vectors if there are no base vectors
      movement_vectors.map { |vector| add_vector(start_square, vector) }.include?(finish_square)
    end
  end

  def get_all_legal_moves_from(current_square, board)
    self.square = current_square
    reset_moves_to_check
    base_vectors ? moves_from_base_vectors(board) : moves_from_movement_vectors_and_castling(board)
    # this format covers all piece classes except Pawn, which will have
    # its own #get_all_legal_moves_from method
    output = moves_to_check_for_check.filter(&:legal?)
    # the #legal? in Move class will take care of check issues
    self.square = nil
    reset_moves_to_check
    output
  end

  def moves_from_base_vectors(board)
    possible_squares = []
    base_vectors.each do |vector|
      possible_squares = possible_squares.concat(get_possible_squares_in_this_direction(vector, board))
    end
    self.moves_to_check_for_check = make_move_objects(board, possible_squares)
  end

  def moves_from_movement_vectors_and_castling(board)
    possible_squares = movement_vectors.map { |vector| add_vector(square, vector) }.filter { |poss_square| validate_square_for_moving(board, poss_square) }
    self.moves_to_check_for_check = make_move_objects(board, possible_squares)

    possible_castling_vectors = castling_vectors.filter { |vector| board.castling_rights_from_vector?(vector) && !board.pieces_in_the_way?(squares_to_check_clear_for_castling(colour, vector)) }

    possible_squares = possible_castling_vectors.map { |vector| add_vector(square, vector) }
    moves_to_check_for_check.concat(make_move_objects(board, possible_squares, false, true))
  end

  def squares_to_check_clear_for_castling(colour, vector)
    # colour = 'White' or 'Black'. Vector = [2, 0] or [-2, 0]
    # to indicate King or Queenside castling.
    # method outputs the squares that have to be empty between
    # the King and Rook, as a 2-D array.
    output = vector[0].positive? ? [[5], [6]] : [[1], [2], [3]]
    row = colour == 'White' ? 0 : 7
    output.each do |item|
      item.push(row)
    end
    output
  end

  def get_possible_squares_in_this_direction(vector, board)
    squares_found = []
    square_to_try = add_vector(square, vector)
    while validate_square_for_moving(board, square_to_try) == 'non-capture'
      squares_found.push(square_to_try)
      square_to_try = add_vector(square_to_try, vector)
    end
    squares_found.push(square_to_try) if validate_square_for_moving(board, square_to_try) == 'capture'
    # the first square found that is not clear is still good if we can capture
    # an opponent's piece, but then we go no further.
    squares_found
  end

  def make_move_objects(board, possible_squares, en_passent = false, castling = false)
    possible_squares.map { |finish| Move.new(board, square, finish, en_passent, castling) }
  end
end
