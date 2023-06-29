# frozen-string-literal: true

class DisplayBoard

  require 'colorize'

  def show_the_board(board)
    # method asks the board class for the type and colour of pieces to display
    # need to start with CarryingOutMove class which will have an object created after next_move has been shown to be legal in one_turn (Game class)
    edge_string = 
".-------.-------.-------.-------.-------.-------.-------.-------.".colorize(color: :black, background: :white)
""


puts string.colorize(color: :black, background: :white)
  end

end
