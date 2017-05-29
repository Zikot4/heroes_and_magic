module UnitsActionsCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  def defence
    raise NotImplementedError
  end

  def challenge
    raise NotImplementedError
  end

  def attack
    raise NotImplementedError
  end

  def action
    raise NotImplementedError
  end

  def heal
    raise NotImplementedError
  end

  def resurrection
    raise NotImplementedError
  end

  def success?
      errors.none?
  end
end
