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

      expect((history.last).body).to eq (History.last).body
    end

    it "should make lap" do
      lobby = create(:lobby, count_of_users: 4)
      user1 = User.first
      user2 = create(:user)
      user3 = create(:user)
      user4 = create(:user)

      serv = LobbiesService.new(lobby,user1,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user2,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user3,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user4,nil)
      serv.join
      serv.ready
      serv = LobbiesService.new(lobby,user1,nil)

      ac1 = Account.first
      ac1.update(team: 1)
      unit1 = create(:unit, :priest, account_id: ac1.id)

      ac2 = Account.second
      ac2.update(team: 1)
      unit2 = create(:unit, :priest, account_id: ac2.id)

      ac3 = Account.third
      ac3.update(team: 2)
      unit3 = create(:unit, :priest, account_id: ac3.id)

      ac4 = Account.last
      ac4.update(team: 2)
      unit4 = create(:unit, :priest, account_id: ac4.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?

      serv_for_u1 = UnitsActionsService.new(Account.first, Lobby.last, Unit.first)
      serv_for_u1.heal if (Account.first).current_step

      serv = UnitsShowService.new(Lobby.last, nil)
      serv.next


      serv_for_u3 = UnitsActionsService.new(Account.third, Lobby.last, Unit.third)
      serv_for_u3.heal if (Account.third).current_step

      serv = UnitsShowService.new(Lobby.last, nil)
      serv.next

      serv_for_u2 = UnitsActionsService.new(Account.second, Lobby.last, Unit.second)
      serv_for_u2.heal if (Account.second).current_step

      serv = UnitsShowService.new(Lobby.last, nil)
      serv.next

      serv_for_u4 = UnitsActionsService.new(Account.last, Lobby.last, Unit.last)
      serv_for_u4.heal if (Account.last).current_step

      serv = UnitsShowService.new(Lobby.last, nil)
      serv.next

      expect((Lobby.last).lap    ).to eq 1

    end
  end

  describe "GET #new" do
    it "should create new unit" do
      lobby = create(:lobby)
      serv = LobbiesService.new(lobby,User.first,nil)
      serv.join
      ac = Account.last
      unit = create(:unit)

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
      unit1 = create(:unit, account_id: ac1.id)
      ac2 = Account.last
      unit2 = create(:unit, account_id: ac2.id)

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
      unit1 = create(:unit, :priest, account_id: ac1.id)
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
      unit1 = create(:unit, :priest, account_id: ac1.id, )
      unit2 = create(:unit, :dead, account_id: ac1.id)
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
