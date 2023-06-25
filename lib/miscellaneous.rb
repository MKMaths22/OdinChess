# frozen_string_literal: true

module Miscellaneous
  def other_colour(colour)
    colour == 'White' ? 'Black' : 'White'
  end

  def valid_input?(string)
    string = string.downcase
    ok_letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ok_numbers = ['1', '2', '3', '4', '5', '6', '7', '8']
    valid = true
    valid = false unless ok_letters.include?(string[0]) && ok_letters.include?(string[2])
    valid = false unless ok_numbers.include?(string[1]) && ok_numbers.include?(string[3])
    puts input_error(string) unless valid
    valid
  end

  def input_error(string)
    "#{string} is not acceptable input. Please type the algebraic notation for starting square and finishing square such as 'g1f3'. Castling is a King move."
  end
  
  def string_to_coords(string)
    # accepts a string of the form 'e4' and returns co-ordinates for use in the board_array
    # if other classes want this, maybe put it in a Module?
    [char_to_num(string[0]), string[1].to_i - 1]
  end

  def char_to_num(char)
    ok_letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ok_letters.index(char)
  end

  def add_vector(first_vector, second_vector)
    first_vector.each_with_index.map { |num, index| num + second_vector[index] }
  end

  def subtract_vector(first_vector, second_vector)
    first_vector.each_with_index.map { |num, index| num - second_vector[index] }
  end
  
  def on_the_board?(coords)
    coords[0].between?(0, 7) && coords[1].between?(0, 7)
  end
  
  def get_item(array, coords)
    array[coords[0]][coords[1]]
  end

  def adjacent?(coords_one, coords_two)
    coords_one[0] - coords_two[0].between?(-1,1) && coords_one[1] - coords_two[1].between?(-1,1)
  end

  KNIGHT_VECTORS = [[-1, -2], [-1, 2], [1, -2], [1, 2], [2, 1], [2, -1], [-2, 1], [-2, -1]]

  def piece_in_the_way_error
    "There is a piece in the way of that move. Please try again."
  end

  def capture_own_piece_error
    "You cannot capture your own pieces. Please try again."
  end

  def no_piece_error(move)
    "There is no piece on the square #{move[0,2]}. Please input a valid move."
  end

  def wrong_piece_error(move, colour)
    "That piece is #{other_colour(colour)}. Please input a valid move for #{colour}."
  end

  def no_castling_error(query_string)
    case query_string.length
    when 9
      "#{query_string[0, 5]} can no longer castle on the King side."
    when 11
      "#{query_string[0, 5]} can no longer castle on the Queen side."
    end
  end

  def castle_from_check_error
    "You cannot castle because you are in check. Please input another move."
  end

  def castle_through_check_error
    "You cannot castle by passing your King through a square that is under attack. Please input another move."
  end

  def general_into_check_error
    "That move would leave your King in check. Please try again."
  end

  def find_squares_to_check(colour, vector)
    # colour = 'White' or 'Black'. Vector = [2, 0] or [-2, 0] to indicate King or Queenside castling
    # method outputs the squares that have to be empty between the King and Rook, as a 2-D array
    output = vector[0].positive? ? [[5], [6]] : [[1], [2], [3]]
    row = colour == 'White' ? 0 : 7
    output.each do |item|
      item.push(row)
    end
    output
  end

end