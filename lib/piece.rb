# frozen-string-literal: true

require 'colorize'
# Factoring out as much repition as possible
class Piece

  include Miscellaneous

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check

    def initialize(colour)
      @colour = colour
      @movement_vectors = nil
      @base_vectors = nil
      @castling_vectors = []
      @square = nil
      @moves_to_check_for_check = []
    end

    def apply_colour(array_of_strings)
      colour_to_use = (colour == 'White' ? :light_white : :black)
      array_of_strings.map { |string| string.colorize(color: colour_to_use) } 
    end

    def simplify
      "#{colour}#{self.class.to_s}"
      # for use when the board object is being stored in the Result object's @positions for 3-fold repetition
    end
    
    def reset_moves_to_check
      self.moves_to_check_for_check = []
    end
    
    def get_all_legal_moves_from(current_square, board)
      # puts "get_all_legal_moves_from is executing on a piece of type #{self.class.to_s}"
      # puts "Before updating the square this piece of type #{self.class.to_s} has @square #{@square}."
      self.square = current_square
      reset_moves_to_check
      # puts "After updating the square this piece of type #{self.class.to_s} has @square #{@square}."
      # puts "Also, on this piece of class #{self.class.to_s} moves_to_check has reset. The size of it is #{@moves_to_check_for_check.size}."
      
      base_vectors ? use_the_base_vectors(board) : use_movement_vectors_and_castling(board)
      # this format covers all piece classes except Pawn, which will have
      # its own #get_all_legal_moves_from method
      moves_to_check_for_check.each_with_index do |move, index|
        # puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}." if move.class.to_s == 'Move'
        # puts "The move has class #{move.class.to_s}"
      end
      output = moves_to_check_for_check.filter { |move| move.legal? }
      self.square = nil
      reset_moves_to_check
      output
    end
      
    def use_the_base_vectors(board)
      # puts "use_the_base_vectors is executing on a piece of type #{self.class.to_s}"
      possible_squares = []
      base_vectors.each do |vector|
        # puts "base vector = #{vector}"
        possible_squares = possible_squares.concat(get_possible_squares_in_this_direction(vector, board))
        # puts "There are #{possible_squares.size} possible squares so far."
      end 
      self.moves_to_check_for_check = make_move_objects(board, possible_squares)
    end

    def use_movement_vectors_and_castling(board)
      # puts "use_movement_vectors_and_castling is executing on a piece of type #{self.class.to_s}"
        possible_squares = []
        movement_vectors.each do |vector|
          maybe_square = add_vector(square, vector)
          if on_the_board?(maybe_square)
            poss_piece = board.get_piece_at(maybe_square)
            possible_squares.push(maybe_square) unless poss_piece && poss_piece.colour == colour
          end
        end
      self.moves_to_check_for_check = make_move_objects(board, possible_squares)
      possible_squares = []
      castling_vectors.each do |vector|
        possible_squares.push(add_vector(square, vector)) if board.castling_rights_from_vector?(vector) && !board.pieces_in_the_way?(find_squares_to_check(colour, vector))
      end
      moves_to_check_for_check.concat(make_move_objects(board, possible_squares, false, true))
    end

    def get_possible_squares_in_this_direction(vector, board)
      squares_found = []
      poss_piece = nil
      square_to_try = add_vector(square, vector)
      while on_the_board?(square_to_try) && !poss_piece
        poss_piece = board.get_piece_at(square_to_try)
        squares_found.push(square_to_try) unless poss_piece && poss_piece.colour == colour
        square_to_try = add_vector(square_to_try, vector)
      end
      squares_found
    end

    def make_move_objects(board, possible_squares, en_passent = false, castling = false)
      possible_squares.map { |finish| Move.new(board, square, finish, en_passent, castling) }
    end

    # Knight class will have movement vectors but no base vectors

    # other classes will use current_square and base_vectors to successively ask the Board if certain squares are clear or have opposition pieces to create moves_to_check_for_check, i.e. the moves 
    # that would be legal if not for check issues

end

