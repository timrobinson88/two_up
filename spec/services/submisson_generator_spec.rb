require 'spec_helper'

describe SubmissionCreator do
  let(:user) { User.create!(email: "jones@jones.com", password:"qwertyui", password_confirmation:"qwertyui") }
  let(:game) { GameCreator.new.make(user) }
  let(:player) { game.players.first }

  before do
    game.start!
    game.tiles.destroy_all
    %w(h e l l o w o r l d).each { |value| game.tiles.create!(value: value) }
  end

  describe "Making a new submission" do
    it "should save the submitted words to the player" do 
      SubmissionCreator.new(player, ["hello", "world"]).make!
      expect(player.words.map(&:string)).to eq(["hello", "world"])
    end

    context "when a the player already has words and one is included in the new submission" do
      before do
        player.words.create!(string: "potato")
        player.words.create!(string: "cheese")
        player.words.create!(string: "hello")
        SubmissionCreator.new(player, ["hello", "world"]).make!

      end

      it "should delete the existing words that are not in the new submission" do
        expect(player.words.where(string: "potato").count).to eq(0)
      end

      it "should not recreate words the player already has" do
        expect(player.words.where(string: "hello").count).to eq(1)
      end
    end
  end
end