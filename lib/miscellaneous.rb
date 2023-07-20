# frozen_string_literal: true

module Miscellaneous
  def other_colour(colour)
    colour == 'White' ? 'Black' : 'White'
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

  def next_square(coords)
    return [coords[0], coords[1] + 1] unless coords[1] == 7
    return [coords[0] + 1, 0] unless coords[0] == 7
    nil
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

  def illegal_move_error
    "That move is illegal. Please try again."
  end

  def get_reduced_vector(castling_vector)
    castling_vector[0].positive? ? [1, 0] : [-1, 0]
  end

  def no_castling_error(query_string)
    puts "query_string = #{query_string} with length #{query_string.length}"
    case query_string.length
    when 9
      "#{query_string[0, 5]} can no longer castle on the King side."
    when 11
      "#{query_string[0, 5]} can no longer castle on the Queen side."
    else
      "Some sort of error in the no_castling_error method."
    end
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

  def get_rook_start(castling)
    # outputs the rook's starting co-ordinates for a string 'castling' such as appears in the output_hash given by the Rook class from the #move_like_that method
    file = castling.length == 9 ? 7 : 0
    [file, get_rook_rank(castling)]
  end

  def get_rook_finish(castling)
    file = castling.length == 9 ? 5 : 3
    [file, get_rook_rank(castling)]
  end

  def get_rook_rank(castling)
    castling[0] == 'W' ? 0 : 7
  end

  def castling_string_from_vector(vector, colour_moving)
    part_of_string = vector[0].positive? ? '_0-0' : '_0-0-0'
    string = "#{colour_moving}#{part_of_string}"
  end

  def make_the_hash(position)
    output = Hash.new(0)
    output[position] = 1
    output
  end

  def algebraic(coords)
    # generates for example e4 from [4, 3]
    files = ['a', 'b', 'c', 'd', 'e', 'f', 'g' , 'h']
    "#{files[coords[0]]}#{1 + coords[1]}"
  end
end