class UnitsController < ApplicationController
  before_action :set_lobby, only: [:new, :find_current_account,:index]
  before_action :set_account, only: [:new]
  before_action :find_current_account, only: [:index]

  def show
  end

  def index
    @my_units = Unit.where(account_id: @current_account)
    @units = Unit.where(account_id: @lobby_accounts).where.not(account_id:  @current_account)
  end

  def new
    @account.units.create(unit_params)
    redirect_to lobby_path(@lobby.url)
  end

  def create
  end

private

  def set_lobby
    @lobby = Lobby.find_by(url: params[:lobby_url])
  end

  def set_account
    @account = Account.find_by(id: @lobby.accounts,user_id: current_user)
  end

  def find_current_account
    @lobby_accounts = @lobby.accounts
    @current_account = Account.where(id: @lobby_accounts, user_id: current_user)
  end

  def unit_params
        params.require(:unit).permit(:variety)
  end

end
