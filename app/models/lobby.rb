class Lobby < ApplicationRecord
  validates :url, presence: true

  has_many :accounts, :counter_cache => true
  belongs_to :user
  has_many :histories, dependent: :destroy

  GAME_MODE = {
    :three  => 3,
    :four   => 4,
    :five   => 5
  }
  COUNT_OF_USERS = {
    :two   => 2,
    :three => 3,
    :four  => 4
  }
end
