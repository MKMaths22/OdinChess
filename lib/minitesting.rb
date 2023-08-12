#frozen_string_literal: true

require './game.rb'
require 'minitest/autorun'

class ChessTest < Minitest::Test
  # tests the outcome of a specific Game
  def test_a_quick_white_win
    # skip
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'e7e5', 'd1f3', 'a7a6', 'f1c4', 'h7h6', 'f3f7']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "Congratulations, player_one. That's checkmate! Better luck next time, player_two."
  end

  def test_a_quick_black_win
    # skip 
    list_of_inputs = ['player_one', 'player_two', 'f2f3', 'e7e5', 'g2g4', 'd8h4']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "Congratulations, player_two. That's checkmate! Better luck next time, player_one."
  end

  def test_white_resignation
    # skip
    list_of_inputs = ['player_one', 'player_two', 'resign']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "player_two wins, congratulations! Better luck next time, player_one."
  end

  def test_black_resignation
    # skip
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'resign']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "player_one wins, congratulations! Better luck next time, player_two."
  end

  def test_three_fold_repitition_at_start
    # skip
    list_of_inputs = ['player_one', 'player_two', 'g1f3', 'g8f6', 'f3g1', 'f6g8', 'g1f3', 'g8f6', 'f3g1', 'f6g8']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "That's the exact same position, for the third time. It's a 3-fold repitition draw. Well played, player_two and player_one."
  end

  def test_three_fold_repitition_later
    # skip
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'e7e5', 'g1f3', 'g8f6', 'f3g1', 'f6g8', 'g1f3', 'g8f6', 'f3g1', 'f6g8']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "That's the exact same position, for the third time. It's a 3-fold repitition draw. Well played, player_two and player_one."
  end

  def test_insufficient_material_draw_kings_only
    # skip
    test_array = [[King.new('White'), nil, nil, nil, nil, nil, Pawn.new('White'), nil], [nil, nil, nil, nil, nil, nil, King.new('Black'), nil], Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8)]
    test_board = Board.new(test_array, 'Black', { 'White_0-0-0' => false, 'White_0-0' => false, 'Black_0-0-0' => false, 'Black_0-0' => false })
    list_of_inputs = ['player_one', 'player_two', 'b7a7']
    test_game = Game.new(test_board, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "There isn't enough material on the board for a checkmate, so it's a draw by insufficient material. Well played, player_one and player_two."
  end

  def test_insufficient_material_draw_underpromotion
    # skip
    test_array = [[King.new('White'), nil, nil, nil, nil, nil, Pawn.new('White'), nil], [nil, nil, nil, nil, nil, nil, King.new('Black'), nil], Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8)]
    test_board = Board.new(test_array, 'Black', { 'White_0-0-0' => false, 'White_0-0' => false, 'Black_0-0-0' => false, 'Black_0-0' => false })
    list_of_inputs = ['player_one', 'player_two', 'b7c7', 'a7a8', 'N']
    test_game = Game.new(test_board, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "There isn't enough material on the board for a checkmate, so it's a draw by insufficient material. Well played, player_two and player_one."
  end

  def test_fifty_move_rule_draw
    # skip
    test_array = [[King.new('White'), nil, nil, nil, nil, nil, Pawn.new('White'), nil], [nil, nil, nil, nil, nil, nil, King.new('Black'), nil], Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8), Array.new(8)]
      test_board = Board.new(test_array, 'Black', { 'White_0-0-0' => false, 'White_0-0' => false, 'Black_0-0-0' => false, 'Black_0-0' => false })
      list_of_inputs = ['player_one', 'player_two', 'b7c6', 'a7a8', 'Q',
    'c6d6', 'a1b1', 'd6e6', 'b1a1', 'e6f6', 'a1b1', 'f6g6', 'b1a1', 'g6h6', 'a1b1', 'h6g6', 'b1c1', 'g6f6', 'c1b1', 'f6e6', 'b1c1', 'e6d6', 'c1b1', 'd6c7', 'b1c1','c7d6', 'c1d1', 'd6e6', 'd1c1', 'e6f6', 'c1d1', 'f6g6', 'd1c1', 'g6h6', 'c1d1', 'h6g6', 'd1e1', 'g6f6', 'e1d1', 'f6e6', 'd1e1', 'e6d6', 'e1d1', 'd6c7', 'd1e1', 'c7d6', 'e1f1', 'd6e6', 'f1e1', 'e6f6', 'e1f1', 'f6g6', 'f1e1', 'g6h6', 'e1f1', 'h6g6', 'f1g1', 'g6f6', 'g1f1', 'f6e6', 'f1g1', 'e6d6', 'g1f1', 'd6c7', 'f1g1', 'c7d6', 'g1h1', 'd6e6', 'h1g1', 'e6f6', 'g1h1', 'f6g6', 'h1g1', 'g6h6', 'g1h1', 'h6g6', 'h1h2', 'g6f6', 'h2h1', 'f6e6', 'h1h2', 'e6d6', 'h2h1', 'd6c7', 'h1h2', 'c7d6', 'h2h3', 'd6e6', 'h3h2', 'e6f6', 'h2h3', 'f6g6', 'h3h2', 'g6h6', 'h2h3','h6g6', 'h3h4', 'g6f6', 'h4h3', 'f6e6', 'h3h4', 'e6d6', 'h4h3', 'd6c7', 'h3h4']
    test_game = Game.new(test_board, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "You guys have shuffled your pieces for 50 moves with no real progress, so it's a draw. Well played, player_two and player_one."
  end

  def test_quickish_stalemate
    # skip
    list_of_inputs = ['player_one', 'player_two', 'e2e3', 'a7a5', 'd1h5', 'a8a6', 'h5a5', 'h7h5', 'h2h4', 'a6h6', 'a5c7', 'f7f6', 'c7d7', 'e8f7', 'd7b7', 'd8d3', 'b7b8', 'd3h7', 'b8c8', 'f7g6', 'c8e6']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "It's a draw by stalemate! Well played, player_one and player_two."
  end

  def test_illegal_move_counted
     # skip
     list_of_inputs = ['player_one', 'player_two', 'e2e4', 'e7d4']
     test_game = Game.new(Board.new, list_of_inputs)
     test_game.play_game
     assert test_game.output_illegal_moves == [2]
   end

  def test_long_game_outcome
    # skip
    list_of_inputs = ['Peter', 'Chris', 'd2e3', 'c2c3', 'f8c5', 'g8h6', 'd2d4', 'd7d5', 'd4d5', 'c3c5', 'a1a7', 'c1h6', 'g7h6', 'd1a4', 'c7c5', 'c7c6', 'e1c1', 'b1a3', 'c6c5', 'd8b6', 'e2e4', 'b6b1', 'b6b2', 'e1c1', 'e4e5', 'b2b3', 'e1c1', 'h2h4', 'b3c3', 'e1c1', 'e1e2', 'f7f5', 'e5d6', 'e5f6', 'b8d7', 'a4a7', 'c3d4', 'e2e1', 'e7e5', 'a7a8', 'd4h4', 'e1c1', 'f1a6', 'd7c5', 'a8b7', 'c8b7', 'g2g3', 'e8c8', 'f8d6', 'f2f3', 'e8g8', 'h1h4', 'g8h8', 'a6b7', 'c5a4', 'f6f7', 'f8e8', 'f7e8', 'Q', 'h8g8', 'h8g7', 'h4f4', 'e5e4', 'f4f6', 'e4e3', 'e8e5', 'g7h8', 'f6f8']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "Congratulations, Peter. That's checkmate! Better luck next time, Chris."
  end

  def test_long_game_illegal_moves
    # this tests a lot of illegal move types in one go!
    # Move 1 is 'd2e3' --- a pawn attempting to capture on an empty square (no en_passent)
    # Move 3 is 'f8c5' --- bishop tries to jump over a pawn
    # Move 7 is 'd4d5' --- pawn tries to capture straight ahead
    # Move 8 is 'c3c5' --- pawn tries to go 2 squares after its first move
    # Move 9 is 'a1a7' --- rook tries to jump over a pawn
    # Move 13 is 'c7c5' --- fails to block check from queen
    # Move 15 is 'e1c1' --- attempt to castle with knight in the way
    # Move 17 is 'c6c5' --- pawn move would discover check on own king from queen
    # Move 20 is 'b6b1' --- queen attempts to jump over pawn
    # Move 22 is 'e1c1' --- attempt to castle into check
    # Move 25 is 'e1c1' --- attempt to castle passing through check
    # Move 28 is 'e1c1' --- attempt to castle from check
    # Move 31 is 'e5d6' --- attempt to en_passent not made immediately after d7-d5,
    # followed by genuine en_passent capture on f6 :-)
    # Move 40 is 'e1c1' --- attempt to castle with king having moved (and returned to start square)
    # Move 46 is 'e8c8' --- attempt to castle with no rook
    # Move 57 is 'h8g8' --- moves king towards checking queen
    # the game ends with discovered double check, so that check is detected not just from
    # the piece that moved.
    # skip
    list_of_inputs = ['Peter', 'Chris', 'd2e3', 'c2c3', 'f8c5', 'g8h6', 'd2d4', 'd7d5', 'd4d5', 'c3c5', 'a1a7', 'c1h6', 'g7h6', 'd1a4', 'c7c5', 'c7c6', 'e1c1', 'b1a3', 'c6c5', 'd8b6', 'e2e4', 'b6b1', 'b6b2', 'e1c1', 'e4e5', 'b2b3', 'e1c1', 'h2h4', 'b3c3', 'e1c1', 'e1e2', 'f7f5', 'e5d6', 'e5f6', 'b8d7', 'a4a7', 'c3d4', 'e2e1', 'e7e5', 'a7a8', 'd4h4', 'e1c1', 'f1a6', 'd7c5', 'a8b7', 'c8b7', 'g2g3', 'e8c8', 'f8d6', 'f2f3', 'e8g8', 'h1h4', 'g8h8', 'a6b7', 'c5a4', 'f6f7', 'f8e8', 'f7e8', 'Q', 'h8g8', 'h8g7', 'h4f4', 'e5e4', 'f4f6', 'e4e3', 'e8e5', 'g7h8', 'f6f8']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.output_illegal_moves == [1, 3, 7, 8, 9, 13, 15, 17, 20, 22, 25, 28, 31, 40, 46, 57]
  end
end
