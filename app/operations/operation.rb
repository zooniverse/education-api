class Operation < ActiveInteraction::Base
  hash :context do
    object :user, class: :User
    object :panoptes, class: :PanoptesApi
  end

  private

  def current_user
    context.fetch(:user)
  end

  def panoptes
    context.fetch(:panoptes)
  end
end
