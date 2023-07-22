# frozen-string-literal: true

require 'colorize'

# includes the methods that are specific to Pawns
class Pawn < Piece
  
  attr_accessor :colour, :movement_vectors, :castling_vectors, :base_vectors, :display_strings, :square, :moves_to_check_for_check, :capture_vectors, :non_capture_vectors, :moved

  def initialize(colour)
    @colour = colour
    @capture_vectors = get_captures
    @non_capture_vectors = get_non_captures
    @castling_vectors = []
    @square = nil
    @moves_to_check_for_check = []
    @basic_display_strings = ['         ', '    o    ', '   / \   ', '   |_|   ']
    @display_strings = apply_colour(@basic_display_strings)
    @moved = false
    # puts "When created, this pawn has @square = #{@square} and #{moves_to_check_for_check.size} moves to check. The moved variable is #{@moved}."
  end

  def update_moved_variable
    # puts "update_moved_variable has started running"
    self.moved = true
    # puts "moved variable is now #{@moved}"
    self.non_capture_vectors = [@non_capture_vectors[0]]
    # p "Non_capture_vectors are #{@non_capture_vectors}"
    # puts "The pawn now has #{@non_capture_vectors.size} non_capture vectors"
  end

  def capture_possible?(start_square, finish_square, board)
    # we don't care about en_passent in this method because it is only used to see if
    # the opposition king would be in check
    @capture_vectors.each do |vector|
      capture_square = add_vector(start_square, vector)
      return true if capture_square == finish_square
    end
    false
  end

  def moved?
    @moved
  end

  def get_captures
    colour == 'White' ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
  end

  def get_non_captures
    colour == 'White' ? [[0, 1], [0, 2]] : [[0, -1], [0, -2]]
    # rest of code can use the fact that the FIRST non_capture vector
    # has to be playable onto an empty square to consider the SECOND one,
    # if the second one exists.
  end

  def get_all_legal_moves_from(current_square, board)
    # puts "Before updating the square this piece of type #{self.class.to_s} has @square #{@square}."
    self.square = current_square
    reset_moves_to_check
    # puts "After updating the square this piece of type #{self.class.to_s} has @square #{@square}."
    # puts "Also, moves_to_check has reset. The size of it is #{@moves_to_check_for_check.size}."
  
    capture_vectors.each do |vector|
      capture_at = add_vector(current_square, vector)
      moves_to_check_for_check.push(Move.new(board, square, capture_at)) if validate_square_for_moving(board, capture_at) == 'capture'
      moves_to_check_for_check.push(Move.new(board, square, capture_at, true, false)) if board.en_passent_capture_possible_at?(capture_at)
    end

    first_non_capture_square = add_vector(current_square, non_capture_vectors[0])
    if validate_square_for_moving(board, first_non_capture_square) == 'non-capture'
      moves_to_check_for_check.push(Move.new(board, square, first_non_capture_square))
      if non_capture_vectors[1]
        other_square = add_vector(current_square, non_capture_vectors[1])
        moves_to_check_for_check.push(Move.new(board, square, other_square)) if validate_square_for_moving(board, other_square) == 'non-capture'
      end
    end
    
    output = moves_to_check_for_check.filter { |move| move.legal? }
    # pawn promotion is dealt with in ChangeTheBoard but we don't
    # need to know the piece the pawn promotes to in order to check
    # whether the move is legal
    self.square = nil
    reset_moves_to_check
    output
  end

  def add_en_passent(board, move)
    board.add_en_passent_chance(move.finish_square) unless move.vector[1].between?(-1, 1)
  end

  def promotion(board, player, square)
    puts promotion_message(player)
    new_piece = get_piece_for_promotion(player, board.colour_moving)
    board.replace_pawn_with(new_piece, square)
  end

  def promotion_message(player)
    "You are promoting a pawn, #{player.name}. Please input 'N' to promote to a Knight, 'R' for Rook, 'B' for Bishop or anything else for a Queen."
  end

  def get_piece_for_promotion(player, colour)
    string = player.get_promotion_input
      case string
      when 'N'
        Knight.new(colour)
      when 'R'
        Rook.new(colour)
      when 'B'
        Bishop.new(colour)
      else
        Queen.new(colour)
     end
  end

end