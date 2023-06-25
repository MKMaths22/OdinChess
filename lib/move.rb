# frozen_string_literal: true

class Move

include Miscellaneous

  attr_accessor :string, :colour, :board, :our_piece

  def initialize(string, colour, board)
    @string = string
    @colour = colour
    @board = board
    @our_piece = nil
    @start_square = find_start_square
    @finish_square = find_finish_square
  end

# this #our_piece makes no sense yet! 

  def legal?
    our_piece = find_our_piece
  end

  def find_start_square
    string_to_coords(string[0, 2])
  end

  def find_finish_square
    string_to_coords(string[2, 2])
  end

  def find_our_piece
    possible_piece = board.start_square
    unless possible_piece
      puts no_piece_error(move)
      return false
    end
    unless possible_piece.colour == colour
      puts wrong_piece_error(move, colour)
      return false
    end
    possible_piece  
  end

end