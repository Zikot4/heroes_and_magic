class UnitsActionsService
  include UnitsActionsCase

  def initialize(current_account,lobby,unit)
    @current_account = current_account
    @lobby = lobby
    @unit = unit
  end

  def heal
    current_unit = Unit.current_units(current_account,lobby.lap).first
    current_unit.lap += 1
    health_points = heal_calculation(current_unit)
    healing(current_unit, [unit], health_points)
  end

  def challenge
    current_unit = Unit.current_units(current_account,lobby.lap).first
    challenge!(current_unit)
    defence if (get_range_value(current_unit) == true) && (get_range_value(unit) == false)
  end

  def defence
    protection, attack = self.action
    damage, absorb = get_damage_absorb(attack, protection)
    damage(attack, protection, damage, absorb)
  end

  def attack
    protection, attack = self.action
    damage = damage_calculation(attack)
    damage(attack, protection, damage)
    unless protection.destroyed?
      damage = damage_calculation(protection)
      damage(protection, attack, damage)
    end
  end

  def action
    protection = defending_unit
    attack = attacking_unit
    [protection, attack]
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
      unit.hp += hp
      unit.save
      who.save
      HistoryActions.add(lobby,StringConsts.heal(who.id.to_s, unit.id.to_s, hp.to_s))
    end
  end

  def damage(who, whom, hp, absorb = 0)
    whom.under_attack = nil
    return whom.save if miss?(who.id.to_s)
    hp, absorb = critical_hit(hp, absorb)
    whom.hp -= hp
    HistoryActions.add(lobby,StringConsts.damage(whom.id.to_s,hp.to_s, absorb.to_s))
    whom.save unless unit_dead?(who, whom)
  end

  def damage_calculation(unit)
    r = Random.new
    return Object.const_get(unit.variety)::DAMAGE[:value] + r.rand(0..5)
  end

  def heal_calculation(unit)
    r = Random.new
    return Object.const_get(unit.variety)::HEAL[:value] + r.rand(0..5)
  end

  def get_defence_value(who, whom)
    type = Object.const_get(who.variety)::DAMAGE[:type]
    return Object.const_get(whom.variety)::RESIST[type]
  end

  def get_range_value(unit)
    return Object.const_get(unit.variety)::DAMAGE[:range]
  end

  def get_damage_absorb(who, whom = nil)
    health_points = damage_calculation(who)
    return health_points if whom.nil?
    damage = (health_points * get_defence_value(who, whom)).round
    absorb = health_points - damage
    return [damage, absorb]
  end

  def critical_hit(damage, absorb)
    r = Random.new
    if (r.rand(0..3)) == 0               # 1/4 critical hit
      critical = r.rand(3..6)
      damage += absorb + critical
      absorb = 0
      HistoryActions.add(lobby,StringConsts.critical_hit(critical.to_s))
    end
    [damage, absorb]
  end

  def unit_dead?(who, whom)
    if whom.hp <= 0
      whom.destroy
      HistoryActions.add(lobby,StringConsts.kill(who.id.to_s,whom.id.to_s))
      return true
    end
  end

  def miss?(who)
    r = Random.new
    if (r.rand(0..6)) == 0               # 1/7 miss
      HistoryActions.add(lobby,StringConsts.miss(who))
      return true
    end
  end

  def challenge!(current_unit)
    current_unit.lap += 1
    unit.under_attack = current_unit.id
    unit.save
    current_unit.save
    HistoryActions.add(lobby,StringConsts.challenge(current_unit.id.to_s,unit.id.to_s))
  end
end
