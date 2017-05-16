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
    lap = Unit.current_units(lobby_accounts,lobby.lap)
    unless lap.exists?
      lobby.lap += 1
      lobby.save
      account = Account.accounts_with_step_true(lobby_accounts).first
      account.current_step = false
      account.save
      account = Account.current_account(lobby_accounts,lobby.user_id).first
      account.current_step = true
      account.save
    end
  end

  def next_step
    account = Account.accounts_with_step_true(lobby_accounts).first
    units = Unit.current_units(account.id,lobby.lap)
    unless units.exists?
      account.current_step = false
      account.save
      unit = Unit.current_units(lobby_accounts,lobby.lap).first
      account = Account.accounts(unit.account_id).first
      account.current_step = true
      account.save
    end
  end
end
