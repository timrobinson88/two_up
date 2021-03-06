class User < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :games, through: :players
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
