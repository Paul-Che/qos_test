class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class ActiveRecord::Base
  def self.soft_deletable
    default_scope { where(deleted: false) }
    scope :deleted, -> { unscoped.where(deleted: true) }

    define_method :destroy do
      run_callbacks(:destroy) do
        update_attribute :deleted, true
      end
    end
  end
end
