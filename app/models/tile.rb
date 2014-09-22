class Tile < ActiveRecord::Base
  VALUES = %w(qu w e r t y u i o p a s d f g h j k l z x c v b n m)

  belongs_to :game
  validates :value, presence: true, inclusion: { in: VALUES }
  before_validation :assign_value

  private

  def assign_value
    self.value ||= VALUES.sample
  end
end
