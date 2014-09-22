class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :words, dependent: :destroy

  validates :game_id, :user_id, presence: true

  def advance_stage
    if game.tiles.count >= game.max_tile_count
      game.finish!(id)
    else
      game.deal_tiles
    end
  end

  def check_words
    if !contains_invalid_words? && uses_all_tiles?
      advance_stage
    else
      invalid_words
    end
  end

  def contains_invalid_words?
    words.any? { |word| !word.exists? }
  end

  def invalid_words
    puts "invalid words you ignoranus"
  end

  def uses_all_tiles?
    characters = []
    words.each do |word|
      chars = word.string.split('')
      #insert joining Q's and U's here
      characters << chars
    end
    characters.flatten!
    characters.sort!
    game_characters = []
    game.tiles.each { |tile| game_characters << tile.value }
    game_characters.sort!

    characters == game_characters
  end
end







