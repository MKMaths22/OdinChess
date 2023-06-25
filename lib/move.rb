# frozen_string_literal: true

class Move

include Miscellaneous

  attr_accessor :string, :colour, :board, :our_piece, :vector, :other_piece, :start_square, :finish_square

  def initialize(string, colour, board)
    @string = string
    @colour = colour
    @board = board
    @vector = nil
    @start_square = find_start_square
    @finish_square = find_finish_square
    @our_piece = nil
    @other_piece = board.get_piece_at(finish_square)
  end

  def legal?
    our_piece = find_our_piece
    other_piece = find_other_piece
    return false unless our_piece

    self.vector = get_move_vector
    if @vector == [0, 0]
      puts same_square_error
      return false
    end

    answer_from_piece = our_piece.move_like_that(vector)
    # MAY NEED TO ASK PIECE OBJECT A SERIES OF QUESTIONS OR
    # LET THE PIECE OBJECT TALK TO THE BOARD OBJECT AS BEFORE




  end

  def find_start_square
    string_to_coords(string[0, 2])
  end

  def find_finish_square
    string_to_coords(string[2, 2])
  end

  def get_move_vector
    subtract_vector(finish_square, start_square)
  end

  def find_our_piece
    possible_piece = board.get_piece_at(start_square)
    unless possible_piece
      puts no_piece_error(move)
      return nil
    end
    unless possible_piece.colour == colour
      puts wrong_piece_error(move, colour)
      return nil
    end
    possible_piece  
  end

end