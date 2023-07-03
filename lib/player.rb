# frozen-string-literal: true

class Player
  
include Miscellaneous
  
  attr_reader :colour, :name
  
  def initialize(colour, name = nil)
    @colour = colour
    @name = name
  end

  def set_name(string)
    @name = string
  end

  def get_legal_move(board)
    maybe_move = gets.strip
    unless valid_input?(maybe_move)
      return get_legal_move(board)
    end
    start_square = string_to_coords(maybe_move[0,2])
    finish_square = string_to_coords(maybe_move[2,2])
    move_to_play = Move.new(board, start_square, finish_square)
    boolean = move_to_play.legal? 
    # the move_to_play object should be modified by the #legal? method but this
    # does not seem to be working
    boolean ? move_to_play : get_legal_move(board)
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
end