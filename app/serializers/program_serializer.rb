class ProgramSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :metadata, :description, :custom
end
