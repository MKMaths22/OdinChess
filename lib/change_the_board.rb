# ChangeTheBoard class implements the moving of pieces, including en passent/castling. Player who moved is prompted for promotion and en_passent chances and castling_rights are updated.
class ChangeTheBoard
  def initialize(move, board)
    @move = move
    @board = board
  end

  def update_the_board
    # will ask questions of the Move object @move and tell the Board object to update itself
  end

end