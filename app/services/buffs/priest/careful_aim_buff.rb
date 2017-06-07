class CarefulAimBuff
  include MissBuff

  BUFF = {
    :variety => "miss",
    :name    => "CarefulAimBuff",
    :percent  => 49               # 2% rand(0..49)
  }
end
