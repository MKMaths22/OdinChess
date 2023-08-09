#frozen_string_literal: true

require './game.rb'
require 'minitest/autorun'

class ChessTest < Minitest::Test
  # tests the outcome of a specific Game
  def test_a_quick_checkmate
    list_of_inputs = ['player_one', 'player_two', 'e2e4', 'e7e5', 'd1f3', 'a7a6', 'f1c4', 'h7h6', 'f3f7']
    test_game = Game.new(Board.new, list_of_inputs)
    test_game.play_game
    assert test_game.result.game_end_message == "Congratulations, player_one. That's checkmate! Better luck next time, player_two."
  end
end
