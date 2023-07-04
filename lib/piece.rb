# frozen-string-literal: true

require 'colorize'
# Factoring out as much repition as possible
class Piece

  include Miscellaneous

  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings 

    def initialize(colour)
      @colour = colour
      @movement_vectors = nil
      @base_vectors = nil
      @castling_vectors = []
      @square = nil
    end

    def get_all_legal_moves_from(current_square)
      self.square = current_square
    end

    # Knight class will have movement vectors but no base vectors

    # other classes will use current_square and base_vectors to successively ask the Board if certain squares are clear or have opposition pieces to create moves_to_check_for_check, i.e. the moves 
    # that would be legal if not for check issues

end