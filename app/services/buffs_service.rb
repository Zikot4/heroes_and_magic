class BuffsService
  include BuffsCase

  def initialize(lobby, unit, params)
    @lobby  = lobby
    @unit   = unit
    @params = params
  end

  def create
    return false if Buff.find_by(params)
    params[:variety] = Object.const_get(params[:name])::BUFF[:variety]
    buff = Buff.create(params)
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
