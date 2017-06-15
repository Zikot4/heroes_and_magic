require 'spec_helper'

describe Unit do

  it "should remove all buffs from unit if he is dead" do
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
    buff = create(:buff)
    (Unit.first).update account_id: ac1.id

    ac2 = Account.last
    unit2 = create(:unit,account_id: ac2.id)

    serv = LobbiesService.new(Lobby.last,user2,nil)
    serv.start?
    (Unit.first).update(dead: true)
    expect((Buff.all).length).to eq 0
  end
end
