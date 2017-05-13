class Unit < ApplicationRecord
  belongs_to :account
  CLASSES = {
    :mage => "mage",
    :priest => "priest",
    :warrior => "warrior"
  }
=begin
  MAGE = {
    :type => "priest",
    :damage => 8,
    :defence => 0.25
  }
  WARRIOR = {
    :type => "priest",
    :damage => 8,
    :defence => 0.25
  }
  PRIEST = {
    :type => "priest",
    :damage => 8,
    :defence => 0.25
  }
=end
end
