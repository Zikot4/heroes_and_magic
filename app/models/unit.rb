class Unit < ApplicationRecord
  after_update :remove_buffs, if: :dead?

  validates  :variety, :hp, presence: true

  belongs_to :account
  has_many :buffs, dependent: :destroy
  CLASSES = {
    :mage => "Mage",
    :priest => "Priest",
    :warrior => "Warrior"
  }

  scope :attacking_unit,                 lambda {|unit_under_attack| where(id: unit_under_attack)}
  scope :defending_unit,                 lambda {|current_account_id| where(account_id: current_account_id).where.not(under_attack: nil)}
  scope :current_account_under_attack,   lambda {|current_account_id| where(account_id: current_account_id).where.not(under_attack: nil)}
  scope :units_under_attack,             lambda {|lobby_accounts| where(account_id: lobby_accounts).where.not(under_attack: nil)}
  scope :current_units,                  lambda {|current_account, lobby_lap|where(account_id: current_account, lap: lobby_lap, dead: false)}
  scope :find_alive_units,               lambda {|accounts| where(account_id: accounts, dead: false)}
  scope :alive_units_from_lobby,         lambda {|lobby_accounts| where(account_id: lobby_accounts, dead: false)}

private
  def dead?
     return self.dead ? true : false
  end

  def remove_buffs
    (self.buffs).destroy_all
  end
end
