# frozen-string-literal: true

# Code here can be inserted into the methods of various classes to test that certain lines
# are executing as expected.

# Game class: Insert this at start of #play_game to declare the legal moves found.

legal_moves.each_with_index do |move, index|
  puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}." if move.class.to_s == 'Move'
  puts "The move has class #{move.class.to_s}"
  puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}."
end

def make_the_hash(position)
  # used to be used when initializing the Result object in Game class. However, since YAML does not store the default value of 0 anyway, this method is now redundant.
  output = Hash.new(0)
  output[position] = 1
  output
end

# the two lines below can be used e.g. in #one_turn
puts "There are #{legal_moves.size} legal moves."
puts "#{colour_moving} is the colour to Move."
# and after next_move is defined, we can test the start_square, finish_square
puts "next_move has start square #{next_move.start_square} and ends at #{next_move.finish_square}"

# after boolean is defined, we can test its value
p "The value of boolean is #{boolean} for pawn move or capture."

# In consequences_of_move we can show the value of check_status with
puts "The value of check_status is #{check_status}"

# In #save_the_game
puts "name for saving file = #{name}"
  
   

# Board class: Alternative @board arrays to test endgames and castling rights, or numbers
# of legal moves

[Array.new(8), Array.new(8), Array.new(8), Array.new(8), [King.new('White'), nil, nil, nil, nil, nil, nil, nil], Array.new(8), [nil, nil, nil, nil, nil, nil, nil, King.new('Black')], [Rook.new('White'), nil, nil, nil, nil, nil, nil, nil]]

[[Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Queen.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Queen.new('Black')], [King.new('White'), nil, nil, nil, nil, nil, Pawn.new('Black'), King.new('Black')], [Bishop.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Bishop.new('Black')], [Knight.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Knight.new('Black')], [Rook.new('White'), Pawn.new('White'), nil, nil, nil, nil, Pawn.new('Black'), Rook.new('Black')] ]

[Array.new(8), Array.new(8), Array.new(8), Array.new(8), [King.new('White'), nil, nil, nil, nil, nil, nil, nil], Array.new(8), [Rook.new('Black'), nil, nil, nil, nil, nil, nil, King.new('Black')], [Knight.new('White'), nil, nil, nil, nil, Pawn.new('Black'), nil, nil]]

# In #remove_castling_rights

puts  "remove_castling_rights is working on side #{side}"
puts "opponent = #{opponent} and colour_moving is #{colour_moving}"
puts "colour having castling rights removed is #{colour}"
puts "castling rights are now #{@castling_rights}"

# In #add_en_passent_chance

puts "Adding en_passent chance to board"

# In the Result class

# In #add_position

puts "The size of the previous positions is now #{@previous_positions.keys.size}"

# In #wipe_previous_positions
puts "previous positions being wiped"
puts "The size of the previous positions is now #{@previous_positions.keys.size}"

# In #increase_moves_count or #reset_moves_count
puts "half_moves_count = #{@half_moves_count}"

# In the Piece class

# In #get_all_legal_moves_from

puts "get_all_legal_moves_from is executing on a piece of type #{self.class.to_s}"
puts "Before updating the square this piece of type #{self.class.to_s} has @square #{@square}."
self.square = current_square and 
reset_moves_to_check 
puts "After updating the square this piece of type #{self.class.to_s} has @square #{@square}."
puts "Also, on this piece of class #{self.class.to_s} moves_to_check has reset. The size of it is #{@moves_to_check_for_check.size}."

moves_to_check_for_check.each_with_index do |move, index|
  puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}." if move.class.to_s == 'Move'
  puts "The move has class #{move.class.to_s}"
end

# In #moves_from_base_vectors

puts "moves_from_base_vectors is executing on a piece of type #{self.class.to_s}"
base_vectors.each do |vector|
  puts "base vector = #{vector}"
  possible_squares = possible_squares.concat(get_possible_squares_in_this_direction(vector, board))
  puts "There are #{possible_squares.size} possible squares so far."
end 
self.moves_to_check_for_check = make_move_objects(board, possible_squares)

# In Pawn class

def update_moved_variable
  # puts "update_moved_variable has started running"
  self.moved = true
  # puts "moved variable is now #{@moved}"
  self.non_capture_vectors = [@non_capture_vectors[0]]
  # p "Non_capture_vectors are #{@non_capture_vectors}"
  # puts "The pawn now has #{@non_capture_vectors.size} non_capture vectors"
end

# In #get_all_legal_moves_from(current_square, board)
  puts "Before updating the square this piece of type #{self.class.to_s} has @square #{@square}."
  self.square = current_square
  reset_moves_to_check
  puts "After updating the square this piece of type #{self.class.to_s} has @square #{@square}."
  puts "Also, moves_to_check has reset. The size of it is #{@moves_to_check_for_check.size}."

  # In the GenerateLegalMoves class:

  def find_all_legal_moves
    # outputs either an array of Move objects, which contains just one if get_just_one is true, or no items if there are no legal moves
    output = []
    hash_from_board = board.next_square_with_piece_to_move([-1, 7])
    # starting from [-1, 7] makes [0, 0] the next square, so it works out!
    while hash_from_board
      current_square = hash_from_board['square']
      current_piece = hash_from_board['piece']
      puts "We have a piece of type #{current_piece.class.to_s} at #{current_square}"
      output.concat(current_piece.get_all_legal_moves_from(current_square, board))
      hash_from_board = board.next_square_with_piece_to_move(current_square)
    end
    puts "#{output.size} legal moves found. They are as follows:"
      output.each do |move|
        puts "Start at #{move.start_square}, finish at #{move.finish_square}."
    end
    output
  end



