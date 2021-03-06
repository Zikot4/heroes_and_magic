class LobbiesController < ApplicationController
  include CurrentLobby
  before_action :authenticate_user!

  before_action :set_lobby, :set_service, only: [:show,:update,:destroy,
                                  :join, :ready, :start, :edit,
                                  :leave, :current_account, :game_over,
                                  :change_team ]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_lobby
    # GET /lobbies
    # GET /lobbies.json
    def index
      @lobbies = Lobby.find_visible_lobbies.all
      @accounts = Account.find_all_user_lobby(current_user).all
    end

    # GET /lobbies/1
    # GET /lobbies/1.json
    def show
      if @lobby.everyone_is_ready
        redirect_to lobby_units_path(@lobby.url)
      else
        @users = User.users(@lobby.accounts).all
        @users_ready = Account.accounts_ready(@lobby.accounts).all
        @current_account = Account.current_account(@lobby.accounts,current_user.id).first
      end
    end

    # GET /lobbies/new
    def new
      @lobby = Lobby.new
    end

    # GET /lobbies/1/edit
    def edit
      authorize! :update, @lobby
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
      authorize! :update, @lobby
      @lobby.update(lobby_params)
      redirect_to lobby_path(@lobby.url), notice: 'Lobby was successfully updated.'
    end

    # DELETE /lobbies/1
    # DELETE /lobbies/1.json
    def destroy
      authorize! :destroy, @lobby
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
      if @service.start?
        redirect_to lobby_units_path(@lobby.url)
      else
        redirect_to lobby_path(@lobby.url)
      end
    end

    #DELETE /lobbies/:url/leave
    def leave
      @service.leave
      redirect_to root_path
    end

    #GET /lobbies/:url/game_over
    def game_over
      return redirect_to lobby_path(@lobby.url) unless @lobby.game_over
      accounts = Account.find_accounts_from_team(@lobby.accounts, current_account.team)
      @result = nil
      accounts.each { |account| @result ||= !(account.defeat)}
      @histories = History.find_by_lobby(@lobby.id)
    end

    #PUT /lobbies/:url/change_team
    def change_team
      current_account.update(params.require(:account).permit(:team))
      redirect_to lobby_path(@lobby.url)
    end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = LobbiesService.new(@lobby,current_user,nil)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lobby_params
      params.require(:lobby).permit(:count_of_users, :game_mode, :hidden)
    end

    def current_account
      return current_account = Account.current_account(@lobby.accounts,current_user).first
    end

    def invalid_lobby
    logger.error "Attempt to access invalid lobby #{params[:url]}"
    return redirect_to root_path, notice: "Invalid lobby"
  end
end
