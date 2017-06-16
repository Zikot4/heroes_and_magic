class Account < ApplicationRecord
  belongs_to :lobby
  belongs_to :user
  has_many :units, dependent: :destroy

  TEAM = {
    :first  => 1,
    :second => 2,
    :third  => 3,
    :fourth => 4
  }

  scope :accounts,                lambda {|lobby_accounts| where(id: lobby_accounts)}
  scope :find_by_team_and_lap,    lambda {|lobby_accounts, team, lap| where(id: lobby_accounts, team: team, lap: lap)}
  scope :accounts_from_lobby,     lambda {|lobby_accounts| where(id: lobby_accounts)}
  scope :accounts_with_step_true, lambda {|lobby_accounts| where(id: lobby_accounts, current_step: true)}
  scope :accounts_ready,          lambda {|lobby_accounts| where(id: lobby_accounts, user_ready: true) }
  scope :find_all_user_lobby,     lambda {|current_user| where(user_id: current_user).includes(:lobby)}
  scope :current_account,         lambda {|lobby_accounts,user| where(id: lobby_accounts,user_id: user)}
  scope :account_includes_buffs,  lambda {|lobby_accounts,user| where(id: lobby_accounts,user_id: user).includes(units: [:buffs]) }
  scope :other_accounts,          lambda {|lobby_accounts, current_account|where(id: lobby_accounts).where.not(id:  current_account).includes(units: [:buffs]) }
  scope :where_not_defeat,        lambda {|lobby_accounts| where(id: lobby_accounts, defeat: false)}
  scope :find_accounts_from_team, lambda {|lobby_accounts, team| where(id: lobby_accounts, team: team)}
end
