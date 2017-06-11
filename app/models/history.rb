class History < ApplicationRecord
  validates  :variety, :body, :time, presence: true
  
  belongs_to :lobby

  scope :find_by_lobby, lambda {|lobby| where(lobby_id: lobby).order("id DESC")}
end
