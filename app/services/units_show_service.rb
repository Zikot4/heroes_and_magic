class UnitsShowService
  include UnitsShowCase

  def initialize(lobby, current_account,lobby_accounts)
    @lobby = lobby
    @current_account = current_account
    @lobby_accounts = lobby_accounts
  end

  def index
    next_lap
    next_step
  end

private
  attr_reader :lobby, :lobby_accounts,:current_account

  def next_lap
    lap = Unit.where(account_id: lobby_accounts, lap: lobby.lap)
    unless lap.exists?
      lobby.lap += 1
      lobby.save
      account = Account.where(id: lobby_accounts,current_step: true).first
      account.current_step = false
      account.save
      account = Account.where(id: lobby_accounts, user_id: lobby.user_id).first
      account.current_step = true
      account.save
    end
  end

  def next_step
    account = Account.where(id: lobby_accounts,  current_step: true).first
    units = Unit.where(account_id: account.id,lap: lobby.lap)
    unless units.exists?
      account.current_step = false
      account.save
      unit = Unit.where(account_id: lobby_accounts,lap: lobby.lap).first
      account = Account.where(id: unit.account_id).first
      account.current_step = true
      account.save
    end
  end
end
