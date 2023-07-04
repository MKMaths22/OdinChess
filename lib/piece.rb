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
      @moves_to_check_for_check = nil
    end

    def reset_moves_to_check
      moves_to_check_for_check = nil
    end
    
    def get_all_legal_moves_from(current_square, board)
      self.square = current_square
      reset_moves_to_check
      
      base_vectors ? use_the_base_vectors(board) : use_movement_vectors_and_castling(board)
      # this format covers all piece classes except Pawn, which will have
      # its own #get_all_legal_moves_from method
      moves_to_check_for_check.filter { |move| move.legal? }
    end
      
    def use_the_base_vectors(board)
        base_vectors.each do |vector|
          possible_squares = get_possible_squares_in_this_direction(vector, board)
          moves_to_check_for_check = make_move_objects(board, possible_squares)
        end
    end

    def use_movement_vectors_and_castling(board)
        possible_squares = []
        movement_vectors.each do |vector|
          maybe_square = add_vector(square, vector)
          if on_the_board?(maybe_square)
            poss_piece = board.get_piece_at(maybe_square)
            possible_squares.push(maybe_square) unless poss_piece && poss_piece.colour == colour
          end
        end
        moves_to_check_for_check = make_move_objects(board, possible_squares)
        possible_squares = []
        castling_vectors.each do |vector|
          possible_squares.push(add_vector(square, vector)) if board.castling_rights_from_vector?(vector)
        end
        moves_to_check_for_check.push(make_move_objects(board, possible_squares, false, true))
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
      possible_squares.map { |finish| Move.new()}
    end

    # Knight class will have movement vectors but no base vectors

    # other classes will use current_square and base_vectors to successively ask the Board if certain squares are clear or have opposition pieces to create moves_to_check_for_check, i.e. the moves 
    # that would be legal if not for check issues

end