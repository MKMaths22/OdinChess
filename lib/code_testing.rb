# frozen-string-literal: true

# Code here can be inserted into the methods of various classes to test that certain lines
# are executing as expected.

# Game class: Insert this at start of #play_game to declare the legal moves found.

legal_moves.each_with_index do |move, index|
  puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}." if move.class.to_s == 'Move'
  puts "The move has class #{move.class.to_s}"
  puts "Move number #{index} is from #{move.start_square} to #{move.finish_square}."
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