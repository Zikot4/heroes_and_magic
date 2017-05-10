json.extract! lobby, :id, :url, :count_of_users, :created_at, :updated_at
json.url lobby_url(lobby, format: :json)
