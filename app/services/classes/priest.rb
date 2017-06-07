class Priest
  include Personable
  include Healable
  include Damageable
  include Resistable
  include BuffsForPriest

  INFO = {
    :hp    => 50,
    :type  => "Priest"
  }
  HEAL = {
    :able  => true,
    :resurrectionable   => true,
    :type  => :magic,
    :value => 9
  }
  DAMAGE = {
    :range  => true,
    :type   => :magic,
    :value  => 9
  }
  RESIST = {
    :magic    => 0.4,
    :physical => 0.8
  }

  def self.damage_calculation
    r = Random.new
    return DAMAGE[:value] + r.rand(0..5)
  end

  def self.get_defence(type)
    return RESIST[type]
  end

  def self.get_heal
   r = Random.new
   return HEAL[:value] + r.rand(0..5)
 end

  def self.get_range_value
    return DAMAGE[:range]
  end
end
