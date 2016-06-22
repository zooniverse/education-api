module Operand
  module Relationships
    extend ActiveSupport::Concern

    class_methods do
      def has_many(model)
        @has_many ||= {}
        @has_many[model] = {}
      end

      def has_many_relations
        @has_many || {}
      end

      def belongs_to(model)
        @belongs_to ||= {}
        @belongs_to[model] = {}
      end

      def belongs_to_relations
        @belongs_to || {}
      end

      def relationships(&block)
        instance_eval(&block) if block
        define_relationships_filter(has_many_relations, belongs_to_relations)

        has_many_relations.each do |key, options|
          # given :student_users, define method student_user_ids
          define_method(key.to_s.classify.foreign_key.pluralize) do
            return nil unless relationships[key]

            relationships.dig(key, :data).map do |resource_identifier|
              resource_identifier.fetch("id")
            end
          end
        end

        belongs_to_relations.each do |key, options|
          define_method(key.to_s.classify.foreign_key) do
            return nil unless relationships[key]
            relationships.dig(key, :data, :id)
          end
        end
      end

      def define_relationships_filter(has_many_relations, belongs_to_relations)
        hash :relationships, default: {} do
          has_many_relations.each do |key, options|
            hash key, default: nil do
              array :data do
                hash do
                  integer :id
                  string :type
                end
              end
            end
          end

          belongs_to_relations.each do |key, options|
            hash key, default: nil do
              hash :data do
                integer :id
                string :type
              end
            end
          end
        end
      end
    end
  end
end
