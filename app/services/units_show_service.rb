class UnitsShowService
  include UnitsShowCase

  def initialize(lobby, current_account,lobby_accounts)
    @lobby = lobby
    @current_account = current_account
    @lobby_accounts = lobby_accounts
  end

  def next
    next_lap
    next_step
  end

  def select_units
    current_unit = Unit.current_units(current_account, lobby.lap).first
    my_units     = Unit.my_units_includes_buffs(current_account)
    units        = Unit.other_units_from_lobby(lobby.accounts, current_account)
    return [current_unit, my_units, units]
  end

  def game_over#TODO
    units = Unit.alive_units_from_lobby(lobby.accounts).all
    account_id = units[0].account_id
    units.each do |unit|
      return false if unit.account_id != account_id
    end
    lobby.game_over = true
    lobby.save
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
