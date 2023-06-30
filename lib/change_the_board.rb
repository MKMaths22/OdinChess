# ChangeTheBoard class implements the moving of pieces, including en passent/castling. Player who moved is prompted for promotion and en_passent chances and castling_rights are updated.
class ChangeTheBoard
  def initialize(move, board)
    @move = move
    @board = board
  end

  def update_the_board
    # will ask questions of the Move object @move and tell the Board object to update itself
    case move.our_piece.class
    when Pawn
      make_pawn_move
    when King
      make_king_move
    when Rook
      make_rook_move
    else
      make_general_move
    end
  end

  def make_pawn_move
    our_piece.update_moved_variable
    # pawns need to know when they have moved so that they can't go 2 squares in one go
    if move.en_passent 
      make_en_passent
    elsif move.finish_square[1] == 7
      promote_pawn
    else
      make_general_move
    end
  end

  def make_king_move
    board.remove_castling_rights('0-0-0')
    board.remove_castling_rights('0-0')
    move.castling? ? make_castling : make_general_move
  end

end