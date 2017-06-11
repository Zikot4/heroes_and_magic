class Buff < ApplicationRecord
  validates :name, :variety, presence: true

  belongs_to :unit

  scope :find_by_damage,     lambda {|current_unit| where(unit_id: current_unit, variety: "damage")}
  scope :find_by_miss,       lambda {|current_unit| where(unit_id: current_unit, variety: "miss")}
  scope :find_by_critical,   lambda {|current_unit| where(unit_id: current_unit, variety: "critical")}
end
