class Operation < Operand::Base
  include Operand::With
  include Operand::Relationships

  object :current_user, class: :User
  object :client, class: "Panoptes::Client"
end
