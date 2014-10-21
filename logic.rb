 require 'ruby-dictionary'

 DICTIONARY = Dictionary.from_file('public/dictionary.txt')
 words = %w(cheese milk ham)

def invalid_words(words)
  invalid_words = []

  words.each do |word|
    invalid_words << word if !DICTIONARY.exists?(word)
  end

  invalid_words
end

def all_words_valid?(words)
  words.any? { |word| !DICTIONARY.exists?(word) }
end

if all_words_valid?(words)
  puts invalid_words(words)
else
  puts 'all words correct'
end

game = create_game
game.add_player
game.start!

game.checkwords
  if game.words_valid?
    game.two_up
  else
    game.player_invalid_words
  end

game.two_up
  if game.tiles.count >= game.tile_limit
    game.finish
  else
    game.generate_tiles
  end