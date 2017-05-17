class LobbiesService
  include LobbiesCase

  def initialize(lobby, user, params)
    @lobby = lobby
    @user = user
    @params = params
  end

  def create
    @lobby = user.lobbies.new(params)
    @lobby.save
    self.join
    @lobby
  end

  def destroy
    lobby_accounts = @lobby.accounts.all
    users=Account.accounts_from_lobby(lobby_accounts).all
    users.destroy_all
    @lobby.destroy
  end

  #return true if all right
  def start
    if lobby.accounts.size == @lobby.count_of_users
      accounts = Account.accounts_from_lobby(@lobby.accounts)
      accounts.each do |account|
        return false if account.user_ready == false
      end
      account = Account.current_account(accounts,@lobby.user_id).first
      account.current_step = true
      account.save
      @lobby.everyone_is_ready = true
      @lobby.save
      return true
    end
  end

  def join
    if lobby.accounts.size < lobby.count_of_users
      lobby_accounts = lobby.accounts
      unless Account.current_account(lobby_accounts, user).exists?
        account = user.accounts.new
        account.lobby_id = lobby.id
        account.save
      end
    end
  end

  def ready
    account = Account.current_account(lobby.accounts, user).first
    if account.user_ready == false
      account.user_ready = true
      account.save
    end
  end

private
  attr_reader :lobby, :user, :params
end
