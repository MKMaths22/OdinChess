# frozen-string-literal: true

class Player
  
  attr_accessor :colour, :name
  
  def initialize(colour, name = nil)
    @colour = colour
    @name = name
  end

  def get_move(valid_move, board)
    proposed_move = gets.strip
    output_hash = valid_move.all_valid?(proposed_move, @colour_moving, board)
    output_hash ? output_hash : get_move
    #output_hash is either falsey if move not valid or it is a hash of
    # format { 'start' => start_square, 'finish' => final_square }
    # if is falsey, then get_move is called again recursively
  end



end