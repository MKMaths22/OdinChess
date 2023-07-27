# frozen_string_literal: true

# ChangeTheBoard class implements the moving of pieces, including en passent/castling. Player who moved
# is prompted for promotion and en_passent chances and castling_rights are updated.
class ChangeTheBoard
  attr_accessor :move, :board, :player, :colour

  def initialize(move, board, player_of_the_move)
    @move = move
    @board = board
    @player = player_of_the_move
    @colour = move.colour
  end

  def update_the_board
    board.update_array(move.poss_board_array)
    board.reset_en_passent
    move.our_piece.update_moved_variable if move.our_piece.respond_to?(:update_moved_variable)
    move.our_piece.update_castling(board, move.start_square) if move.our_piece.respond_to?(:update_castling)
    move.our_piece.add_en_passent(board, move) if move.our_piece.respond_to?(:add_en_passent)
    move.our_piece.promotion(board, player, move.finish_square) if move.our_piece.respond_to?(:promotion) && [0, 7].include?(move.finish_square[1])
    opponent_back_rank = colour == 'White' ? 7 : 0
    board.remove_castling_rights('0-0', true) if move.finish_square == [7, opponent_back_rank]
    board.remove_castling_rights('0-0-0', true) if move.finish_square == [0, opponent_back_rank]
  end
end
