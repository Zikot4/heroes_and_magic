class Unit < ApplicationRecord
  belongs_to :account
  CLASSES = {
    :mage => "Mage",
    :priest => "Priest",
    :warrior => "Warrior"
  }

  scope :attacking_unit, lambda {|unit_under_attack| where(id: unit_under_attack)}
  scope :defending_unit, lambda {|current_account_id| where(account_id: current_account_id).where.not(under_attack: nil)}
  scope :current_account_under_attack, lambda {|current_account_id| where(account_id: current_account_id).where.not(under_attack: nil)}
  scope :units_under_attack, lambda {|lobby_accounts| where(account_id: lobby_accounts).where.not(under_attack: nil)}
  scope :current_units,   lambda {|current_account, lobby_lap|where(account_id: current_account, lap: lobby_lap, dead: false)}
  scope :my_units,       lambda {|current_account| where(account_id: current_account)}
  scope :my_alive_units, lambda {|current_account| where(account_id: current_account, dead: false)}
  scope :other_units_from_lobby,    lambda {|lobby_accounts, current_account|where(account_id: lobby_accounts).where.not(account_id:  current_account)}
  scope :alive_units_from_lobby,  lambda {|lobby_accounts| where(account_id: lobby_accounts, dead: false)}
end
