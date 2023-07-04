# frozen-string-literal: true

class Board

  require './miscellaneous.rb'
  require './piece.rb'

  include Miscellaneous
  
  attr_accessor :board_array, :castling_rights, :colour_moving, :en_passent
  
  def initialize(board_array = NEW_BOARD_ARRAY)
    @board_array = NEW_BOARD_ARRAY
    @castling_rights = { 'White_0-0-0' => true, 'White_0-0' => true, 'Black_0-0-0' => true, 'Black_0-0' => true }
    @colour_moving = 'White'
    @en_passent = { 'Pawn passed through' => nil, 'Pawn now at' => nil }
  end

  NEW_BOARD_ARRAY = [[Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Queen.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Queen.new('Black')], [King.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), King.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')] ]
  
  def toggle_colour_moving
    self.colour_moving = other_colour(colour_moving)
  end

  def castling_rights?(string)
    castling_rights[string]
  end

  def remove_castling_rights(side)
    # side is '0-0' or '0-0-0'
    castling_rights["#{colour_moving}_#{side}"] = false
  end

  def add_en_passent_chance(finish_square)
    file = finish_square[0]
    capture_rank = finish_square[1] == 3 ? 2 : 5
    self.en_passent = { 'Pawn passed through' => [file, capture_rank], 'Pawn now at' => finish_square }
  end

  def reset_en_passent
    self.en_passent = { 'Pawn passed through' => nil, 'Pawn now at' => nil }
  end

  def update_array(poss_board_array)
    self.board_array = poss_board_array
  end

  def replace_pawn_with(new_piece, square)
    self.board_array[square[0]][square[1]] = new_piece
  end

  def string_to_square(string)
    # accepts a string of the form 'c6' and returns the contents of that square 
    get_piece_at(string_to_coords(string))
  end
  
  def get_piece_at(coords)
    get_item(board_array, coords)
  end
  
  def en_passent_capture_possible_at?(coords)
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
    # squares_to_check = find_squares_to_check(colour, vector)
    # return false unless pieces_between_allow_move?(squares_to_check)

    # reduced_vector = vector[0].negative? ? [-1, 0] : [1, 0]

    # NEED TO MAKE THREE possible_board_array values to check in all three that 
    # the king is not in check.
    !check_castling_for_check?(colour, start, vector, reduced_vector)
  end
  
  def pieces_in_the_way?(squares_between)
    # This method checks whether any pieces are in the way
    # squares_between is a 2-D array of the squares in between where
    # if a piece were present it would get in the way of the move
    squares_between.each do |coords|
      return true if get_piece_at(coords)
        # get_piece_at returns piece on the square with coordinates coords, or nil if no piece is there.
    end
    false
  end

  def next_square_with_piece_to_move(square)
    # scrolls through the board_array for the next square with a piece of the colour 'colour_moving'
    # outputs nil if no such piece found
    return nil if square == [7, 7]

    next_one = next_square(square)
    poss_piece = get_piece_at(next_one)
    return { 'square' => next_one, 'piece' => poss_piece } if poss_piece && poss_piece.colour == colour_moving

    next_square_with_piece_to_move(next_one)
  end

  def next_square(coords)
    return [coords[0], coords[1] + 1] unless coords[1] == 7
    return [coords[0] + 1, 0] unless coords[0] == 7
    nil
  end

  def would_move_leave_us_in_check?(possible_board_array)
    checking = CheckForCheck.new(possible_board_array, colour_moving)
    !!checking.king_in_check?
    # king_in_check? is to be a partly Boolean method, returning a hash of details if true
    # or just returning false
  end

  def would_castling_be_illegal_due_to_check?(colour, start, vector, reduced_vector)
    check_first = CheckForCheck.new(board_array, colour_moving, castle_from_check_error)
    return true if check_first.king_in_check?
    
    middle_square = add_vector(start, reduced_vector)
    middle_of_castling = make_new_array(start, middle_square)
    check_middle = CheckForCheck.new(middle_of_castling, colour_moving, castle_through_check_error)
    return true if check_middle.king_in_check?
    
    finish_square = add_vector(start, vector)
    finish_of_castling = make_new_array(start, finish_square)
    check_finish = CheckForCheck.new(finish_of_castling, colour_moving)
    return !!check_finish.king_in_check?
    # king_in_check? is to be a partly Boolean method, returning a hash of details if true
    # or just returning false
  end

  def make_new_array(start, finish, e_p = false)
    # array is a current board_array and we are moving a piece from start to finish co-ordinates
    new_array = board_array.map { |item| item.clone }
    new_array[finish[0]][finish[1]] = board_array[start[0]][start[1]]
    new_array[start[0]][start[1]] = nil
    new_array[en_passent['Pawn now at'][0]][en_passent['Pawn now at'][1]] = nil if e_p
    # if it is en_passent we also remove the pawn captured
    new_array
  end

  def make_new_array_for_castling(king_start, king_finish, rook_start, rook_finish)
    new_array = board_array.map { |item| item.clone }
    new_array[king_finish[0]][king_finish[1]] = board_array[king_start[0]][king_start[1]]
    new_array[king_start[0]][king_start[1]] = nil
    new_array[rook_finish[0]][rook_finish[1]] = board_array[rook_start[0]][rook_start[1]]
    new_array[rook_start[0]][rook_start[1]] = nil
    new_array
  end

end
