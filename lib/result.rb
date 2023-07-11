# frozen-string-literal: true

class Result
  
  attr_accessor :previous_positions, :half_moves_count

  def initialize(previous_positions, half_moves_count = 0)
    # MAYBE SHOULD INITIALIZE WITH STARTING POSITION IN PREVIOUS_POSITIONS HASH, depends how one_turn loop ends up ordered in Game class,
    # check initial position is not missed
    @previous_positions = previous_positions
    @half_moves_count = half_moves_count
    @game_over = false
  end

  def add_position(position)
    # the positions stored are snapshots of the board object, which capture the current position with
    # whose turn it is to move and any en passent or castling opportunities
    puts "The previous value of the previous_positions hash on key 'position' is #{@previous_positions[position]}"
    self.previous_positions[position] = @previous_positions[position] + 1
    puts "The size of the previous positions is now #{@previous_positions.keys.size}"
    declare_repitition_draw if previous_positions[position] == 3
  end

  def wipe_previous_positions
    # this occurs if a pawn moves or a piece is captured
    puts "previous positions being wiped"
    self.previous_positions = Hash.new(0)
    puts "The size of the previous positions is now #{@previous_positions.keys.size}"
  end

  def increase_moves_count
    self.half_moves_count = @half_moves_count + 1
    puts "half_moves_count = #{@half_moves_count}"
  end

  def reset_moves_count
    self.half_moves_count = 0
    puts "half_moves_count = #{@half_moves_count}"
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
    # colour is the @colour_moving from Game class
    @game_over = true
    puts "Congratulations, #{winning_name}. That's checkmate! Better luck next time, #{losing_name}."
  end

  def declare_stalemate(first_name, second_name)
    @game_over = true
    puts "It's a draw by stalemate! Well played, #{first_name} and #{second_name}."
  end

  def declare_fifty_move_draw(first_name, second_name)
    @game_over = true
    puts "You guys have shuffled your pieces for 50 moves with no real progress, so it's a draw. Well played, #{first_name} and #{second_name}."
  end 

  def declare_repitition_draw(first_name, second_name)
    @game_over = true
    puts "That's the exact same position, for the third time. It's a 3-fold repitition draw. Well played, #{first_name} and #{second_name}."
  end

  def declare_insuff_material_draw(first_name, second_name)
    @game_over = true
    puts "There isn't enough material on the board for a checkmate, so it's a draw by insufficient material. Well played, #{first_name} and #{second_name}."
  end
end