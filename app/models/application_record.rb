class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def send_later(method, *args)
    ModelMethodCallJob.perform_later(self.class.name, self.id, method.to_s, *args)
  end

  def booleanize(value)
    case value
    when '0', 0 then false
    when '1', 1 then true
    else
      value ? true : false
    end
  end
end
