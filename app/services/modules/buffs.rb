module Buffs

  def self.damage_buff(unit)
    buffs = Buff.find_by_damage(unit).all
    value = 0
    buffs.each do |buff|
      if ((Object.const_get(unit.variety)::DAMAGE[:type]) == (Object.const_get(buff.name)::BUFF[:damage_type])) ||
                                                          ((Object.const_get(buff.name)::BUFF[:damage_type]) == :all)
        value += Object.const_get(buff.name)::BUFF[:value]
        buff.destroy
      end
    end
    return value
  end

  def self.critical_buff(unit)
    buff = Buff.find_by_critical(unit).first
    return nil if buff.nil?
    p = Object.const_get(buff.name)::BUFF[:percent]
    buff.destroy
    return p
  end

  def self.miss_buff(unit)
    buff = Buff.find_by_miss(unit).first
    return nil if buff.nil?
    p = Object.const_get(buff.name)::BUFF[:percent]
    buff.destroy
    return p
  end

private

end
