class Warrior
  include Personable
  include Healable
  include Damageable
  include Resistable

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
end
