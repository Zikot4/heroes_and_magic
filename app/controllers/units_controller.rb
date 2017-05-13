class UnitsController < ApplicationController
  before_action :set_lobby, only: [:new]
  before_action :set_account, only: [:new]
  def show
  end

  def index
  end

  def new
    @unit = Unit.create(unit_params)
    @unit.account_id = @account.id
    @unit.save
    redirect_to lobby_path(@lobby.url) 
  end

  def create
  end

private

  def set_lobby
    @lobby = Lobby.find_by(url: params[:lobby_url])
  end

  def set_account
    @account = Account.find_by(user_id: current_user)
  end

  def set_unit
    @unit = @lobby.accounts.find_by(account_id: params[:id])
  end

  def unit_params
        params.require(:unit).permit(:variety)
  end

end
