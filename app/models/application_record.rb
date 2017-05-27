class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def send_later(method, *args)
    ModelMethodCallJob.perform_later(self.class.name, self.id, method.to_s, *args)
  end
end
