class ContagionBuff
  include DamageBuff

  BUFF = {
    :variety => :damage,
    :name    => "ContagionBuff",
    :damage_type  => :magic,
    :value   => 5
  }
end
