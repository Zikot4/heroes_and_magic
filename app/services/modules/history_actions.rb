module HistoryActions
  action = "action"

  def self.create(lobby, str)
    body = "~[" + str + "]<br>"
    lobby.histories.create(variety: "action", body: body, time: Time.new)
  end
end
