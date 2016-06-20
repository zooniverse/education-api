module Deletable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
  end

  def deleted?
    deleted_at.present?
  end
end
