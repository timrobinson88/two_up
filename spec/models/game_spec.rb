require 'spec_helper'

describe Game do
  before do
    @game = GameMaker.new.make
  end

  subject { @game }

  it { should respond_to(:deal_tiles) }
  it { should respond_to(:deal_initial_tiles) }
  it { should respond_to(:start!) }
  it { should respond_to(:add_player!) }
  it { should respond_to(:finish!) }

  context "when a player advances the game" do
    describe "when the game has already reached its max tile count" do
      it "should finish the game" do
        @game.max_tile_count = 12
        @game.players.first.advance_stage
        expect(@game).to be_finished
      end
    end

    describe "when the game does not reach it's max_tile_count" do
      it "should increase the tile tile count by 2" do
        expect{ @game.players.first.advance_stage }.to change{ @game.tiles.count }.by(2)
      end

      it "should not finish the game" do
        @game.players.first.advance_stage
        expect(@game).not_to be_finished
      end
    end
  end

  describe "when a player is added" do
    it "should increase the games" do
      expect{ @game.add_player! }.to change{ @game.players.count }.by(1)
    end
  end

  describe "when the game is finished" do
    before do
      @game.finish!(6)
    end

    it "should update finished to true" do
      expect( @game ).to be_finished
    end

    it "should assign a winner" do
      expect( @game.winner_id ).to eq(6)
    end
  end
end
