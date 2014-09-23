require 'spec_helper'

describe Word do
  describe "checking existence of words" do
    it "should know when it is an invalid word" do
      @word = Word.create!(string: "hgjksdghsklj")
      expect(@word.exists?).to eq(false)
    end

    it "should know when it is a valid word" do
      @word = Word.create!(string: "string")
      expect(@word.exists?).to eq(true)
    end
  end
  
end