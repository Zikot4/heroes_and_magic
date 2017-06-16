class UnitsShowService
  include UnitsShowCase

  def initialize(lobby, current_account)
    @lobby = lobby
    @current_account = current_account
  end

  def next
    next_step
  end

  def select_units_accounts
    current_unit   = Unit.current_units(current_account, lobby.lap).first
    other_accounts = Account.other_accounts(lobby.accounts, current_account).all
    return [current_unit, other_accounts]
  end

  def game_over
    accounts = Account.where_not_defeat(lobby.accounts).all
    accounts.each do |account|
      units = Unit.find_alive_units(account).all
      account.update(defeat: true) unless units.exists?
    end
    accounts = Account.where_not_defeat(lobby.accounts).all
    first = accounts[0]
    accounts.each { |account| return false if account.team != first.team }
    lobby.update(game_over: true)
  end
private
  attr_reader :lobby,:current_account

  def next_lap
    lobby.update(lap: lobby.lap + 1)
    RandomActions.action(lobby) if lobby.lap % 2 == 0
    account = Account.current_account(lobby.accounts,lobby.user_id).first
    account.update(current_step: true)
  end

  def next_step
    acc = Account.accounts_with_step_true(lobby.accounts).first
    units = Unit.current_units(acc.id,lobby.lap)

    unless units.exists?
      team = acc.team
      acc.update(current_step: false, lap: (lobby.lap + 1))

      accounts = Account.where(id: lobby.accounts, lap: lobby.lap)
      return next_lap unless accounts.exists?

      while true
        (team == 4) ? (team = 1) : (team = team + 1)
        account = Account.find_by_team_and_lap(lobby.accounts, team, lobby.lap).first
        return account.update(current_step: true) unless account.nil?
      end
    end
  end
end
