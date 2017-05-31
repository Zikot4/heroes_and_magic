module HistoryActions
  action = "action"

  def self.create(lobby, str)
    body = "~[" + str + "]<br>"
    h = lobby.histories.new(variety: "action", body: body, time: Time.new)
    h.save
  end
end
