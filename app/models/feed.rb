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
    def crawl
      feed = Feedjira::Feed.fetch_and_parse self.url
      set_keys_from(feed)
      created_entries = []
      feed.entries.each do |entry|
        unless self.articles.guid(entry.id).first
          created_entries << self.articles.guid(entry.id).create_from_entry!(entry)
        end
      end
      self.last_crawled_at = UTC.now
      self.save!
      created_entries
    end
  end
  
  concerning :PublishFeature do
    included do
      has_one :bot, claa_name: 'MastodonBot',
      	dependent: :destroy
    end
    
    def publish!
      publisher.publish article
    end
  end
end
