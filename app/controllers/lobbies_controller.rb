class LobbiesController < ApplicationController
  before_action :set_lobby, only: [:show, :edit,:update, :destroy, :join, :ready, :start]

  # GET /lobbies
  # GET /lobbies.json
  def index
    @lobbies = Lobby.all
  end

  # GET /lobbies/1
  # GET /lobbies/1.json
  def show
    if @lobby.everyone_is_ready
      redirect_to lobby_units_path(@lobby.url)
    else
      lobby_accounts = @lobby.accounts
      @users = User.users(lobby_accounts).all
      @users_ready = Account.accounts(lobby_accounts).all
    end
  end

  # GET /lobbies/new
  def new
    @lobby = Lobby.new
  end

  # GET /lobbies/1/edit
  def edit
  end

  # POST /lobbies
  # POST /lobbies.json
  def create
    @service = LobbiesService.new(nil,current_user,lobby_params)
    lobby = @service.create
    redirect_to lobby_path(lobby.url)
  end

  # PATCH/PUT /lobbies/1
  # PATCH/PUT /lobbies/1.json
  def update
    @lobby.update(lobby_params)
    redirect_to lobby_path(@lobby.url), notice: 'Lobby was successfully updated.'
  end

  # DELETE /lobbies/1
  # DELETE /lobbies/1.json
  def destroy
    @service.destroy
    redirect_to lobbies_url, notice: 'Lobby was successfully destroyed.'
  end

  #GET /lobbies/:url/ready
  def join
    @service.join
    redirect_to lobby_path(@lobby.url)
  end

  #PUT /lobbies/:url/ready
  def ready
    authorize! :join, @lobby
    @service.ready
    redirect_to lobby_path(@lobby.url)
  end

  #PUT /lobbies/:url/start
  def start
    authorize! :join, @lobby
    if @service.start
      redirect_to lobby_units_path(@lobby.url)
    else
      redirect_to lobby_path(@lobby.url)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lobby
      @lobby = Lobby.find_by(url: params[:url])
      @service = LobbiesService.new(@lobby,current_user,nil)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lobby_params
      params.require(:lobby).permit(:url, :count_of_users)#TODO change this
    end

end
