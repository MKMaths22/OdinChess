# frozen-string-literal: true

class Player
  
  attr_accessor :colour, :name
  
  def initialize(colour, name = nil)
    @colour = colour
    @name = name
  end

  def get_move(board)
    maybe_move = gets.strip
    move_to_play = all_valid?(maybe_move, @colour_moving, board)
    move_to_play ? move_to_play : get_move
    # move_to_play is either falsey if move not valid or it is a Move object
  end

  def valid_input?(string)
    string = string.downcase
    ok_letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ok_numbers = ['1', '2', '3', '4', '5', '6', '7', '8']
    valid = true
    valid = false unless ok_letters.include?(string[0]) && ok_letters.include?(string[2])
    valid = false unless ok_numbers.include?(string[1]) && ok_numbers.include?(string[3])
    puts input_error(string) unless valid
    valid
  end

  def input_error(string)
    "#{string} is not acceptable input. Please type the algebraic notation for starting square and finishing square such as 'g1f3'. Castling is a King move."
  end

  def all_valid?(maybe_move, colour, board)
    # maybe_move is the raw input from the player
    return false unless valid_input?(maybe_move)

    this_move = Move.new(maybe_move, colour, board)
    return this_move.legal?
  end
    
   # return false unless moving_piece.move_legal?(board, start_square, final_square)
    
    # The class of the piece takes care of the remaining tests because
    # type of piece dictates if move is possible and board class lets us
    # know if pieces in the way, Castling, En Passent possibilities 

    # return { 'start' => start_square, 'finish' => final_square }
  # end
end