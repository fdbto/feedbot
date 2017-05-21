module TimeScope
  extend ActiveSupport::Concern
  included do
    if self.attribute_names.include? 'created_at'
      scope :recently_created, -> { order('created_at desc') }
    end
    if self.attribute_names.include? 'updated_at'
      scope :recently_updated, -> { order('updated_at desc') }
    end
  end
end
