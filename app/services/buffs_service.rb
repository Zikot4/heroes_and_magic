class BuffsService
  include BuffsCase

  def initialize(lobby, unit, params)
    @lobby  = lobby
    @unit   = unit
    @params = params
  end

  def create
    return false if Buff.find_by(params)
    buff = Buff.new(params)
    buff.variety = Object.const_get(buff.name)::BUFF[:variety]
    buff.save
    next_step
    HistoryActions.create(lobby,StringConsts.get_buff(unit.id.to_s, buff.name))
  end

private
  attr_reader :lobby, :params, :unit

  def next_step
    unit.lap += 1
    unit.save
  end
end
