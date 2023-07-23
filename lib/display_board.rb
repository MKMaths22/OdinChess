# frozen-string-literal: true

# DisplayBoard class responsible for showing the board.
# It displays so that the player whose turn it is to move sees their pawns going up the board,
# as though the players are sat across a real-life board.
class DisplayBoard

  require 'colorize'

  attr_accessor :colour
  
  def initialize
    @colour = 'White'
  end
  
  EMPTY_STRING = '         '

  FILE_LETTERS = *('a'..'h')

  def display_board(array)
    array = reverse_array(array) if @colour == 'Black'
    rank = 7
    until rank.negative?
      (0..3).each do |num|
        puts make_a_row(array, rank, num)
      end
      rank -= 1
    end
    puts final_row
  end

  def number_string(rank_number)
    "      #{@colour == 'White' ? rank_number + 1 : 8 - rank_number}  "
  end

  def final_row
    file_letters_to_use = @colour == 'White' ? FILE_LETTERS : FILE_LETTERS.reverse
    string = EMPTY_STRING
    file_letters_to_use.each do |letter|
      string += "    #{letter}    "
    end
    string
  end
  
  def make_a_row(array, rank, num)
    string = num == 2 ? number_string(rank) : EMPTY_STRING
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
  
  def reverse_array(array)
    array.map { |rank| rank.reverse }.reverse
  end
  
  def show_the_board(board)
    # method asks the board class for the type and colour of pieces to display
    # need to start with CarryingOutMove class which will have an object created after next_move has been shown to be legal in one_turn (Game class)
    self.colour = board.colour_moving
    display_board(board.board_array)
  end

end
