# frozen_string_literal: true

class Move

include Miscellaneous

  attr_accessor :string, :colour, :board, :our_piece, :vector, :other_piece, :start_square, :finish_square, :en_passent

  def initialize(string, colour, board)
    @string = string
    @colour = colour
    @board = board
    @vector = nil
    @start_square = find_start_square
    @finish_square = find_finish_square
    @our_piece = nil
    @other_piece = nil
    @en_passent = false
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
    hash_from_piece = our_piece.move_like_that(vector, capture)
    # piece object replies with hash of the form 
    # { 'White_0-0-0' => false, 'White_0-0' => false, 'Black_0-0' => false, 'Black_0-0-0' => false, 'en_passent' => false, 'sub_vectors' => [] }
    squares_to_check = find_squares_to_check(hash_from_piece['sub_vectors'])
    if board.pieces_in_the_way?(squares_to_check)
      puts piece_in_the_way_error
      return false
    
    end
    if hash_from_piece['en_passent']
      self.en_passent = true
      unless board.en_passent_capture_possible_at?(finish_square)
        puts en_passent_error
        return false

      end
    end
    if hash_from_piece['castling']
      # then we ask the board object if the appropriate castling rights exist. We ask the board object to TAKE OVER in checking that the castling move is legal, including check issues.
    end

    return !board.check_for_check(appropriate arguments)
  end

  def find_start_square
    string_to_coords(string[0, 2])
  end

  def find_finish_square
    string_to_coords(string[2, 2])
  end

  def find_squares_to_check(array)
    array.map { |vector| add_vector(vector, start_square) }
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