# frozen-string-literal: true

# Board class: Board initialized with the starting position (using dependency injection) @position is
# a 2-D array 8 x 8 with nil for empty squares and Piece objects otherwise.
# Castling rights/en Passent possibilities are accounted for & whose turn it is.
class Board
  require_relative './miscellaneous'
  require_relative './piece'

  include Miscellaneous

  attr_accessor :board_array, :castling_rights, :colour_moving, :en_passent

  def initialize(
    board_array = [[Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Queen.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Queen.new('Black')], [King.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), King.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')]], colour_moving = 'White', castling_rights = { 'White_0-0-0' => true, 'White_0-0' => true, 'Black_0-0-0' => true, 'Black_0-0' => true }, en_passent = { 'Pawn passed through' => nil, 'Pawn now at' => nil })
    @board_array = board_array
    @colour_moving = colour_moving
    @castling_rights = castling_rights
    @en_passent = en_passent
  end

  def toggle_colours
    # The Game class calls this method as well as toggling its own colours.
    self.colour_moving = other_colour(colour_moving)
  end

  def castling_rights_from_vector?(vector)
    # throughout this project, vector is the movement vector of a piece, in this case a King when castling.
    castling_rights[castling_string_from_vector(vector, colour_moving)]
  end

  def remove_castling_rights(side, opponent = false)
    # side is '0-0' or '0-0-0'
    colour = (opponent ? other_colour(colour_moving) : colour_moving)
    castling_rights["#{colour}_#{side}"] = false
  end

  def add_en_passent_chance(finish_square)
    file = finish_square[0]
    capture_rank = finish_square[1] == 3 ? 2 : 5
    self.en_passent = { 'Pawn passed through' => [file, capture_rank], 'Pawn now at' => finish_square }
  end

  def reset_en_passent
    self.en_passent = { 'Pawn passed through' => nil, 'Pawn now at' => nil }
  end

  def any_en_passent_in_theory?
    @en_passent['Pawn passed through'] ? true : false
  end

  def update_array(poss_board_array)
    self.board_array = poss_board_array
  end

  def replace_pawn_with(new_piece, square)
    board_array[square[0]][square[1]] = new_piece
  end

  def put_piece_at(array, coords, piece)
    array[coords[0]][coords[1]] = piece
  end
  
  def get_piece_at(coords)
    get_item(board_array, coords)
  end

  def get_item(array, coords)
    array[coords[0]][coords[1]]
  end

  def en_passent_capture_possible_at?(coords)
    # only takes into account whether a pawn has just passed through the square
    # with coordinates 'coords', not whether an opposition pawn can execute the en_passent
    en_passent['Pawn passed through'] == coords
  end

  def pieces_in_the_way?(squares_between)
    squares_between.any? { |coords| get_piece_at(coords) }
  end

  def next_square_with_piece_to_move(square)
    # scrolls through the board_array for the next square with a piece of
    # the colour 'colour_moving', outputs nil if no such piece found.
    return nil if square == [7, 7]

    next_one = next_square(square)
    poss_piece = get_piece_at(next_one)
    return { 'square' => next_one, 'piece' => poss_piece } if poss_piece && poss_piece.colour == colour_moving

    next_square_with_piece_to_move(next_one)
  end

  def would_move_leave_us_in_check?(possible_board_array)
    checking = CheckForCheck.new(possible_board_array, colour_moving)
    checking.king_in_check?
  end

  def would_castling_be_illegal_due_to_check?(start, vector, reduced_vector)
    check_first = CheckForCheck.new(board_array, colour_moving)
    return true if check_first.king_in_check?

    middle_square = add_vector(start, reduced_vector)
    middle_of_castling = make_new_array(start, middle_square)
    check_middle = CheckForCheck.new(middle_of_castling, colour_moving)
    return true if check_middle.king_in_check?

    finish_square = add_vector(start, vector)
    finish_of_castling = make_new_array(start, finish_square)
    check_finish = CheckForCheck.new(finish_of_castling, colour_moving)
    check_finish.king_in_check?
  end

  def make_new_array(start, finish, e_p = false)
    # array is a current board_array and we are moving a piece from start to finish co-ordinates.
    new_array = board_array.map(&:clone)
    move_piece(new_array, start, finish)
    put_piece_at(new_array, en_passent['Pawn now at'], nil) if e_p
    # if it is en_passent we also remove the pawn captured
    new_array
  end

  def make_new_array_for_castling(king_start, king_finish, rook_start, rook_finish)
    new_array = board_array.map(&:clone)
    move_piece(new_array, king_start, king_finish)
    move_piece(new_array, rook_start, rook_finish)
    new_array
  end

  def move_piece(array, start, finish)
    put_piece_at(array, finish, get_piece_at(start))
    put_piece_at(array, start, nil)
  end

  def store_position
    # uses YAML to serialize the Board object in its current state.
    to_yaml
  end

  def insuff_material_draw?
    # at most 3 pieces on the board, and no Rook, Queen or Pawn.
    pieces_count = 0
    board_array.each do |file|
      file.each do |piece|
        pieces_count += 1 if piece
        return false if pieces_count == 4 || piece.is_a?(Pawn) || piece.is_a?(Rook) || piece.is_a?(Queen)
      end
    end
    true
  end
end
