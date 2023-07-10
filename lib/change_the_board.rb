# ChangeTheBoard class implements the moving of pieces, including en passent/castling. Player who moved is prompted for promotion and en_passent chances and castling_rights are updated.
class ChangeTheBoard
  
  attr_accessor :move, :board, :white_name, :black_name, :colour
  
  def initialize(move, board, white_player_name, black_player_name)
    @move = move
    @board = board
    @white_name = white_player_name
    @black_name = black_player_name
    @colour = move.colour
  end

  def update_the_board
    # will ask questions of the Move object @move and tell the Board object to update itself
    puts "update_the_board is working"
    case move.our_piece.class.to_s
    when 'Pawn'
      make_pawn_move
    when 'King'
      make_king_move
    when 'Rook'
      make_rook_move
    else
      make_general_move
    end
    board.toggle_colour_moving
    # the position on the board will tell us whose turn it is to move, but only at the end of the one_turn method is its @colour_moving toggled
  end

  def make_pawn_move
    move.our_piece.update_moved_variable
    # pawns need to know when they have moved so that they can't go 2 squares in one go
    [0, 7].include?(move.finish_square[1]) ? promote_pawn : make_general_move
    # en_passent Move object already has its own poss_board_array so this case
    # does not need to be dealt with separately at this stage.
  end

  def make_king_move
    board.remove_castling_rights('0-0-0')
    board.remove_castling_rights('0-0')
    make_general_move
    # castling Move object already has its own poss_board_array so this case 
    # does not need to be dealt with separately here.
  end

  def make_rook_move
    back_rank = colour == 'White' ? 0 : 7
    board.remove_castling_rights('0-0-0') if move.start_square == [0, back_rank]
    board.remove_castling_rights('0-0') if move.start_square == [7, back_rank]
    make_general_move
  end

  def make_general_move
    puts "make_general_move is working"
    board.update_array(move.poss_board_array)
    board.reset_en_passent
    board.add_en_passent_chance(move.finish_square) if move.our_piece.kind_of?(Pawn) && !(move.vector[1].between?(-1, 1))
    opponent_back_rank = colour == 'White' ? 7 : 0
    puts "opponent_back_rank = #{opponent_back_rank}"
    board.remove_castling_rights('0-0', true) if move.finish_square == [7, opponent_back_rank]
    board.remove_castling_rights('0-0-0', true) if move.finish_square == [0, opponent_back_rank]
  end

  def promote_pawn
    make_general_move
    puts promotion_message(move.colour)
    new_piece = get_piece_for_promotion(gets.strip.upcase, move.colour)
    board.replace_pawn_with(new_piece, move.finish_square)
  end

  def promotion_message(colour)
    name = colour == 'White' ? white_name : black_name
    "You are promoting a pawn, #{name}. Please input 'N' to promote to a Knight, 'R' for Rook, 'B' for Bishop or anything else for a Queen."
  end

  def get_piece_for_promotion(string, colour)
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