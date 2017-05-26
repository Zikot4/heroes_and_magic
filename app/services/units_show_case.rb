module UnitsShowCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  def next
    raise NotImplementedError
  end

  def success?
      errors.none?
  end
end
