class Lobby < ApplicationRecord
  has_many :accounts, :counter_cache => true
  belongs_to :user
  has_one :history, dependent: :destroy

  GAME_MODE = {
    :three  => 3,
    :four   => 4,
    :five   => 5
  }

end
