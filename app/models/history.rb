class History < ApplicationRecord
  belongs_to :lobby

  scope :find_by_lobby, lambda {|lobby| where(lobby_id: lobby)}
end
