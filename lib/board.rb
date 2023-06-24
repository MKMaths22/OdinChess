# frozen-string-literal: true

class Board

include Miscellaneous
  
  attr_accessor :board_array, :castling_rights, :en_passent
  
  def initialize(board_array = NEW_BOARD_ARRAY)
    @board_array = NEW_BOARD_ARRAY
    @castling_rights = { 'White_0-0-0' => true, 'White_0-0' => true, 'Black_0-0-0' => true, 'Black_0-0' => true }
    @colour_moving = 'White'
    @en_passent = { 'Pawn passed through' => nil, 'Pawn now at' => nil }
    # if there is an en_passent possibility maybe it is denoted by the coordinates of the square on which the
    # pawn can be taken 
  end

NEW_BOARD_ARRAY = [[Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Queen.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Queen.new('Black')], [King.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), King.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')] ]

  def string_to_square(string)
    # accepts a string of the form 'c6' and returns the contents of that square 
    get_piece_at(string_to_coords(string))
  end
  
  def get_piece_at(coords)
    get_item(board_array, coords)
  end
  
  def en_passent?(coords)
    en_passent['Pawn passed through'] == coords
  end

  def castling_legal?(colour, start, vector)
    # colour is the colour of the King trying to castle, which may not even be in its starting position and vector is [2, 0] or [-2, 0] Start is the King's initial square
    query_string = colour + '_0-0'
    query_string += '-0' if vector[0].negative?
    # query_string is now the appropriate key for the castling_rights hash
    unless castling_rights[query_string]
      puts no_castling_error(query_string)
      return false
    end
    squares_to_check = find_squares_to_check(colour, vector)
    return false unless pieces_between_allow_move?(squares_to_check)

    reduced_vector = vector[0].negative? ? [-1, 0] : [1, 0]

    # NEED TO MAKE THREE possible_board_array values to check in all three that 
    # the king is not in check.


  end

  def pieces_allow_move(start, finish, colour, squares_between)
    return false unless pieces_between_allow_move?(squares_between)

    finish_square_ok(finish, colour)
  end
  
  def pieces_between_allow_move?(squares_between)
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

  def check_for_check(start, finish, colour, e_p = false, castle = false)
    possible_board_array = change_array(board_array, start, finish, e_p, castle)
    # board_array but with the piece at 'start' overwriting whatever was at 'finish' co-ordinates
    checking = CheckForCheck.new(possible_board_array, colour)
    checking.king_in_check?
  end

  def change_array(array, start, finish, e_p = false)
    # array is a current board_array and we are moving a piece from start to finish co-ordinates
    new_array = array.map { |item| item.clone }
    new_array[finish[0]][finish[1]] = array[start[0]][start[1]]
    new_array[start[0]][start[1]] = nil
    new_array[en_passent['Pawn now at'][0]][en_passent['Pawn now at'][1]] = nil if e_p
    # if it is en_passent we also remove the pawn captured
    new_array
  end

end
