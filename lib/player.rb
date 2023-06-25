# frozen-string-literal: true

class Player
  
  attr_accessor :colour, :name
  
  def initialize(colour, name = nil)
    @colour = colour
    @name = name
  end

  def get_move(valid_move, board)
    proposed_move = gets.strip
    move_to_play = valid_move.all_valid?(proposed_move, @colour_moving, board)
    move_to_play ? move_to_play : get_move
    # move_to_play is either falsey if move not valid or it is a Move object
  end



end