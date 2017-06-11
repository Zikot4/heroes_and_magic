require 'spec_helper'

describe "Buff", :type => :model do

  it "should create buff for unit" do
    unit = Unit.create
    buff = unit.buffs.create(name: "buff", variety: "variety")
    (buff).should eq(Buff.last)
  end
end
