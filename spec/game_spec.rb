require '../lib/game'
require '../lib/board'
require '../lib/player'
require '../lib/display_board'
require '../lib/check_for_check'
require '../lib/result'
require '../lib/piece'
require '../lib/pawn'
require '../lib/other_pieces'
require '../lib/miscellaneous'
require '../lib/move'
require '../lib/change_the_board'
require '../lib/generate_legal_moves'

describe Game do
  subject(:game) { described_class.new }

  describe '#self.initialize' do
    it 'sends a message to the Board class' do
      expect(Board).to receive(:new)
      self.new
    end
  end

end