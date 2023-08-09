# frozen-string-literal: true

# Result class takes care of monitoring previous positions (for 3-fold repitition)
# and how many moves with no captures/pawn moves (for 50 move rule).
# It also tells the Game class when it is game over and declares the result to the players.
class Result
  attr_accessor :previous_positions, :half_moves_count, :game_end_message

  def initialize(previous_positions, half_moves_count = 0)
    # Game class uses the initial Board position to put that position into
    # previous_positions when the Result object is created.
    @previous_positions = previous_positions
    @half_moves_count = half_moves_count
    @game_over = false
    @game_end_message = nil
  end

  def add_position(position)
    # the positions stored are snapshots of the Board object, which capture the
    # current position with whose turn it is to move and any en passent chances/castling
    # rights. Although previous_positions hash has default value of zero, this is
    # forgotten when the game is reloaded, so the code below solves that bug
    # by converting a value of nil to zero before adding one.
    self.previous_positions[position] = @previous_positions[position].to_i + 1
  end

  def wipe_previous_positions
    # this occurs if a pawn moves or a piece is captured
    self.previous_positions = Hash.new(0)
  end

  def increase_moves_count
    self.half_moves_count = @half_moves_count + 1
  end

  def reset_moves_count
    self.half_moves_count = 0
  end

  def fifty_move_rule_draw?
    half_moves_count == 100
  end

  def repitition_draw?
    previous_positions.values.max == 3
  end

  def game_over?
    @game_over
  end

  def declare_checkmate(winning_name, losing_name)
    @game_over = true
    self.game_end_message = "Congratulations, #{winning_name}. That's checkmate! Better luck next time, #{losing_name}."
    puts @game_end_message
  end

  def declare_stalemate(first_name, second_name)
    @game_over = true
    self.game_end_message = "It's a draw by stalemate! Well played, #{first_name} and #{second_name}."
    puts @game_end_message
  end

  def declare_fifty_move_draw(first_name, second_name)
    @game_over = true
    self.game_end_message = "You guys have shuffled your pieces for 50 moves with no real progress, so it's a draw. Well played, #{first_name} and #{second_name}."
    puts @game_end_message
  end

  def declare_repitition_draw(first_name, second_name)
    @game_over = true
    self.game_end_message = "That's the exact same position, for the third time. It's a 3-fold repitition draw. Well played, #{first_name} and #{second_name}."
    puts @game_end_message
  end

  def declare_insuff_material_draw(first_name, second_name)
    @game_over = true
    self.game_end_message = "There isn't enough material on the board for a checkmate, so it's a draw by insufficient material. Well played, #{first_name} and #{second_name}."
    puts @game_end_message
  end

  def declare_resignation(losing_name, winning_name)
    @game_over = true
    self.game_end_message = "#{winning_name} wins, congratulations! Better luck next time, #{losing_name}."
    puts @game_end_message
  end
end
