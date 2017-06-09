class ElementalMasteryBuff
  include DamageBuff

  BUFF = {
    :variety => :damage,
    :name    => "ElementalMasteryBuff",
    :damage_type  => :all,
    :value   => 15
  }
end
