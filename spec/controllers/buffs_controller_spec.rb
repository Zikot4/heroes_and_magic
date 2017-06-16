require "rails_helper"

describe BuffsController, :type => :controller do
  describe "GET #index" do
    it "should find alive units from account" do
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
      unit1 = create(:unit, account_id: ac1.id, )
      unit2 = create(:unit, :dead, account_id: ac1.id)
      ac2 = Account.last
      unit3 = create(:unit,account_id: ac2.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?

      units = Unit.find_alive_units(ac1)
      expect(units.length).to eq 1
    end
  end

  describe "GET #index" do
    it "should find alive units from account" do
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
      unit3 = create(:unit, account_id: ac2.id)

      serv = LobbiesService.new(Lobby.last,user2,nil)
      serv.start?
      params = { name: "ArcaneMagicBuff", variety: :damage, unit_id: (Unit.first).id}
      serv = BuffsService.new(Lobby.last, Unit.first, params)
      serv.create

      expect((Unit.first).lap).to eq (Lobby.last).lap + 1
      expect((Unit.first).buffs.length).to eq 1
    end
  end
end
