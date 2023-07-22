# frozen-string-literal: true

require 'colorize'
# Factoring out as much repitition as possible
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
    
    def reset_moves_to_check
      self.moves_to_check_for_check = []
    end

    def validate_square_for_moving(board, square)
      # asks if the Piece can move to the square 'square' on the 'board'. 
      # Also tests whether the square is on the chessboard.
      # returns either false, 'capture' or 'non-capture'
      return false unless on_the_board?(square)
      
      poss_piece = board.get_piece_at(square)
      return 'non-capture' unless poss_piece
      
      poss_piece.colour == colour ? false : 'capture'
    end

    def capture_possible?(start_square, finish_square, board)
      # the piece in question is on 'start_square' in a Board object, 'board' and we want to know if it can 
      # capture the piece (actually the King) on the 'finish_square'
      # this method ASSUMES that the piece is on the finish_square
      if base_vectors
        base_vectors.each do |vector|
          square_to_try = add_vector(start_square, vector)
          while validate_square_for_moving(board, square_to_try) == 'non-capture'
            square_to_try = add_vector(square_to_try, vector)
          end
          return true if square_to_try == finish_square
        end
        false
      else
      # use movement vectors if there are no base vectors
      movement_vectors.map { |vector| add_vector(start_square, vector) }.include?(finish_square)
      end
    end
    
    def get_all_legal_moves_from(current_square, board)
      # puts "get_all_legal_moves_from is executing on a piece of type #{self.class.to_s}"
      # puts "Before updating the square this piece of type #{self.class.to_s} has @square #{@square}."
      self.square = current_square
      reset_moves_to_check
      # puts "After updating the square this piece of type #{self.class.to_s} has @square #{@square}."
      # puts "Also, on this piece of class #{self.class.to_s} moves_to_check has reset. The size of it is #{@moves_to_check_for_check.size}."
      
      base_vectors ? moves_from_base_vectors(board) : moves_from_movement_vectors_and_castling(board)
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
      
    def moves_from_base_vectors(board)
      # puts "use_the_base_vectors is executing on a piece of type #{self.class.to_s}"
      possible_squares = []
      base_vectors.each do |vector|
        # puts "base vector = #{vector}"
        possible_squares = possible_squares.concat(get_possible_squares_in_this_direction(vector, board))
        # puts "There are #{possible_squares.size} possible squares so far."
      end 
      self.moves_to_check_for_check = make_move_objects(board, possible_squares)
    end

    def moves_from_movement_vectors_and_castling(board)
      possible_squares = movement_vectors.map { |vector| add_vector(square, vector) }.filter{ |poss_square| validate_square_for_moving(board, poss_square) }
      self.moves_to_check_for_check = make_move_objects(board, possible_squares)

      possible_castling_vectors = castling_vectors.filter { |vector| board.castling_rights_from_vector?(vector) && !board.pieces_in_the_way?(find_squares_to_check(colour, vector)) }
      
      possible_squares = possible_castling_vectors.map { |vector| add_vector(square, vector) }
      moves_to_check_for_check.concat(make_move_objects(board, possible_squares, false, true))
    end

    def get_possible_squares_in_this_direction(vector, board)
      squares_found = []
      square_to_try = add_vector(square, vector)
      while validate_square_for_moving(board, square_to_try) == 'non-capture'
        squares_found.push(square_to_try)
        square_to_try = add_vector(square_to_try, vector)
      end
      squares_found.push(square_to_try) if validate_square_for_moving(board, square_to_try) == 'capture'
      squares_found
    end

    def make_move_objects(board, possible_squares, en_passent = false, castling = false)
      possible_squares.map { |finish| Move.new(board, square, finish, en_passent, castling) }
    end
end