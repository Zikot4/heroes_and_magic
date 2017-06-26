module Damageable
  DAMAGE = {
    :range  => false,
    :type   => :physical,
    :value  => 9
  }

  attr_reader :first

  def damage
    @first = 5
  end
end
