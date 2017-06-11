module GenerateUrl
  ALPHABET = ('a'..'z').to_a + ('A'..'Z').to_a
  N = 2
  def self.generate_url
    url = create_url
    url = create_url while Lobby.find_by(url: url)
    return url
  end

  def self.create_url
    r = Random.new
    url = ""
    N.times do |i|
        url += ALPHABET.sample(1).join
        url += r.rand(0..9).to_s
    end
    url
  end
end
