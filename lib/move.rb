# frozen_string_literal: true

class Move

include Miscellaneous

  attr_accessor :string, :colour, :board, :our_piece, :vector, :other_piece, :start_square, :finish_square, :en_passent, :castling

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
    @castling = false
  end

  def legal?
    our_piece = find_our_piece
    return false unless our_piece
    
    other_piece = find_other_piece
    return false if other_piece == 'Error'

    self.vector = get_move_vector
    if @vector == [0, 0]
      puts same_square_error
      return false

    end
    capture = !!other_piece
    # is true if other_piece is an opposition piece, false otherwise.
    # find_other_piece dealt with case of friendly piece in the way.
    hash_from_piece = our_piece.move_like_that(vector, capture)
    return false unless hash_from_piece
    # if hash_from_piece not truthy, the appropriate Piece sub-class
    # has already issued an error message explaining why move
    # is not legal
    # piece object replies with hash of the form 
    # { 'castling' => descriptive string or false 'en_passent' => true/false, 'sub_vectors' => [] }
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
      string = hash_from_piece['castling']
      self.castling = string
      unless board.castling_rights?(string)
        puts no_castling_error(string)
        return false

      end
      reduced_vector = get_reduced_vector(vector)
      # reduced_vector is the vector the king travels to the square in the middle of the castling move e.g. from e1 to f1.
      return !board.would_castling_be_illegal_due_to_check?(colour, start_square, vector, reduced_vector)
    end

    return !board.would_move_leave_us_in_check?(start_square, finish_square, colour, en_passent)
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
      puts no_piece_error
      return nil
    end
    unless possible_piece.colour == colour
      puts wrong_piece_error(colour)
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