class Priest
  include Personable
  include Healable
  include Damageable
  include Resistable

  INFO = {
    :hp    => 50,
    :type  => "Priest"
  }
  HEAL = {
    :able  => true,
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
end
