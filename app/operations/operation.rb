class Operation < ActiveInteraction::Base
  object :current_user, class: :User
  object :panoptes, class: "Panoptes::Client"
end
