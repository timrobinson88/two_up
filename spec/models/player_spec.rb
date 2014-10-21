require 'spec_helper'

describe Player do
  let(:user) { User.create!(email:"timrobinson@gmail.com", password:'qwertyui', password_confirmation:'qwertyui') }
  let(:game) { CreateGame.new.make(user) }
  let(:player) { game.players.first }

  before do
    game.tiles.delete_all
    values = %w(p l u m l o a f s e e d)
    values.each { |value| game.tiles.create!(value: value) }
  end

  describe "checking submission" do
    describe "With invalid words" do
      before do
        words = %w(plum filsodn seed)
        words.each { |string| player.words.create!(string: string) }
      end

      it "should not be a correct submission" do
        expect(player.submission_correct?).to eq(false)
      end
    end

    describe "with valid words" do
      before do
        words = %w(plum loaf seed)
        words.each { |string| player.words.create!(string: string) }
      end

      context "when all tiles are used" do
        it "should be a valid submission" do
          expect(player.submission_correct?).to eq(true)
        end
      end

      context "when all tiles are not used" do
        it "should not be a valid submission" do
          game.tiles.create!
          expect(player.submission_correct?).to eq(false)
        end
      end
    end

    describe "when the player advances the game" do
      context "when the game has reached maximum tile count" do
        before do
          values = %w(t r e e)
          values.each { |value| game.tiles.create!(value: value) }
          player.words.create!(string: "tree")
          player.advance_stage!
        end

        it "should finish the game when its words are checked" do
          expect(game.finished).to eq(true)
        end

        it "should be the game winner" do
          expect(game.winner).to eq(player)
        end
      end

      context "when the game does not reach maximum tile count" do
        it "should create two new tiles" do
          expect{ player.advance_stage! }.to change{ game.tiles.count }.by(2)
        end

        it "should not finish the game" do
          player.advance_stage!
          expect(game.finished?).to eq(false)
        end

        it "should not have a winner assigned to the game" do
          expect(game.winner).to eq(nil)
        end
      end 
    end
  end
end