# frozen-string-literal: true

# Player class: each Player has a @colour attribute which is either 'White' or 'Black' and a name attribute.
class Player
  include Miscellaneous

  attr_reader :colour, :name

  def initialize(colour, name = nil)
    @colour = colour
    @name = name
  end

  def promotion_input
    gets.strip.upcase
  end

  def char_to_num(char)
    # converts file letters into numbers for Board array, e.g.
    # 'a' to 0, 'f' to 5 etc.
    files = *('a'..'h')
    files.index(char)
  end
  
  def string_to_coords(string)
    # accepts a string of the form e.g. 'e4' and returns co-ordinates
    # for use in the board_array e.g. [4, 3]
    [char_to_num(string[0]), string[1].to_i - 1]
  end

  def algebraic(coords)
    # generates for example e4 from [4, 3]
    files = *('a'..'h')
    "#{files[coords[0]]}#{1 + coords[1]}"
  end

  def get_legal_move(board, legal_moves)
    maybe_move = gets.strip
    return get_legal_move(board, legal_moves) unless valid_input?(maybe_move)

    return 'save' if maybe_move.upcase == 'SAVE'

    return 'resign' if maybe_move.upcase == 'RESIGN'

    start_square = string_to_coords(maybe_move[0, 2])
    finish_square = string_to_coords(maybe_move[2, 2])
    move_found = find_legal_move_with_squares(start_square, finish_square, legal_moves)
    # move_found is either false or a legal Move object.
    puts illegal_move_error unless move_found
    move_found || get_legal_move(board, legal_moves)
  end

  def illegal_move_error
    'That move is illegal. Please try again.'
  end

  def find_legal_move_with_squares(start, finish, legal_moves)
    legal_moves.find { |move| move.start_square == start && move.finish_square == finish }
  end

  def valid_input?(string)
    string = string.downcase
    ok_letters = *('a'..'h')
    ok_numbers = *('1'..'8')
    valid = true
    valid = false unless ok_letters.include?(string[0]) && ok_letters.include?(string[2])
    valid = false unless ok_numbers.include?(string[1]) && ok_numbers.include?(string[3])
    valid = true if string.upcase == 'SAVE'
    valid = true if string.upcase == 'RESIGN'
    puts input_error(string) unless valid
    valid
  end

  def input_error(string)
    "#{string} is not acceptable input. Please type the algebraic notation for starting square and finishing square such as 'g1f3'. Castling is a King move. 'Save' to save the game, 'Resign' to resign."
  end
end

# The Computer is a kind of player that is named differently and chooses its
# moves with its own #get_legal_move method.
class Computer < Player
  include Miscellaneous

  attr_reader :colour, :name

  def initialize(colour)
    super(colour, "Computer(#{colour[0]})")
    puts "Computer being initiated as Computer(#{colour[0]})."
    # name is either Computer('W') or Computer('B')
  end

  def get_legal_move(board, legal_moves)
    puts 'Choosing a move randomly like a noob'
    sleep(1)
    queen_captures = legal_moves.filter { |move| move.captured_piece&.is_a?(Queen) }
    rook_captures = legal_moves.filter { |move| move.captured_piece&.is_a?(Rook) }
    other_captures = legal_moves.filter(&:captured_piece)
    move = queen_captures.sample || rook_captures.sample || other_captures.sample || legal_moves.sample
    puts "#{algebraic(move.start_square)}#{algebraic(move.finish_square)}"
    move
  end

  def promotion_input
    'Q'
    # computer always promotes to a queen
  end
end
