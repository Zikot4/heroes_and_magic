class UnitsActionsService
  include UnitsActionsCase

  def initialize(current_account,lobby,unit)
    @current_account = current_account
    @lobby = lobby
    @unit = unit
  end

  def heal
    r = Random.new
    current_unit = Unit.current_units(current_account,lobby.lap).first
    current_unit.lap += 1
    health_points = Object.const_get(current_unit.variety)::ACTION[:heal] + r.rand(0..5)
    unit.hp += health_points
    unit.save
    current_unit.save
    HistoryActions.add(lobby,StringConsts.heal(current_unit.id.to_s,unit.id.to_s,health_points.to_s))
  end

  def challenge
    current_unit = Unit.current_units(current_account,lobby.lap).first
    current_unit.lap += 1
    unit.under_attack = current_unit.id
    unit.save
    current_unit.save
    HistoryActions.add(lobby,StringConsts.challenge(current_unit.id.to_s,unit.id.to_s))
  end

  def defence
    r = Random.new
    protection, attack = self.action
    health_points = Object.const_get(attack.variety)::ACTION[:damage] + r.rand(0..5)
    damage = (health_points * (Object.const_get(protection.variety)::ACTION[:defence])).round
    absorb = health_points - damage
    protection.hp -= health_points
    protection.under_attack = nil
    if protection.hp <= 0
      protection.destroy
      HistoryActions.add(lobby,StringConsts.kill(attack.id.to_s,protection.id.to_s))
    else
      protection.save
      HistoryActions.add(lobby,StringConsts.damage(protection.id.to_s,health_points.to_s,absorb.to_s))
    end
  end

  def attack
    r = Random.new
    protection, attack = self.action
    health_points = Object.const_get(attack.variety)::ACTION[:damage] + r.rand(0..5)
    protection.hp -= health_points
    protection.under_attack = nil
    protection.save
    if protection.hp <= 0
      protection.destroy
      HistoryActions.add(lobby,StringConsts.kill(attack.id.to_s,protection.id.to_s))
    else
      HistoryActions.add(lobby,StringConsts.damage(protection.id.to_s,health_points.to_s))
      health_points = Object.const_get(protection.variety)::ACTION[:damage] + r.rand(0..5)
      attack.hp -= health_points
      if attack.hp <= 0
        attack.destroy
        HistoryActions.add(lobby,StringConsts.kill(attack.id.to_s,protection.id.to_s))
      else
        attack.save
        HistoryActions.add(lobby,StringConsts.damage(attack.id.to_s, health_points.to_s))
      end
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
    return Unit.defending_unit(current_account.id).first
  end
end
