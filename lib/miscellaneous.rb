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
end