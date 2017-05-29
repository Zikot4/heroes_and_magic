class Mage
  include Personable
  include Healable
  include Damageable
  include Resistable

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
end
