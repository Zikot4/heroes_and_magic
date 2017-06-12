class UnitsController < ApplicationController
  before_action :set_lobby, only: [:new, :index, :destroy, :challenge, :set_account, :action, :attack, :defence, :heal, :set_service, :resurrection]
  before_action :find_current_account, only: [:index, :challenge, :action, :heal]
  before_action :set_service, only: [:action, :attack, :defence]
  before_action :set_account, only: [:new]
  before_action :set_unit, only: [:challenge, :heal, :destroy]
  before_action :set_service_with_unit, only: [:resurrection, :challenge, :heal]

  def challenge
    authorize! :step, @lobby
    service = UnitsActionsService.new(@current_account,@lobby , @unit)
    service.challenge
    redirect_to lobby_units_path(@lobby.url)
  end

  def index
    serv = UnitsShowService.new(@lobby,@current_account)
    serv.game_over
    return redirect_to game_over_lobby_path(@lobby.url) if @lobby.game_over
    return redirect_to lobby_action_path(@lobby.url) if Unit.where(account_id: @current_account.id).where.not(under_attack: nil).exists?
    serv.next
    @current_unit, @my_units, @units = serv.select_units
    @histories = History.find_by_lobby(@lobby.id).first(15)
  end

  def new
    authorize! :create, @lobby
    service = UnitsCreateService.new(@account,unit_params)
    service.create
    redirect_to lobby_path(@lobby.url)
  end

  def action
    redirect_to lobby_path(@lobby.url) unless Unit.current_account_under_attack(@current_account.id).exists?
    @protection, @attack = @service.action
  end

  def heal
    authorize! :step, @lobby
    authorize! :heal, @lobby
    @service.heal
    redirect_to lobby_units_path(@lobby.url)
  end

  def attack
    @service.attack
    redirect_to lobby_path(@lobby.url)
  end

  def defence
    @service.defence
    redirect_to lobby_path(@lobby.url)
  end

  def destroy
    @unit.destroy
    redirect_to lobby_path(@lobby.url)
  end

  def resurrection
    authorize! :step, @lobby
    authorize! :resurrection, @lobby
    @service.resurrection
    redirect_to lobby_path(@lobby.url)
  end

private

  def set_lobby
    @lobby = Lobby.find_by(url: params[:lobby_url])
    redirect_to root_path if @lobby.nil?
  end

  def set_account
    @account = Account.find_by(id: @lobby.accounts,user_id: current_user)
  end

  def set_unit
    @unit = Unit.find_by(id: params[:id])
  end

  def find_current_account
    @current_account = Account.current_account(@lobby.accounts,current_user).first
  end

  def set_service
    @service = UnitsActionsService.new(find_current_account,@lobby,nil)
  end

  def set_service_with_unit
    @service = UnitsActionsService.new(find_current_account,@lobby,set_unit)
  end

  def unit_params
    params.require(:unit).permit(:variety)
  end

end
