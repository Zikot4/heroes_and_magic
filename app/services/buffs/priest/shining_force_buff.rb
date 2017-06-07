module ShiningForceBuff
  include DamageBuff

  BUFF = {
    :variety => "damage",
    :name    => "ShiningForceBuff",
    :damage_type  => :all,
    :value   => 10
  }

  def self.get_buff
    [BUFF[:damage_type],BUFF[:value]]
  end
end