class Pawn < Piece
  
  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check, :capture_vectors, :non_capture_vectors, :moved

  def initialize(colour)
    @colour = colour
    @capture_vectors = get_captures
    @non_capture_vectors = get_non_captures
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['         ', '    o    ', '   / \   ', '   |_|   ']
    @display_strings = apply_colour(@basic_display_strings)
    @moved = false
  end

  def update_moved_variable
    # puts "update_moved_variable has started running"
    self.moved = true
    puts "moved variable is now #{@moved}"
    self.non_capture_vectors = [@non_capture_vectors[0]]
    # p "Non_capture_vectors are #{@non_capture_vectors}"
    # puts "The pawn now has #{@non_capture_vectors.size} non_capture vectors"
  end

  def moved?
    @moved
  end

  def get_captures
    colour == 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
  end

  def get_non_captures
    colour == 'White' ? [[0, 1], [0, 2]] : [[0, -1], [0, -2]]
    # rest of code can use the fact that the FIRST non_capture vector
    # has to be playable onto an empty square to consider the SECOND one,
    # if the second one exists.
  end

  def get_all_legal_moves_from(current_square, board)
    
    # puts "Before updating the square this piece of type #{self.class.to_s} has @square #{@square}."
    self.square = current_square
    reset_moves_to_check
    # puts "After updating the square this piece of type #{self.class.to_s} has @square #{@square}."
    # puts "Also, moves_to_check has reset. The size of it is #{@moves_to_check_for_check.size}."
  
    capture_vectors.each do |vector|
      capture_at = add_vector(current_square, vector)
      if on_the_board?(capture_at)
        poss_piece = board.get_piece_at(capture_at)
        if poss_piece && poss_piece.colour != colour
          moves_to_check_for_check.push(Move.new(board, square, capture_at))
        end
        moves_to_check_for_check.push(Move.new(board, square, capture_at, true, false)) if board.en_passent_capture_possible_at?(capture_at)
      end
    # no need to check for no piece on the en_passent capturing square, 
    # because an opponent's pawn just passed through that square
    end

    first_non_capture_square = add_vector(current_square, non_capture_vectors[0])
    if on_the_board?(first_non_capture_square)
      poss_piece = board.get_piece_at(first_non_capture_square)
      unless poss_piece
        moves_to_check_for_check.push(Move.new(board, square, first_non_capture_square))
        if non_capture_vectors[1]
          other_square = add_vector(current_square, non_capture_vectors[1])
          other_poss_piece = board.get_piece_at(other_square)
          moves_to_check_for_check.push(Move.new(board, square, other_square)) unless other_poss_piece
        end
      end
    end
    output = moves_to_check_for_check.filter { |move| move.legal? }
    # pawn promotion is dealt with in ChangeTheBoard but we don't
    # need to know the piece the pawn promotes to in order to check
    # whether the move is legal
    self.square = nil
    reset_moves_to_check
    output
  end

end

class Bishop < Piece

include Miscellaneous

attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check

  def initialize(colour)
    @colour = colour
    @movement_vectors = nil
    @base_vectors = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['    o    ', '   ( )   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end

end

class Rook < Piece

  include Miscellaneous
  
  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check
  
  def initialize(colour)
    @colour = colour
    @movement_vectors = nil
    @base_vectors = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['  n_n_n  ', '  \   /  ', '  |   |  ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end
  
end

class Queen < Piece

  include Miscellaneous
  
  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check
  
  def initialize(colour)
    @colour = colour
    @movement_vectors = nil
    @base_vectors = [[-1, 0], [0, 1], [1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['  ooooo  ', '   \ /   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end
  
end

class Knight < Piece

  include Miscellaneous
  
  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check
  
  def initialize(colour)
    @colour = colour
    @movement_vectors = KNIGHT_VECTORS
    # KNIGHT_VECTORS are listed in Miscellaneous
    @base_vectors = nil
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['    __,  ', '  /  o\  ', '  \  \_> ', '  /__\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end
  
end

class King < Piece

  include Miscellaneous
  
  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check
  
  def initialize(colour)
    @colour = colour
    @movement_vectors = [[-1, 0], [0, 1], [1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @base_vectors = nil
    @castling_vectors = [[2, 0], [-2, 0]]
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['    +    ', '   \ /   ', '   ( )   ', '   /_\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end

end

