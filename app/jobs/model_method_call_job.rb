class ModelMethodCallJob < ApplicationJob
  queue_as :default

  def perform(model_klass, model_id, method, *args)
    instance = Object.const_get(model_klass).find_by(id: model_id)
    instance.send(method, *args) if instance.present?
  end
end
