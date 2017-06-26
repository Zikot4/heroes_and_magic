module CurrentLobby
  extend ActiveSupport::Concern

private

  def set_lobby
    @lobby = Lobby.find_by(url: params[:url])
  end
end
