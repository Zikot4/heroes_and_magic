class UnitsController < ApplicationController
  before_action :set_lobby, only: [:new, :index, :challenge, :set_account,:action,:attack,:defence]
  before_action :find_current_account, only: [:index,:challenge,:action]
  before_action :set_service, only: [:action,:attack,:defence]
  before_action :set_account, only: [:new]
  before_action :set_unit, only: [:challenge]

  def challenge
    service = UnitsActionsService.new(@current_account,@lobby , @unit)
    service.challenge
    redirect_to lobby_units_path(@lobby.url)
  end

  def index
    redirect_to lobby_action_path(@lobby.url) if Unit.where(account_id: @current_account.id).where.not(under_attack: nil).exists?
    @units_under_attack = Unit.all.where(account_id: @lobby_accounts).where.not(under_attack: nil)
    service = UnitsShowService.new(@lobby,@current_account,@lobby_accounts)
    service.index
    @current_unit = Unit.where(account_id: @current_account, lap: @lobby.lap).first
    @my_units = Unit.where(account_id: @current_account)
    @units = Unit.where(account_id: @lobby_accounts).where.not(account_id:  @current_account)
  end

  def new
    service = UnitsCreateService.new(@account,unit_params)
    service.create
    redirect_to lobby_path(@lobby.url)
  end

  def action
    redirect_to lobby_path(@lobby.url) unless Unit.where(account_id: @current_account.id).where.not(under_attack: nil).exists?
    @protection, @attack = @service.action
  end

  def attack
    @service.attack
    redirect_to lobby_path(@lobby.url)
  end

  def defence
    @service.defence
    redirect_to lobby_path(@lobby.url)
  end

private

  def set_lobby
    @lobby = Lobby.find_by(url: params[:lobby_url])
  end

  def set_account
    @account = Account.find_by(id: @lobby.accounts,user_id: current_user)
  end

  def set_unit
    @unit = Unit.find_by(id: params[:id])
  end

  def find_current_account
    @lobby_accounts = @lobby.accounts
    @current_account = Account.where(id: @lobby_accounts, user_id: current_user).first
  end

  def set_service
    @service = UnitsActionsService.new(find_current_account,nil,nil)
  end

  def unit_params
    params.require(:unit).permit(:variety)
  end

end
