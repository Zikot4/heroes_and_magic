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

  scope :find_by_id,           lambda { |lobby_id| find(lobby_id) }
  scope :find_visible_lobbies, lambda { where(hidden: false,everyone_is_ready: false).includes(:accounts)}
end
