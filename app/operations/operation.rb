class Operation < Operand::Base
  include Operand::With
  include Operand::Relationships

  object :current_user, class: :User
  object :panoptes, class: "Panoptes::Client"
end
