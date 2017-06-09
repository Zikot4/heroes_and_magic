module StringConsts
  def self.heal(who, whom, hp)
    return who << " heal " << whom << " on " << hp << "hp"
  end

  def self.create_lobby
    return "Lobby was created"
  end

  def self.challenge(who, whom)
    return "Challenge (" << who << "/" << whom << ")"
  end

  def self.kill(who, whom)
    return "<font color=\"red\">Person (" << whom << ") was killed by (" << who << ")</font>"
  end

  def self.damage(whom, hp, absorb)
    return whom << " was damaged on " <<
              hp << " health points(absorb: " << absorb << ")"
  end

  def self.game_start
    return "<font color=\"green\">All Ready, The Game Began</font>"
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

  def self.get_buff(user, buff)
    return "Unit[" << user << "] got buff [" << buff << "]"
  end

  def self.get_heal(user, value)
    return "Unit[" << user << "] was healed [ +" << value << "]"
  end

  def self.resurrect(who,whom)
    return "unit[" << whom << "] was resurrected by unit[" << who << "]"
  end
end
