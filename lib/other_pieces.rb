# frozen-string-literal: true

require 'colorize'

# includes the instance variables specific for Bishops
class Bishop < Piece
  include Miscellaneous

  def initialize(colour)
    super
    @base_vectors = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    @basic_display_strings = ['    o    ', '   ( )   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

# includes the Rook's instance variables and deals with removal of castling rights
# on one side when a Rook moves
class Rook < Piece
  include Miscellaneous

  def initialize(colour)
    super
    @base_vectors = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    @basic_display_strings = ['  n_n_n  ', '  \   /  ', '  |   |  ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end

  def update_castling(board, start_square)
    # if a rook moves from its starting square, castling rights are lost
    back_rank = board.colour_moving == 'White' ? 0 : 7
    board.remove_castling_rights('0-0-0') if start_square == [0, back_rank]
    board.remove_castling_rights('0-0') if start_square == [7, back_rank]
  end
end

# includes the Queen's instance variables
class Queen < Piece
  include Miscellaneous

  def initialize(colour)
    super
    @base_vectors = [[-1, 0], [0, 1], [1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @basic_display_strings = ['  ooooo  ', '   \ /   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

# includes the Knight's instance variables
class Knight < Piece
  include Miscellaneous

  def initialize(colour)
    super
    @movement_vectors = [[-1, -2], [-1, 2], [1, -2], [1, 2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    @basic_display_strings = ['    __,  ', '  /  o\  ', '  \  \_> ', '  /__\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

# includes the King's instance variables and removal of castling when he moves
class King < Piece
  include Miscellaneous

  def initialize(colour)
    super
    @movement_vectors = [[-1, 0], [0, 1], [1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @castling_vectors = [[2, 0], [-2, 0]]
    @basic_display_strings = ['    +    ', '   \ /   ', '   ( )   ', '   /_\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end

  def update_castling(board, _start_square)
    board.remove_castling_rights('0-0-0')
    board.remove_castling_rights('0-0')
  end
end
