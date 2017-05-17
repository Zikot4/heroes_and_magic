class Lobby < ApplicationRecord
  has_many :accounts
  belongs_to :user
end
