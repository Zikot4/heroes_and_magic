class UnitsCreateService
  include UnitsCreateCase

  def initialize(account, params)
    @account = account
    @params  = params
  end

  def create
    unit = account.units.create(params)
    unit.hp = Object.const_get(unit.variety)::INFO[:hp]
    unit.save
  end

private
  attr_reader :params, :account
end
