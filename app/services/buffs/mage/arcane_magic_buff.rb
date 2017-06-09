class ArcaneMagicBuff
  include DamageBuff

  BUFF = {
    :variety => :damage,
    :name    => "ArcaneMagicBuff",
    :damage_type  => :magic,
    :value   => 10
  }

  def self.get_buff
    [BUFF[:damage_type],BUFF[:value]]
  end

end
