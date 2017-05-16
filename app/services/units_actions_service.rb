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
    unit.hp += Object.const_get(current_unit.variety)::ACTION[:heal] + r.rand(0..5)
    unit.save
    current_unit.save
  end

  def challenge
    current_unit = Unit.current_units(current_account,lobby.lap).first
    current_unit.lap += 1
    unit.under_attack = current_unit.id
    unit.save
    current_unit.save
  end

  def defence
    r = Random.new
    protection, attack = self.action
    protection.hp -= (Object.const_get(attack.variety)::ACTION[:damage] + r.rand(0..5)) * Object.const_get(protection.variety)::ACTION[:defence]
    protection.under_attack = nil
    (protection.hp <= 0) ? protection.destroy : protection.save
  end

  def attack
    r = Random.new
    protection, attack = self.action
    protection.hp -= Object.const_get(attack.variety)::ACTION[:damage] + r.rand(0..5)
    protection.under_attack = nil
    protection.save
    if protection.hp <= 0
      protection.destroy
    else
      attack.hp -= Object.const_get(protection.variety)::ACTION[:damage] + r.rand(0..5)
      (attack.hp <= 0) ? attack.destroy : attack.save
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
