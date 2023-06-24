# frozen-string-literal: true

class Board

include Miscellaneous
  
  attr_accessor :board_array, :castling_rights, :en_passent
  
  def initialize(board_array = NEW_BOARD_ARRAY)
    @board_array = NEW_BOARD_ARRAY
    @castling_rights = { 'White_0-0-0' => true, 'White_0-0' => true, 'Black_0-0-0' => true, 'Black_0-0' => true }
    @colour_moving = 'White'
    @en_passent = {}
    # if there is an en_passent possibility maybe it is denoted by the square on which the
    # pawn can be taken 
  end

NEW_BOARD_ARRAY = [[Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Queen.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Queen.new('Black')], [King.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), King.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')] ]

  def string_to_square(string)
    # accepts a string of the form 'c6' and returns the contents of that square 
    
    board_array.dig(char_to_num(string[0], string[1].to_i - 1))
  end
  
  def get_piece_at(coords)
    get_item(board_array, coords)
  end
  
  
  def pieces_allow_move(start, finish, colour, squares_between)
    return false unless pieces_between_allow_move?(start, finish, squares_between)

    finish_square_ok(finish, colour)
  end
  
  def pieces_between_allow_move?(start, finish, squares_between)
    # This method checks whether any pieces are in the way
    # squares_between is a 2-D array of the squares in between where
    # if a piece were present it would get in the way of the move
    squares_between.each |coords| do
      if get_piece_at(coords)
        # get_item returns piece on the square with coordinates coords, or nil if no piece is there.
        puts piece_in_the_way_error
        return false
      end
    end
    true
  end
      
  def finish_square_ok(finish, colour)
    finish_piece = get_item(board_array, finish)
          
    return 'not_capture' unless finish_piece

    if finish_piece.colour == colour 
        puts capture_own_piece_error
        return false
    end

    return 'capture'
  end

  def piece_in_the_way_error
    "There is a piece in the way of that move. Please try again."
  end

  def capture_own_piece_error
    "You cannot capture your own pieces. Please try again."
  end

  def check_for_check(start, finish, colour, #maybe other optional arguments depending on castling or en passent)
    possible_board_array = change_array(board_array, start, finish)
    # board_array but with the piece at 'start' overwriting whatever was at 'finish' co-ordinates
    checking = CheckForCheck.new(possible_board_array, colour)
    checking.king_in_check?
  end

  def change_array(array, start, finish)
    # array is a current board_array and we are moving a piece from start to finish co-ordinates
    new_array = array.map { |item| item.clone }
    new_array[finish[0]][finish[1]] = array[start[0]start[1]]
    new_array[start[0]][start[1]] = nil
    new_array
  end

end
