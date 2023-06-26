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
    @other_piece = nil
  end

  def legal?
    our_piece = find_our_piece
    return false unless our_piece
    
    other_piece = find_other_piece
    return false if other_piece = 'Error'

    self.vector = get_move_vector
    if @vector == [0, 0]
      puts same_square_error
      return false
    end
    capture = !!other_piece
    # is true if other_piece is an opposition piece, false otherwise.
    # find_other_piece dealt with case of friendly piece in the way.
    answer_from_piece = our_piece.move_like_that(vector, capture)
    # piece object replies 'if_0-0-0', 'if_0-0' 'yes', 'no' or 'if_en_passent'
    # the output from the piece also tells this Move object which squares_between have to be
    # checked for pieces getting in the way


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

  def find_other_piece
    possible_piece = board.get_piece_at(finish_square)
    if possible_piece && possible_piece.colour == colour
      puts capture_own_piece_error
      return 'Error'
    end
    possible_piece
  end

end