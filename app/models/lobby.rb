class Lobby < ApplicationRecord
  has_and_belongs_to_many :accounts
  belongs_to :user
end
