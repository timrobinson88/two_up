class Word < ActiveRecord::Base
  DICTIONARY = Dictionary.from_file('public/dictionary.txt')

  belongs_to :player

  def exists?
    DICTIONARY.exists?(string)
  end
end
