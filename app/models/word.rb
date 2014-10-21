class Word < ActiveRecord::Base
  DICTIONARY = Dictionary.from_file('public/dictionary.txt')

  belongs_to :player

  validates :string, length: { minimum: 1 }

  def exists?
    DICTIONARY.exists?(string)
  end
end
