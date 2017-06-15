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

    it "should create new lobby and join" do
      lobby = create(:lobby)
      user1 = User.first
      serv = LobbiesService.new(lobby,user1,nil)
      serv.join

      expect(Lobby.all).to eq([lobby])
    end
  end

  describe "PUT #ready" do
    it "should be changed status: true of false" do
      lobby = create(:lobby)
      user1 = User.first
      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready      #true now
      serv.ready      #false now
      account = Account.current_account(lobby.accounts,user1).first

      expect(account.user_ready).to eq false
    end
  end

  describe "PUT #start" do
    it "should run the game" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)
      serv = LobbiesService.new(lobby,User.first,nil)
      serv.join
      serv.ready

      serv = LobbiesService.new(Lobby.last,User.last,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(Lobby.last,User.last,nil)
      serv.start?

      expect(Lobby.last.everyone_is_ready).to eq true
    end
  end

  describe "DELETE #leave" do
    it "should leave from lobby and switch user_id" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)
      serv = LobbiesService.new(lobby,User.first,nil)
      serv.join

      serv = LobbiesService.new(lobby,user2, nil)
      serv.join
      serv = LobbiesService.new(Lobby.last, user1, nil)
      serv.leave

      expect((Lobby.last).user_id).to eq user2.id
    end
  end

  describe "GET #game_over" do
    it "should game over eq true" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)
      serv = LobbiesService.new(lobby,User.first,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,User.last,nil)
      serv.join
      serv.ready

      serv = LobbiesService.new(Lobby.last, user2,nil)
      serv.start?
      current_account = Account.current_account(lobby.accounts,user1).first
      serv = UnitsShowService.new(Lobby.last,current_account)
      serv.game_over

      expect(Lobby.last.game_over).to eq true
    end
  end
end
