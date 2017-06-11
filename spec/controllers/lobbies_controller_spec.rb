require "rails_helper"

describe LobbiesController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      { :get => "/" }.should route_to(:controller => "lobbies", :action => "index")
    end

    it "loads all of the lobbies into @lobbies" do
      lobby1, lobby2 = Lobby.create!, Lobby.create!
      { :get => "/" }.should route_to(:controller => "lobbies", :action => "index")


      lobbies = nil
      lobbies << lobby1 << lobby2
      lobbies.should match_array([lobby1, lobby2])
    end
  end
end
