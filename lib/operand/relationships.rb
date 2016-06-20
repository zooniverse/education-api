module Operand
  module Relationships
    extend ActiveSupport::Concern

    class_methods do
      def relationships(*relationship_keys)
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
  end
end
