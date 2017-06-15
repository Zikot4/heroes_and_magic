require "rails_helper"

describe UnitsController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      #TODO
    end

    it "Should find lobby history " do
      lobby = create(:lobby)
      serv = LobbiesService.new(lobby,User.first,nil)
      serv.join
      history = History.find_by_lobby(lobby.id).first(15)

      expect((history.last).body).to eq "~[13@examp join in the lobby]<br>"
    end
  end

  describe "GET #new" do
    it "should create new unit" do
      lobby = create(:lobby)
      serv = LobbiesService.new(lobby,User.first,nil)
      serv.join
      ac = Account.last
      unit = create(:unit, account_id: ac.id)

      expect(unit).to eq Unit.last
    end
  end

  describe "PUT #challenge" do
    it "should challenge another unit" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      unit1 = create(:unit,account_id: ac1.id)
      ac2 = Account.last
      unit2 = create(:unit,account_id: ac2.id)

      l = Lobby.last
      serv = LobbiesService.new(l,user2,nil)
      serv.start?
      s = UnitsActionsService.new(ac1, l, unit2)
      s.challenge

      expect(unit2.under_attack).to eq unit1.id
    end
  end

  describe "GET #action" do
    it "should find attack unit and protection unit" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      unit1 = create(:unit,account_id: ac1.id)
      ac2 = Account.last
      unit2 = create(:unit,account_id: ac2.id)

      l = Lobby.last
      serv = LobbiesService.new(l,user2,nil)
      serv.start?
      s = UnitsActionsService.new(ac1, l, unit2)
      s.challenge
      protection, attack = s.action

      expect([unit2, unit1]).to eq ([protection, attack])
    end
  end

  describe "PUT #heal" do
    it "should heal" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      unit1 = create(:unit,account_id: ac1.id, variety: "Priest")
      ac2 = Account.last
      unit2 = create(:unit,account_id: ac2.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?
      s = UnitsActionsService.new(Account.first, Lobby.last, Unit.first)
      s.heal
      expect((Unit.first).lap).to eq (Lobby.last).lap + 1
    end
  end

  describe "PUT #attack" do
    it "should attack your target" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      unit1 = create(:unit,account_id: ac1.id)
      ac2 = Account.last
      unit2 = create(:unit,account_id: ac2.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?
      s = UnitsActionsService.new(Account.first, Lobby.last, unit2)
      s.challenge
      s = UnitsActionsService.new(Account.last, Lobby.last, unit2)
      s.attack
      expect((Unit.first).lap).to eq 1
      expect((Unit.last).under_attack).to eq nil
      expect((Unit.last).lap).to eq 0
    end
  end

  describe "PUT #defence" do
    it "should be protected from attack" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      unit1 = create(:unit,account_id: ac1.id)
      ac2 = Account.last
      unit2 = create(:unit,account_id: ac2.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?
      s = UnitsActionsService.new(Account.first, Lobby.last, unit2)
      s.challenge
      s = UnitsActionsService.new(Account.last, Lobby.last, unit2)
      s.defence
      expect((Unit.first).lap).to eq 1
      expect((Unit.first).hp).to eq Object.const_get((Unit.first).variety)::INFO[:hp]
      expect((Unit.last).lap).to eq 0
      expect((Unit.last).under_attack).to eq nil
    end
  end

  describe "PUT #defence" do
    it "should be protected from attack" do
      lobby = create(:lobby)
      user1 = User.first
      user2 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      unit1 = create(:unit,account_id: ac1.id, variety: "Priest")
      unit2 = create(:unit,account_id: ac1.id, dead: true)
      ac2 = Account.last
      unit3 = create(:unit,account_id: ac2.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?

      hp = (Unit.first).hp
      mg_hp = hp * 0.8
      prst_hp = hp - mg_hp
      s = UnitsActionsService.new(Account.first, Lobby.last, Unit.second)
      s.resurrection

      expect((Unit.first).lap).to eq (Lobby.last).lap + 1
      expect((Unit.first).hp).to eq prst_hp
      expect((Unit.second).hp).to eq mg_hp
      expect((Unit.second).dead).to eq false
    end
  end
end
