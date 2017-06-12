require "rails_helper"
require "./app/services/lobbies_service"
require "./app/services/modules/history_actions"
require "./app/services/modules/string_consts.rb"
require "./app/services/modules/generate_url.rb"

describe LobbiesController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      { :get => "/" }.should route_to(:controller => "lobbies", :action => "index")
    end

    it "loads all visible of the lobbies into @lobbies" do
      lobby1  = Lobby.create!(url: "1",hidden: false)
      lobby2  = Lobby.create!(url: "2",hidden: true)
      { :get => "/" }.should route_to(:controller => "lobbies", :action => "index")

      lobbies = Lobby.find_visible_lobbies.all
      expect(lobbies).to match_array([lobby1])
    end

    it "should find all current user lobby" do
      user1, user2 = User.create!(email: "1@examp", password: "123456"), User.create!(email: "2@examp", password: "123456")
      lobby1, lobby2 = user1.lobbies.create(url: "url1", count_of_users: 3), user1.lobbies.create(url: "url2", count_of_users: 3)
      serv1, serv2  = LobbiesService.new(lobby1, user1, nil), LobbiesService.new(lobby2, user1, nil)
      serv1.join
      serv2.join
      accounts = Account.find_all_user_lobby(user1).all
      l = []
      accounts.each { |a| l << Lobby.where(id: a.lobby_id).first}

      expect(l).to match_array([lobby1,lobby2])
    end
  end

  describe "POST #create" do

    it "responds successfully with an HTTP 200 status code" do
      { :post => "/lobbies" }.should route_to(:controller => "lobbies", :action => "create")
    end

    it "should create new lobby and join" do
      params = { :count_of_users => 5, :game_mode => 3, :hidden => false, :url => nil}
      user1 = User.create!(email: "4@examp", password: "123456")
      serv = LobbiesService.new(nil,user1,params)
      lobby = serv.create

      expect(Lobby.all).to eq([lobby])
    end
  end

  describe "PUT #ready" do
    it "should be changed status: true of false" do
      params = { :count_of_users => 4, :game_mode => 3, :hidden => false, :url => nil}
      user1 = User.create!(email: "1@examp", password: "123456")
      serv = LobbiesService.new(nil,user1,params)
      lobby = serv.create
      serv = LobbiesService.new(lobby, user1, nil)
      serv.ready      #true now
      serv.ready      #false now
      account = Account.current_account(lobby.accounts,user1).first

      (account.user_ready).should == false
    end
  end

  describe "PUT #start" do
    it "should run the game" do
      params = { :count_of_users => 2, :game_mode => 2, :hidden => false, :url => nil}
      user1 = User.create!(email: "1@examp", password: "123456")
      user2 = User.create!(email: "2@examp", password: "123456")
      serv = LobbiesService.new(nil,user1,params)
      lobby = serv.create
      serv = LobbiesService.new(lobby,user1,nil)
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv.start?

      (lobby.everyone_is_ready).should == true # IT SHOULD WORK !!!!
    end
  end

  describe "DELETE #leave" do
    it "should leave from lobby and switch user_id" do
      params = { :count_of_users => 2, :game_mode => 2, :hidden => false, :url => "q1q1"}
      user1 = User.create!(email: "1@examp", password: "123456")
      user2 = User.create!(email: "2@examp", password: "123456")
      serv = LobbiesService.new(nil,user2,params)
      lobby = serv.create
      serv = LobbiesService.new(lobby,user1, nil)
      serv.join
      serv = LobbiesService.new(lobby, user2, nil)
      serv.leave

      (lobby.user_id).should == user1.id
    end
  end
end
