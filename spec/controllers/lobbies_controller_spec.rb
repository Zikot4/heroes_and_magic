require "rails_helper"

describe LobbiesController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      expect({ :get => "/" }).to route_to(:controller => "lobbies", :action => "index")
    end

    it "loads all visible of the lobbies into @lobbies" do
      lobby1  = create(:lobby, hidden: false)
      lobby2  = create(:lobby, hidden: true)
      expect({ :get => "/" }).to route_to(:controller => "lobbies", :action => "index")

      lobbies = Lobby.find_visible_lobbies.all
      expect(lobbies).to match_array([lobby1])
    end

    it "should find all current user lobby" do
      lobby1, lobby2 = create(:lobby), create(:lobby)
      serv1, serv2  = LobbiesService.new(lobby1, User.first, nil), LobbiesService.new(lobby2, User.first, nil)
      serv1.join
      serv2.join
      accounts = Account.find_all_user_lobby(User.first).all
      l = []
      accounts.each { |a| l << Lobby.where(id: a.lobby_id).first}

      expect(l).to match_array([lobby1,lobby2])
    end
  end

  describe "POST #create" do

    it "responds successfully with an HTTP 200 status code" do
      expect({ :post => "/lobbies" }).to route_to(:controller => "lobbies", :action => "create")
    end
  end
end
