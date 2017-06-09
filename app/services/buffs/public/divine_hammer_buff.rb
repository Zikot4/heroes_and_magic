class DivineHammerBuff
  include DamageBuff

  BUFF = {
    :variety => :damage,
    :name    => "DivineHammerBuff",
    :damage_type  => :physical,
    :value   => 5
  }
end
