# frozen-string-literal: true

# DisplayBoard class responsible for showing the board.
# It displays so that the player whose turn it is to move sees their pawns going up
# the board, as though the players are sat across a real-life board.
class DisplayBoard
  require 'colorize'

  attr_accessor :colour

  def initialize
    @colour = 'White'
  end

  EMPTY_STRING = '         '

  def display_board(array)
    array = reverse_array(array) if @colour == 'Black'
    rank = 7
    until rank.negative?
      4.times do |num|
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
    file_letters = *('a'..'h')
    file_letters_to_use = @colour == 'White' ? file_letters : file_letters.reverse
    string = EMPTY_STRING
    file_letters_to_use.each do |letter|
      string += "    #{letter}    "
    end
    string
  end

  def make_a_row(array, rank, num)
    string = num == 2 ? number_string(rank) : EMPTY_STRING
    8.times do |file|
      poss_piece = array[file][rank]
      square_color = (rank + file).odd? ? :white : :light_black
      string += if poss_piece
                  poss_piece.display_strings[num].colorize(background: square_color)
                else
                  EMPTY_STRING.colorize(background: square_color)
                end
    end
    string
  end

  def reverse_array(array)
    array.map(&:reverse).reverse
  end

  def show_the_board(board)
    # self.colour set so that the board can display the correct way for each player.
    self.colour = board.colour_moving
    display_board(board.board_array)
  end
end
