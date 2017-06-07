class Warrior
  include Personable
  include Healable
  include Damageable
  include Resistable
  include BuffsForWarrior

  INFO = {
    :hp    => 80,
    :type  => "Warrior"
  }
  HEAL = {
    :able  => false,
    :resurrectionable   => false
  }
  DAMAGE = {
    :range  => false,
    :type   => :physical,
    :value  => 9
  }
  RESIST = {
    :magic    => 0.5,
    :physical => 0.5
  }

  def self.damage_calculation
    r = Random.new
    return DAMAGE[:value] + r.rand(0..5)
  end

  def self.get_defence(type)
    return RESIST[type]
  end

  def self.get_range_value
    return DAMAGE[:range]
  end
end
