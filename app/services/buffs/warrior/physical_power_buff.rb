module PhysicalPowerBuff
  include DamageBuff

  BUFF = {
    :variety => "damage",
    :name    => "PhysicalPowerBuff",
    :damage_type  => :physical,
    :value   => 10
  }

  def self.get_buff
    [BUFF[:damage_type],BUFF[:value]]
  end
  
end
