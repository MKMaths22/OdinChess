# frozen-string-literal: true

class DisplayBoard

  require 'colorize'

  EMPTY_STRING = '         '

  def display_board(array)
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
    "      #{rank_number + 1}  "
  end

  def final_row
    string = EMPTY_STRING
    ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].each do |letter|
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
  
  def show_the_board(board)
    # method asks the board class for the type and colour of pieces to display
    # need to start with CarryingOutMove class which will have an object created after next_move has been shown to be legal in one_turn (Game class)
    display_board(board.board_array)
  end

end
