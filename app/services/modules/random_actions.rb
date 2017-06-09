module RandomActions
  $r = Random.new
  LIST = {
    0 => "FocusedAimBuff",
    1 => "ElementalMasteryBuff",
    2 => "ContagionBuff",
    3 => "DivineHammerBuff",
    4 => "heal"
  }

  def self.action(lobby)
    units = Unit.alive_units_from_lobby(lobby.accounts)
    number = $r.rand(0..LIST.length-1)
    name = LIST[number]
    self.create_buff(lobby, units, name) if LIST[number].include? "Buff"
    self.heal(lobby, units) if LIST[number].include? "heal"
  end
private

  def self.create_buff(lobby, units, name)
    unit = units[$r.rand(0..units.length-1)]
    unless Buff.find_by(unit_id: unit.id, name: name)
      buff = Buff.new(unit_id: unit.id, name: name)
      buff.variety = Object.const_get(buff.name)::BUFF[:variety]
      buff.save
    end
    HistoryActions.create(lobby,StringConsts.get_buff(unit.id.to_s, name))
  end

  def self.heal(lobby, units)
    points = 10
    unit = units[$r.rand(0..units.length-1)]
    unit.hp += points
    unit.hp = Object.const_get(unit.variety)::INFO[:hp] if unit.hp > Object.const_get(unit.variety)::INFO[:hp]
    unit.save
    HistoryActions.create(lobby,StringConsts.get_heal(unit.id.to_s, points.to_s))
  end
end
