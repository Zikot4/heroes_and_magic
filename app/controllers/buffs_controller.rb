class BuffsController < ApplicationController
  before_action :set_lobby, only: [:index, :new, :find_current_unit]
  before_action :find_current_account, only: [:index, :new, :find_current_unit]
  before_action :find_current_unit, only: [:index, :new]

  def index
    authorize! :step, @lobby
    return redirect_to lobby_path(@lobby.url) if @current_unit.nil?
    @my_units = Unit.my_alive_units(@current_account)
  end

  def new
    buff = Buff.new(buff_params)
    buff.variety = Object.const_get(buff.name)::BUFF[:variety]
    buff.save
    next_step
    redirect_to lobby_units_path(@lobby.url)
  end

private

  def find_current_account
    @current_account = Account.current_account(@lobby.accounts,current_user).first
  end

  def find_current_unit
    @current_unit = Unit.current_units(@current_account, @lobby.lap).first
  end

  def next_step
    @current_unit.lap += 1
    @current_unit.save
  end

  def set_lobby
    @lobby = Lobby.find_by(url: params[:lobby_url])
  end

  def buff_params
    params.require(:buff).permit(:unit_id, :name)
  end
end
