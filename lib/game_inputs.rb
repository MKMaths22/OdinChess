# frozen_string_literal: true

# GameInputs class stores a succession of inputs for playing a game, for testing purposes
# The first two inputs are usually the names of the players, then subsequent inputs are all moves given
# in string format such as 'e2e4', as though we are entering the moves normally
class GameInputs
  def initialize(inputs_array = [])
    @inputs_array = inputs_array
    @inputs_given = inputs_array.size.positive?
  end

  def supply_input
    return @inputs_array.shift if @inputs_given

    gets unless @inputs_given
  end
end
