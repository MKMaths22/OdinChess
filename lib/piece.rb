# frozen-string-literal: true

require 'colorize'
# Factoring out as much repition as possible
class Piece

  include Miscellaneous

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square

    def initialize(colour)
      @colour = colour
      @movement_vectors = nil
      @base_vectors = nil
      @castling_vectors = []
      @square = nil
    end

    def get_all_legal_moves_from(current_square, board)
      self.square = current_square
      moves_to_check_for_check = []
      
      if base_vectors 
        base_vectors.each do |vector|
          possible_squares = get_possible_squares_in_this_direction(vector, board)
          moves_to_check_for_check.push(make_move_objects(possible_squares))
        end
      end
    end

    def get_possible_squares_in_this_direction(vector, board)
      squares_found = []
      poss_piece = nil
      square_to_try = add_vector(square, vector)
      while square_to_try.on_the_board? && !poss_piece
        poss_piece = board.get_piece_at(square_to_try)
        squares_found.push(square_to_try) unless poss_piece && poss_piece.colour == colour
        square_to_try = add_vector(square_to_try, vector)
      end
      squares_found
    end

    def make_move_objects(possible_squares)

    end

    # Knight class will have movement vectors but no base vectors

    # other classes will use current_square and base_vectors to successively ask the Board if certain squares are clear or have opposition pieces to create moves_to_check_for_check, i.e. the moves 
    # that would be legal if not for check issues

end