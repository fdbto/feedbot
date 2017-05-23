
ActionMailer::DeliveryJob.queue_name = ''
ActiveJob::Base.queue_name = ''
ActiveJob::Base.queue_adapter = :que

unless defined?(Rails::Console)
  if Rails.env.production? || Rails.env.staging?
    Que.wake_interval = 1
  end
  Que.mode = :async
end
