class UnitsCreateService
  include UnitsCreateCase

  def initialize(account, params)
    @account = account
    @params  = params
  end

  def create
    params[:hp] = Object.const_get(params[:variety])::INFO[:hp]
    account.units.create(params)
  end

private
  attr_reader :params, :account
end
