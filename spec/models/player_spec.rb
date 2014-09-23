require 'spec_helper'

describe Player do
  before do
    @player = GameMaker.new.make.players.first
    @game = @player.game
    @game.tiles.delete_all
    values = %w(p l u m l o a f s e e d)
    values.each { |value| @game.tiles.create!(value: value) }
  end

  describe "checking words" do
    describe "With invalid words" do
      before do
        words = %w(plum filsodn seed)
        words.each { |string| @player.words.create!(string: string) }
      end

      it "should not advance the game stage when words are checked" do
        expect{ @player.check_words }.not_to change{ @game.tiles.count }
      end

      it "should contain invalid words" do
        expect(@player.contains_invalid_words?).to eq(true)
      end

      it "should not use all tiles" do
        expect(@player.uses_all_tiles?).to eq(false)
      end
    end

    describe "with valid words" do
      before do
        words = %w(plum loaf seed)
        words.each { |string| @player.words.create!(string: string) }
      end

      it "should not contain any invalid words" do
        expect(@player.contains_invalid_words?).to eq(false)
      end

      it "should use all of the game tiles" do
        expect(@player.uses_all_tiles?).to eq(true)
      end

      it "should advance stage when words are checked" do
        expect{ @player.check_words }.to change{ @game.tiles.count }.by(2)
      end

      describe "when the game has reached maximum tile count" do
        before do
          values = %w(t r e e)
          values.each { |value| @game.tiles.create!(value: value) }
          @player.words.create!(string: "tree")
        end

        it "should finish the game when its words are checked" do
          @player.check_words
          expect(@game.finished).to eq(true)
        end

        it "should be the game winner" do
          @player.check_words
          expect(@game.winner).to eq(@player)
        end
      end
    end
  end
end