class LobbiesService
  include LobbiesCase

  def initialize(lobby, user, params)
    @lobby = lobby
    @user = user
    @params = params
  end

  def create
    @lobby = user.lobbies.new(params)
    GenerateUrl.generate_url(@lobby)
    @lobby.save
    HistoryActions.create(@lobby,StringConsts.create_lobby)
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
  def start?
    if lobby.accounts.length == @lobby.count_of_users
      accounts = Account.accounts_from_lobby(@lobby.accounts)
      accounts.each do |account|
        return false if account.user_ready == false
      end
      account = Account.current_account(accounts,@lobby.user_id).first
      account.current_step = true
      account.save
      @lobby.everyone_is_ready = true
      @lobby.save
      HistoryActions.create(@lobby,StringConsts.game_start)
      return true
    end
  end

  def join
    if lobby.accounts.length < lobby.count_of_users
      lobby_accounts = lobby.accounts
      unless Account.current_account(lobby_accounts, user).exists?
        account = user.accounts.new
        account.lobby_id = lobby.id
        account.save
        HistoryActions.create(lobby,StringConsts.join_to_lobby(user.email))
      end
    end
  end

  def ready
    account = Account.current_account(lobby.accounts, user).first
    (account.user_ready == false) ? account.user_ready = true : account.user_ready = false
    account.save
  end

  def leave
    account = Account.current_account(lobby.accounts, user).first
    account.destroy
    lobby.user_id = nil if account.user_id == lobby.user_id
    account = Account.accounts(lobby.accounts).first
    lobby.user_id = account.user_id if lobby.accounts.length != 0
    (lobby.accounts.length == 0) ? lobby.destroy : lobby.save
  end
private
  attr_reader :lobby, :user, :params
end
