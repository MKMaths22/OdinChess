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
    context 'human versus computer' do
      let(:peter) { instance_double(Player) }
      let(:computer_black) { instance_double(Computer) }
      it 'sets black to be the computer' do
        allow(subject).to receive(:gets).twice.and_return('Peter', 'C')
        allow(Player).to receive(:new).with('White', 'Peter').and_return(peter)
        allow(Computer).to receive(:new).with('Black').and_return(computer_black)
        allow(subject).to receive(:make_human_or_computer).with('White', 'Peter').and_return(peter)
        allow(subject).to receive(:make_human_or_computer).with('Black', 'C').and_return(computer_black)
        allow(peter).to receive(:name).and_return('Peter')
        allow(computer_black).to receive(:name).and_return('Computer(B)')
        game.create_the_players
        expect(game.instance_variable_get(:@black)).to eq(computer_black)
      end
 
    end
  end

  describe '#turn_loop' do
    context 'the game has 10 turns' do
      let(:result) { instance_double(Result) }
      it 'calls one_turn 10 times' do
        allow(result).to receive(:game_over?).exactly(11).times.and_return(false, false, false, false, false, false, false, false, false, false, true)
        allow(game).to receive(:@saved).exactly(11).times.and_return(false, false, false, false, false, false, false, false, false, false)
        expect(game).to receive(:one_turn).exactly(10).times
        game.turn_loop
      end
    end

  end
  

end