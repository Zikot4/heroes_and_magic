module Mhealing
  def self.healing(whom, hp)
    whom.hp += hp
    whom.hp = Object.const_get(whom.variety)::INFO[:hp] if whom.hp > Object.const_get(whom.variety)::INFO[:hp]
    whom.save
  end
end
