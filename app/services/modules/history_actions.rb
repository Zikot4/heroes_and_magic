module HistoryActions

  def self.create(lobby)
    lobby.create_history(actions: "~[Lobby was created]<br>")
  end

  def self.add(lobby,str)
    lobby.history.actions << "~[" + str + "]<br>"
    lobby.history.save
  end

end
