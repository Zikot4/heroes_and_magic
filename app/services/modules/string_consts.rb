module StringConsts
  def self.heal(who, whom, hp)
    return who << " heal " << whom << " on " << hp << "hp"
  end

  def self.challenge(who, whom)
    return "Challenge (" << who << "/" << whom << ")"
  end

  def self.kill(who, whom)
    return "Person (" << whom << ") was killed by (" << who << ")"
  end

  def self.damage(whom, hp, absorb)
    return whom << "was damaged on " <<
              hp << " health points(absorb: " << absorb << ")"
  end

  def self.game_start
    return "All Ready, The Game Began"
  end

  def self.join_to_lobby(who)
    return who + " join in the lobby"
  end

  def self.ready(who)
    return who + " User is ready!"
  end

  def self.critical_hit(value)
    return "+" << value << " critical hit!"
  end

  def self.miss(who)
    return "Unit(" << who << ") Missed!"
  end
end
