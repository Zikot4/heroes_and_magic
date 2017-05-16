class Account < ApplicationRecord
  has_and_belongs_to_many :lobbies
  belongs_to :user
  has_many :units, dependent: :destroy

  scope :users_ready, lambda {|lobby_accounts| where(id: lobby_accounts)}
end
