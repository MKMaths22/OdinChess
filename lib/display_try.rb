require 'colorize'

class Piece
  
  attr_accessor :colour, :basic_display_strings, :display_strings
  
  def initialize(colour)
    @colour = colour
  end

  def apply_colour(array_of_strings)
    colour_to_use = (colour == 'White' ? :light_white : :black)
    array_of_strings.map { |string| string.colorize(color: colour_to_use) } 
  end
end

class Pawn < Piece
  def initialize(colour)
    @colour = colour
    @basic_display_strings = ['         ', '    o    ', '   ( )   ', '   |_|   ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

class Queen < Piece
  def initialize(colour)
    @colour = colour
    @basic_display_strings = ['  ooooo  ', '   \ /   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

class Rook < Piece
  def initialize(colour)
    @colour = colour
    @basic_display_strings = ['  n_n_n  ', '  \   /  ', '  |   |  ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

class King < Piece
  def initialize(colour)
    @colour = colour
    @basic_display_strings = ['    +    ', '   \ /   ', '   ( )   ', '   /_\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

class Knight < Piece
  def initialize(colour)
    @colour = colour
    @basic_display_strings = ['    __,  ', '  /  o\  ', '  \  \_> ', '  /__\   ']
    @display_strings = apply_colour(@basic_display_strings)
  end
end

class Bishop < Piece
  def initialize(colour)
    @colour = colour
    @basic_display_strings = ['    o    ', '   ( )   ', '   / \   ', '  /___\  ']
    @display_strings = apply_colour(@basic_display_strings)
  end

end

NEW_BOARD_ARRAY = [[Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Queen.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Queen.new('Black')], [King.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), King.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')] ]

EMPTY_STRING = '         '

# each piece has its own display_strings array which is colorized either black or white. To display this board, we need to scroll along each row of the board, detecting pieces as we go and choosing the appropriate display_strings item. We have to get the background_colour right using parity of coordinates. 

def display_board(array)
  rank = 7
  until rank.negative?
    (0..3).each do |num|
      puts make_a_row(array, rank, num)
    end
    rank -= 1
  end
end

def make_a_row(array, rank, num)
  string = ''
  (0..7).each do |file|
    poss_piece = array[file][rank]
    square_color = (rank + file).odd? ? :white : :light_black
    if poss_piece
      string += poss_piece.display_strings[num].colorize(background: square_color)
    else
      string += EMPTY_STRING.colorize(background: square_color)
    end
  end
  string
end

# rook_strings = ['   n_n_n   ', '   \    /   ', '   |   |   ', '   /   \   ', '    ___    ']
# rook_strings.map! { |string| string.colorize(color: :black, background: :white) }

# display_empty_board
# small_edge_string = 
# ".-----------"
# edge_string = (small_edge_string*8 + ".").colorize(color: :black)
# puts edge_string.colorize(background: :light_black)
# puts edge_string.colorize(background: :white)

display_board(NEW_BOARD_ARRAY)
