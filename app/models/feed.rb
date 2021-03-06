class Feed < ApplicationRecord
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
    def hub
      self.hubs.present? ? self.hubs[0] : nil
    end
    private
    def set_keys_from(feed)
      FEED_KEYS.each do |key|
        self.send("#{key}=", feed.send(key)) if feed.respond_to?(key)
      end
    end
  end
  concerning :FeedProcessingFeature do
    included do
      scope :crawlable, -> now = nil {
        now ||= Time.zone.now
        where.not(will_crawled_at: nil).
        where('will_crawled_at <= ?', now)
      }
      before_create :set_will_crawled_at
      after_create_commit :run_initial_crawl
    end
    class_methods do
      def crawl_and_notify_all
        self.find_each do |feed|
          feed.send_later(:crawl_and_notify)
        end
      end
    end
    def initial_crawl_and_notify
      crawl_and_notify
      prepare_subscription
    end
    def crawl_and_notify
      Feed.with_advisory_lock "Feed(#{self.id})", timeout_seconds: 0 do
        entries = crawl
        process_entries_and_notify(entries)
      end
    end
    def receive_and_notify(raw_data)
      entries = receive_raw(raw_data)
      process_entries_and_notify(entries)
    end
    def crawl
      feed = Feedjira::Feed.fetch_and_parse self.url
      set_keys_from(feed)
      self.last_crawled_at = UTC.now
      set_next_crawl_time(self.last_crawled_at)
      self.save!
      collect_new_entries(feed)
    end
    def receive_raw(raw_data)
      feed = Feedjira::Feed.parse raw_data
      set_keys_from(feed)
      self.last_crawled_at = UTC.now
      self.save!
      collect_new_entries(feed)
    end
    def notify_entries(entries)
      self.bot.notify_entries(entries)
      self.update!(last_posted_at: UTC.now) if entries.present?
    end
    private
    def prepare_subscription
      return false unless self.hub.present?
      return false unless self.subscription.blank?
      self.create_subscription.register!
      Feed.transaction do
        self.will_crawled_at = nil
        self.save!
      end
    end
    def process_entries_and_notify(entries)
      if self.bot.present?
        notify_entries(entries)
      else
        create_bot_from_feed
        self.bot.toot("Hi, @#{self.user.email}, \nI was born to love you! \u{1f600}")
        notify_entries([entries.last]) if entries.present?
      end
    end
    def run_initial_crawl
      send_later(:initial_crawl_and_notify)
    end
    def set_will_crawled_at
      self.will_crawled_at = Time.zone.now
    end
    def set_next_crawl_time(now)
      interval = (5 + rand(10)).minutes
      self.will_crawled_at = now + interval # set randomly 5 ~ 15 min interval.
    end
    def collect_new_entries(feed)
      new_entries = []
      entry_ids = feed.entries.map(&:id)
      guid2article = self.articles.where(guid: entry_ids).select('id, guid').index_by(&:guid)
      feed.entries.each do |entry|
        if guid2article[entry.id].blank?
          new_entries << self.articles.create_from_entry!(entry)
        end
      end
      new_entries.sort { |a,b| a.published_at <=> b.published_at }
    end
  end

  concerning :AvatarFeature do
    included do
      mount_uploader :avatar, AvatarUploader
    end
    def thumb_avatar_with_default
      self.avatar.present? ? self.avatar.url(:thumb) : sample_image_url
    end
    private
    def sample_image_url
      if self.id.present?
        m = self.id % 21
      else
        m = rand(21)
      end
      image_url(sprintf('sample-%03d.jpg', m))
    end
    def image_url(name)
      raise unless ENV['CW_CDN_HOST'].present?
      "#{ENV['CW_CDN_HOST']}/system/#{name}"
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

  concerning :SubscriptionFeature do
    included do
      has_one :subscription, dependent: :destroy
    end
  end

  concerning :FollowFeature do
    included do
      store_accessor :data, :follow_bot
    end
    def follow_bot_form
      self.follow_bot
    end
    def follow_bot_form=(value)
      self.follow_bot = booleanize(value)
    end
  end

  concerning :SortFeature do
    included do
      scope :recently_posted, -> { where.not(last_posted_at: nil).order(last_posted_at: :desc) }
    end
  end

  concerning :PermissionFeature do
    included do
      scope :in_public, -> { where(private: false) }
      scope :in_private, -> { where(private: true) }
    end
  end
end
