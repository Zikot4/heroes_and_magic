class Lobby < ApplicationRecord
  has_many :accounts
  belongs_to :user
  has_one :history, dependent: :destroy
end
