module UnitsShowCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  def index
    raise NotImplementedError
  end

  def success?
      errors.none?
  end
end
