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
        self.data[key] = feed.send(key) if feed.respond_to?(key)
      end
    end
  end
  concerning :CrawlFeature do
    included do
      scope :crawlable, -> now = nil {
        now ||= Time.zone.now
        where('will_crawled_at >= ?', now)
      }
    end
    def crawl(force = false)
      self.will_crawled_at = nil if force
      return [] if self.will_crawled_at < UTC.now
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
  end

  concerning :AvatarFeature do
    included do
      mount_uploader :avatar, AvatarUploader
    end
  end

  concerning :BotFeature do
    included do
      has_one :bot, dependent: :destroy, class_name: 'FeedBot'
    end
    def create_bot_from_feed
      self.bot ||= FeedBot.create username: self.slug
    end
  end
end
