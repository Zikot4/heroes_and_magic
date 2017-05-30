module UnitsShowCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  def next
    raise NotImplementedError
  end

  def select_units
    raise NotImplementedError
  end

  def game_over
    raise NotImplementedError
  end
  def success?
      errors.none?
  end
end
