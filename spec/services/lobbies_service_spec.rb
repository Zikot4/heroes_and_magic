require "rails_helper"

module BeforeActions
  def create_lobby
    create(:lobby)
  end
end


describe LobbiesService do

  describe "POST #create" do

    it "should create new lobby and join" do
      lobby = create(:lobby)
      serv = LobbiesService.new(lobby,User.first,nil)
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
