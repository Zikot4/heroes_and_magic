module BuffsCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  def create
    raise NotImplementedError
  end

  def success?
      errors.none?
  end
end
