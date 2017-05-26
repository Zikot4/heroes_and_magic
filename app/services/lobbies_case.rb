module LobbiesCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  def create
    raise NotImplementedError
  end

  def join
    raise NotImplementedError
  end

  def ready
    raise NotImplementedError
  end

  #return true if all right
  def start?
    raise NotImplementedError
  end

  def destroy
    raise NotImplementedError
  end

  def success?
      errors.none?
  end
end
