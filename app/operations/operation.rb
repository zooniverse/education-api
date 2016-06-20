class Operation < ActiveInteraction::Base
  object :current_user, class: :User
  object :panoptes, class: "Panoptes::Client"

  class PreScopedOperation
    def initialize(operation_class, scope = {})
      @operation_class = operation_class
      @scope = scope
    end

    def new(hash = {})
      @operation_class.new(hash.merge(@scope))
    end

    def run(hash = {})
      @operation_class.run(hash.merge(@scope))
    end

    def run!(hash = {})
      @operation_class.run!(hash.merge(@scope))
    end

    def with(scope)
      PreScopedOperation.new(self, scope)
    end
  end

  def self.with(scope)
    PreScopedOperation.new(self, scope)
  end

  def self.relationships(*relationship_keys)
    hash :relationships, default: {} do
      relationship_keys.each do |key|
        hash key, default: nil do
          array :data do
            hash do
              integer :id
              string :type
            end
          end
        end
      end
    end

    relationship_keys.each do |key|
      # given :student_users, define method student_user_ids
      define_method(key.to_s.classify.foreign_key.pluralize) do
        return nil unless relationships[key]

        relationships.dig(key, :data).map do |resource_identifier|
          resource_identifier.fetch("id")
        end
      end
    end
  end
end
