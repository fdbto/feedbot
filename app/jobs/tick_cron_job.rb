class TickCronJob < ApplicationJob
  def perform
    CronJob.tick!
  end
end
