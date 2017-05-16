class Unit < ApplicationRecord
  belongs_to :account
  CLASSES = {
    :mage => "Mage",
    :priest => "Priest",
    :warrior => "Warrior"
  }

  scope :attacking_unit, lambda {|unit_under_attack| where(id: unit_under_attack)}
  scope :defending_unit, lambda {|current_account_id| where(account_id: current_account_id).where.not(under_attack: nil)}
end
