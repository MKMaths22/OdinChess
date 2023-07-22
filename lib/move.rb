# frozen_string_literal: true

class Move

include Miscellaneous

  attr_accessor :string, :colour, :board, :start_square, :finish_square, :en_passent, :castling, :poss_board_array, :vector, :our_piece, :other_piece

  def initialize(board, start_square, finish_square, en_passent = false, castling = false)
    @colour = board.colour_moving
    @board = board
    @start_square = start_square
    @finish_square = finish_square
    @vector = subtract_vector(finish_square, start_square)
    @en_passent = en_passent
    @castling = castling
    @poss_board_array = nil
    @our_piece = board.get_piece_at(start_square)
    @other_piece = board.get_piece_at(finish_square)
  end

  def pawn_move_or_capture?
    our_piece.kind_of?(Pawn) || other_piece
  end

  def legal?
    castling ? legal_castling? : legal_non_castling?
  end
      
  def legal_castling? 
    reduced_vector = get_reduced_vector(vector)
    castling_string = castling_string_from_vector(vector, colour)
    rook_start = get_rook_start(castling_string)
    rook_finish = get_rook_finish(castling_string)
      # reduced_vector is the vector the king travels to the square in the middle of the castling move e.g. from e1 to f1.
    self.poss_board_array = board.make_new_array_for_castling(start_square, finish_square, rook_start, rook_finish)
    !board.would_castling_be_illegal_due_to_check?(colour, start_square, vector, reduced_vector)
  end
    
  def legal_non_castling?
    self.poss_board_array = board.make_new_array(start_square, finish_square, en_passent)
    return !board.would_move_leave_us_in_check?(poss_board_array)
  end
end