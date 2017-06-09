class FocusedAimBuff
  include MissBuff

  BUFF = {
    :variety => :miss,
    :name    => "FocusedAimBuff",
    :percent  => 15               # 6.25% rand(0..15)
  }
end
