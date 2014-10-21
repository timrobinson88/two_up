require 'spec_helper'
    
describe Game do
 
  let(:user) { User.create!(email:"timrobinson@gmail.com", password:'qwertyui', password_confirmation:'qwertyui') }
  let(:game) { CreateGame.new.make(user) }
  let(:first_player) { game.players.first }

  before do
    game.start!
  end
 

  subject { game }

  it { should respond_to(:deal_tiles!) }
  it { should respond_to(:start!) }
  it { should respond_to(:finish_and_assign_winner!) }

  describe "when a player advances the game" do
    context "when the game has already reached its max tile count" do
      it "should finish the game" do
        game.max_tile_count = 12
        first_player.advance_stage!
        expect(game).to be_finished
      end
    end

    context "when the game does not reach it's max_tile_count" do
      it "should increase the tile tile count by 2" do
        expect{ first_player.advance_stage! }.to change{ game.tiles.count }.by(2)
      end

      it "should not finish the game" do
        first_player.advance_stage!
        expect(game).not_to be_finished
      end
    end
  end

  describe "when the game is finished" do
    before do
      game.finish_and_assign_winner!(first_player)
    end

    it "should update finished to true" do
      expect( game ).to be_finished
    end

    it "should assign a winner" do
      expect(game.winner).to eq(first_player)
    end
  end
end
