#frozen_string_literal: true

# GameInputs class stores a succession of inputs for playing a game, for testing purposes
class GameInputs
  def initialize(inputs_array = [])
    @inputs_array = inputs_array 
  end

  def supply_input
    return @inputs_array.shift if @inputs_array.size.positive?
    gets
  end
end