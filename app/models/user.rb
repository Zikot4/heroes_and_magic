class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :accounts
  has_many :lobbies, dependent: :destroy

  scope :users, lambda {|lobby_accounts| includes(:accounts).where(accounts: {id: lobby_accounts})}
end
