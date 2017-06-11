class UnitsActionsService
  include UnitsActionsCase

  $r = Random.new

  def initialize(current_account,lobby,unit)
    @current_account = current_account
    @lobby = lobby
    @unit = unit
  end

  def heal
    current_unit = Unit.current_units(current_account,lobby.lap).first
    current_unit.lap += 1
    current_unit.save
    health_points = get_unit(current_unit).get_heal
    healing(current_unit, [unit], health_points)
  end

  def challenge
    current_unit = Unit.current_units(current_account,lobby.lap).first
    challenge!(current_unit)
    defence if (get_unit(current_unit).get_range_value == true) && (get_unit(unit).get_range_value == false)
  end

  def defence
    protection, attack = self.action
    attack.lap += 1
    attack.save
    damage, absorb = get_damage_absorb(attack, protection)
    damage(attack, protection, damage, absorb)
  end

  def attack
    protection, attack = self.action
    attack.lap += 1
    attack.save
    damage = get_unit(attack).damage_calculation
    damage(attack, protection, damage)
    unless protection.dead
      damage = get_unit(protection).damage_calculation
      damage(protection, attack, damage)
    end
  end

  def action
    protection = defending_unit
    attack = attacking_unit
    [protection, attack]
  end

  def resurrection
    current_unit = Unit.current_units(current_account,lobby.lap).first
    current_unit.lap += 1
    hp = (current_unit.hp * 0.8).round
    current_unit.hp -= hp
    unit.dead = false
    unit.hp = hp
    unit.lap = lobby.lap + 1
    unit.save
    current_unit.save
    HistoryActions.create(lobby, StringConsts.resurrect(current_unit.id.to_s, unit.id.to_s))
  end

private
  attr_reader :current_account, :lobby, :unit

  def attacking_unit
    return Unit.attacking_unit(defending_unit.under_attack).first
  end

  def defending_unit
    return Unit.defending_unit(lobby.accounts).first
  end

  def healing(who, whom, hp)
    whom.each do |unit|
      Mhealing.healing(unit, hp)
      HistoryActions.create(lobby,StringConsts.heal(who.id.to_s, unit.id.to_s, hp.to_s))
    end
  end

  def damage(who, whom, hp, absorb = 0)
    whom.under_attack = nil
    hp += Buffs.damage_buff(who)
    return whom.save if miss?(who.id.to_s)
    hp, absorb = critical_hit(who, hp, absorb)
    whom.hp -= hp
    HistoryActions.create(lobby,StringConsts.damage(whom.id.to_s,hp.to_s, absorb.to_s))
    make_dead(who, whom)
    whom.save
  end

  def get_unit(unit)
    return Object.const_get(unit.variety)
  end

  def get_defence_value(who, whom)
    damage_type = get_unit(who)::DAMAGE[:type]
    return get_unit(whom).get_defence(damage_type)
  end

  def get_damage_absorb(who, whom = nil)
    health_points = get_unit(who).damage_calculation
    return health_points if whom.nil?
    damage = (health_points * get_defence_value(who, whom)).round
    absorb = health_points - damage
    return [damage, absorb]
  end

  def critical_hit(who, damage, absorb)
    n = Buffs.critical_buff(who) || 3
    if ($r.rand(0..n)) == 0               # 1/4 critical hit
      critical = $r.rand(3..6)
      damage += absorb + critical
      absorb = 0
      HistoryActions.create(lobby,StringConsts.critical_hit(critical.to_s))
    end
    [damage, absorb]
  end

  def make_dead(who, whom)
    if whom.hp <= 0
      whom.dead = true
      whom.save
      HistoryActions.create(lobby,StringConsts.kill(who.id.to_s,whom.id.to_s))
    end
  end

  def miss?(who)
    n = Buffs.miss_buff(who) || 6
    if ($r.rand(0..n)) == 0               # 1/7 miss
      HistoryActions.create(lobby,StringConsts.miss(who))
      return true
    end
  end

  def challenge!(current_unit)
    unit.under_attack = current_unit.id
    unit.save
    current_unit.save
    HistoryActions.create(lobby,StringConsts.challenge(current_unit.id.to_s,unit.id.to_s))
  end
end
