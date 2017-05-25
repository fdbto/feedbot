class Feed < ActiveRecord::Base
  include TimeScope

  belongs_to :user

  concerning :BasicFeature do
    included do
      has_many :articles, -> { order('published_at desc') },
               class_name: 'FeedArticle', dependent: :delete_all
      scope :slug, -> slug { where(slug: slug) }
    end
  end

  concerning :FeedKeysFeature do
    included do
      FEED_KEYS = %i(version title description hubs)
      store_accessor :data, *FEED_KEYS
    end
    private
    def set_keys_from(feed)
      FEED_KEYS.each do |key|
        self.send("#{key}=", feed.send(key)) if feed.respond_to?(key)
      end
    end
  end
  concerning :CrawlFeature do
    included do
      scope :crawlable, -> now = nil {
        now ||= Time.zone.now
        where('will_crawled_at <= ?', now)
      }
      after_create_commit :run_initial_crawl
    end
    class_methods do
      def crawl_and_notify_all
        self.find_each do |feed|
          FeedCrawlingJob.perform_later(feed.id)
        end
      end
    end
    def crawl_and_notify
      Feed.with_advisory_lock "Feed(#{self.id})", timeout_seconds: 0 do
        if self.bot.present?
          entries = crawl
          notify_entries(entries)
        else
          entries = crawl
          self.bot.toot("Hi, @#{self.user.email}, \nI was born to love you! :smile:")
          notify_entries([entries.last]) if entries.present?
        end
      end
    end
    def crawl(force = false)
      self.will_crawled_at = nil if force
      return [] unless do_crawl?
      feed = Feedjira::Feed.fetch_and_parse self.url
      set_keys_from(feed)
      create_bot_from_feed if self.bot.blank?
      created_entries = []
      feed.entries.each do |entry|
        unless self.articles.guid(entry.id).first
          created_entries << self.articles.guid(entry.id).create_from_entry!(entry)
        end
      end
      self.last_crawled_at = UTC.now
      interval = (5 + rand(10)).minutes
      self.will_crawled_at = self.last_crawled_at + interval # set randomly 5 ~ 15 min interval.
      self.save!
      created_entries.sort { |a,b| a.published_at <=> b.published_at }
    end
    def notify_entries(entries)
      self.bot.notify_entries(entries)
    end
    private
    def run_initial_crawl
      FeedCrawlingJob.perform_later(self.id)
    end
    def do_crawl?
      return true if self.will_crawled_at.blank? # initial state
      self.will_crawled_at < UTC.now # crawling time comes?
    end
  end

  concerning :AvatarFeature do
    included do
      mount_uploader :avatar, AvatarUploader
    end
  end

  concerning :BotFeature do
    included do
      has_one :bot, dependent: :destroy, class_name: 'FeedBot'
      validates :slug, presence: true, length: { maximum: 30 }
    end
    def create_bot_from_feed
      self.bot ||= FeedBot.create username: self.slug
    end
  end
end
