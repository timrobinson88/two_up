class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :words, dependent: :destroy

  validates :game_id, :user_id, presence: true

  def advance_stage!
    game.advance_stage!(self)
  end

  def submission_correct?
    !contains_invalid_words? && uses_all_tiles?
  end

  private 

  def contains_invalid_words?
    words.any? { |word| !word.exists? }
  end

  def uses_all_tiles?
    tiles_used_in_words == game.available_tiles
  end

  def tiles_used_in_words
    words.flat_map do |word|
      word.string.gsub('qu', '*').chars.map { |letter| letter == '*' ? 'qu' : letter }
    end.sort
  end
end







