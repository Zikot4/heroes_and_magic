class LobbiesController < ApplicationController
  before_action :set_lobby, only: [:show, :edit, :update, :destroy, :join, :ready]

  # GET /lobbies
  # GET /lobbies.json
  def index
    @lobbies = Lobby.all
  end

  # GET /lobbies/1
  # GET /lobbies/1.json
  def show
    lobby_accounts = @lobby.accounts
    @users = User.includes(:accounts).where(:accounts => {id: lobby_accounts}).all
    @users_ready = Account.where(id: lobby_accounts).all
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
    @lobby = Lobby.new(lobby_params)

    respond_to do |format|
      if @lobby.save
        format.html { redirect_to lobby_path(@lobby.url), notice: 'Lobby was successfully created.' }
        format.json { render :show, status: :created, location: @lobby }
      else
        format.html { render :new }
        format.json { render json: @lobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lobbies/1
  # PATCH/PUT /lobbies/1.json
  def update
    respond_to do |format|
      if @lobby.update(lobby_params)
        format.html { redirect_to lobby_path(@lobby.url), notice: 'Lobby was successfully updated.' }
        format.json { render :show, status: :ok, location: @lobby }
      else
        format.html { render :edit }
        format.json { render json: @lobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lobbies/1
  # DELETE /lobbies/1.json
  def destroy
    lobby_accounts = @lobby.accounts.all
    users=Account.where(id: lobby_accounts).all
    users.destroy_all
    @lobby.destroy
    respond_to do |format|
      format.html { redirect_to lobbies_url, notice: 'Lobby was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #GET /lobbies/:url/ready
  def join#TODO
    if @lobby.accounts.size < @lobby.count_of_users
      lobby_accounts = @lobby.accounts
      unless Account.where(id: lobby_accounts,user_id: current_user).exists?
        @account = current_user.accounts.new
        @lobby.accounts << @account
      end
    end
    redirect_to lobby_path(@lobby.url)
  end

  #PUT /lobbies/:url/ready
  def ready
    lobby_accounts = @lobby.accounts
    @account = Account.where(id: lobby_accounts,user_id: current_user).first
    if @account.user_ready == false
      @account.user_ready = true
      @account.save
    end
    redirect_to lobby_path(@lobby.url)
  end

  def start

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lobby
      @lobby = Lobby.find_by(url: params[:url])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lobby_params
      params.require(:lobby).permit(:url, :count_of_users)#TODO change this
    end
end
