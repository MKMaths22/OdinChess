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

  describe '#play_game' do
    context 'the game has not been reloaded' do
      it 'calls #create_the_players' do
        expect(subject).to receive(:create_the_players)
        allow(subject).to receive(:turn_loop).and_return('dummy return')
        game.play_game
      end
    end

    context 'the game has been reloaded' do
      subject(:game) { described_class.new(Board.new, nil, nil, result, 'White', DisplayBoard.new, GenerateLegalMoves.new(Board.new).find_all_legal_moves, true, nil, nil, false)}
      let(:result) { instance_double(Result) }
      it 'calls #name_the_players' do
        expect(subject).to receive(:name_the_players)
        allow(subject).to receive(:turn_loop).and_return('dummy return')
        game.play_game
      end
    end
  end

  describe '#create_the_players' do
    context 'two humans playing' do
      subject(:game) { described_class.new }
      let(:peter) { instance_double(Player) }
      let(:chris) { instance_double(Player) }
      it 'sets white to be Peter' do
        allow(subject).to receive(:gets).twice.and_return('Peter', 'Chris')
        allow(Player).to receive(:new).with('White', 'Peter').and_return(peter)
        allow(Player).to receive(:new).with('Black', 'Chris').and_return(chris)
        allow(subject).to receive(:make_human_or_computer).with('White', 'Peter').and_return(peter)
        allow(subject).to receive(:make_human_or_computer).with('Black', 'Chris').and_return(chris)
        allow(peter).to receive(:name).and_return('Peter')
        allow(chris).to receive(:name).and_return('Chris')
        game.create_the_players
        expect(game.instance_variable_get(:@white)).to eq(peter)
      end
      it 'sets black to be Chris' do
        allow(subject).to receive(:gets).twice.and_return('Peter', 'Chris')
        allow(Player).to receive(:new).with('White', 'Peter').and_return(peter)
        allow(Player).to receive(:new).with('Black', 'Chris').and_return(chris)
        allow(subject).to receive(:make_human_or_computer).with('White', 'Peter').and_return(peter)
        allow(subject).to receive(:make_human_or_computer).with('Black', 'Chris').and_return(chris)
        allow(peter).to receive(:name).and_return('Peter')
        allow(chris).to receive(:name).and_return('Chris')
        game.create_the_players
        expect(game.instance_variable_get(:@black)).to eq(chris)
      end
    end
  end
  

end