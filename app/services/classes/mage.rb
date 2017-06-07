class Mage
  include Personable
  include Healable
  include Damageable
  include Resistable
  include BuffsForMage

  INFO = {
    :hp    => 50,
    :type  => "Mage"
  }
  HEAL = {
    :able  => false,
    :resurrectionable   => false
  }
  DAMAGE = {
    :range  => true,
    :type   => :magic,
    :value  => 18
  }
  RESIST = {
    :magic    => 0.5,
    :physical => 0.8
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
