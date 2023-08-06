# frozen_string_literal: true

# Miscellaneous module contains various methods to declutter some of the classes.
module Miscellaneous
  def other_colour(colour)
    colour == 'White' ? 'Black' : 'White'
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

  def castling_string_from_vector(vector, colour_moving)
    part_of_string = vector[0].positive? ? '_0-0' : '_0-0-0'
    "#{colour_moving}#{part_of_string}"
  end
end
