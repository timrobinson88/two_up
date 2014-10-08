class Tile < ActiveRecord::Base
   LETTER_FREQUENCIES = {
    'a' => 63693,
    'b' => 11853,
    'c' => 13825,
    'd' => 32252,
    'e' => 88494,
    'f' => 13126,
    'g' => 16072,
    'h' => 35514,
    'i' => 35389,
    'j' => 2714,
    'k' => 11422,
    'l' => 35218,
    'm' => 17926,
    'n' => 46774,
    'o' => 53892,
    'p' => 11087,
    'qu' => 1743,
    'r' => 34450,
    's' => 39709,
    't' => 72232,
    'u' => 23040,
    'v' => 8510,
    'w' => 19149,
    'x' => 1994,
    'y' => 19439,
    'z' => 1361}

  belongs_to :game
  validates :value, presence: true, inclusion: { in: LETTER_FREQUENCIES }
  before_validation :assign_random_letter_to_value

  private

  def assign_random_letter_to_value
    self.value ||= random_letter
  end

  def random_letter
    random_number = rand(LETTER_FREQUENCIES.values.sum)
    LETTER_FREQUENCIES.detect do |key,value| 
      random_number -= value
      random_number + value < value 
    end[0]
  end
end
