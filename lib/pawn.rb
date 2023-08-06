# frozen-string-literal: true

require 'colorize'

# includes the methods that are specific to Pawns
class Pawn < Piece
  attr_accessor :capture_vectors, :non_capture_vectors, :moved

  def initialize(colour)
    super
    @capture_vectors = define_captures
    @non_capture_vectors = define_non_captures
    @basic_display_strings = ['         ', '    o    ', '   / \   ', '   |_|   ']
    @display_strings = apply_colour(@basic_display_strings)
    @moved = false
  end

  def update_moved_variable
    self.moved = true
    self.non_capture_vectors = [@non_capture_vectors[0]]
  end

  def capture_king_possible?(start_square, finish_square,_board)
    # we don't care about en_passent in this method because it is only used to see if
    # the opposition king would be in check
    capture_vectors.any? { |vector| add_vector(start_square, vector) == finish_square }
  end

  def moved?
    @moved
  end

  def define_captures
    colour == 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
  end

  def define_non_captures
    colour == 'White' ? [[0, 1], [0, 2]] : [[0, -1], [0, -2]]
    # rest of code can use the fact that the FIRST non_capture vector
    # has to be playable onto an empty square to consider the SECOND one,
    # if the second one exists.
  end

  def get_all_legal_moves_from(current_square, board)
    self.square = current_square
    reset_moves_to_check
    add_moves_from_capture_vectors(current_square, board)
    add_moves_from_non_capture_vectors(current_square, board)

    output = moves_to_check_for_check.filter(&:legal?)
    # pawn promotion is dealt with in ChangeTheBoard but we don't
    # need to know the piece the pawn promotes to in order to check
    # whether the move is legal
    self.square = nil
    reset_moves_to_check
    output
  end

  def add_moves_from_capture_vectors(current_square, board)
    capture_vectors.each do |vector|
      capture_at = add_vector(current_square, vector)
      moves_to_check_for_check.push(Move.new(board, square, capture_at)) if validate_square_for_moving(board, capture_at) == 'capture'
      self.moves_to_check_for_check.push(Move.new(board, square, capture_at, true, false)) if board.en_passent_capture_possible_at?(capture_at)
    end
  end

  def add_moves_from_non_capture_vectors(current_square, board)
    first_non_capture_square = add_vector(current_square, non_capture_vectors[0])
    return unless validate_square_for_moving(board, first_non_capture_square) == 'non-capture'

    moves_to_check_for_check.push(Move.new(board, square, first_non_capture_square))
    return unless non_capture_vectors[1]

    other_square = add_vector(current_square, non_capture_vectors[1])
    self.moves_to_check_for_check.push(Move.new(board, square, other_square)) if validate_square_for_moving(board, other_square) == 'non-capture'
  end

  def add_en_passent(board, move)
    board.add_en_passent_chance(move.finish_square) unless move.vector[1].between?(-1, 1)
  end

  def promotion(board, player, square)
    puts promotion_message(player)
    new_piece = piece_for_promotion(player, board.colour_moving)
    board.replace_pawn_with(new_piece, square)
  end

  def promotion_message(player)
    "You are promoting a pawn, #{player.name}. Please input 'N' to promote to a Knight, 'R' for Rook, 'B' for Bishop or anything else for a Queen."
  end

  def piece_for_promotion(player, colour)
    string = player.promotion_input
    case string
    when 'N'
      Knight.new(colour)
    when 'R'
      Rook.new(colour)
    when 'B'
      Bishop.new(colour)
    else
      Queen.new(colour)
    end
  end
end
