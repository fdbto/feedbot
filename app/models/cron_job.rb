class CronJob < ActiveRecord::Base
  include TimeScope
  before_save :set_next_run_at

  scope :enabled, -> { where(enabled: true) }
  scope :runnable, -> now { where('next_run_at <= ?', now) }

  def active?
    self.enabled?
  end

  def self.tick!
    now = UTC.now + 3.seconds
    CronJob.with_advisory_lock 'CronJob#tick!', timeout_seconds: 0 do
      self.enabled.runnable(now).each do |cron|
        cron.run!
      end
    end
  end

  def parser
    return nil unless self.schedule.present?
    @parser ||= CronParser.new(self.schedule, Time.zone)
  end

  def run!
    eval self.command
    self.next_run_at = nil
    save!
  end

  private
  def set_next_run_at
    next_recently_time = self.parser.next(Time.zone.now)
    self.next_run_at ||= next_recently_time
  end
end
