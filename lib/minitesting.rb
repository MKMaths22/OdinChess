#frozen_string_literal: true

require './game.rb'
require 'minitest/autorun'

class ChessTest < Minitest::Test
  # tests the outcome of a specific Game
  def test_a_quick_white_win
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'e7e5', 'd1f3', 'a7a6', 'f1c4', 'h7h6', 'f3f7']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "Congratulations, player_one. That's checkmate! Better luck next time, player_two."
  end

  def test_a_quick_black_win
    list_of_inputs = ['player_one', 'player_two', 'f2f3', 'e7e5', 'g2g4', 'd8h4']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "Congratulations, player_two. That's checkmate! Better luck next time, player_one."
  end

  def test_white_resignation
    list_of_inputs = ['player_one', 'player_two', 'resign']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "player_two wins, congratulations! Better luck next time, player_one."
  end

  def test_black_resignation
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'resign']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "player_one wins, congratulations! Better luck next time, player_two."
  end

  def test_three_fold_repitition_at_start
    list_of_inputs = ['player_one', 'player_two', 'g1f3', 'g8f6', 'f3g1', 'f6g8', 'g1f3', 'g8f6', 'f3g1', 'f6g8']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "That's the exact same position, for the third time. It's a 3-fold repitition draw. Well played, player_two and player_one."
  end

  def test_three_fold_repitition_later
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'e7e5', 'g1f3', 'g8f6', 'f3g1', 'f6g8', 'g1f3', 'g8f6', 'f3g1', 'f6g8']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "That's the exact same position, for the third time. It's a 3-fold repitition draw. Well played, player_two and player_one."
  end





end
