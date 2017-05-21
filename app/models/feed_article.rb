class FeedArticle < ActiveRecord::Base
  belongs_to :feed
  concerning :KeyFields do
    included do
      store_accessor :data, :entry_id, :published
      before_save :fill_key_fields
      scope :guid, -> guid { where(guid: guid) }
    end
    class_methods do
      def create_from_entry!(entry)
        instance = new
        entry.each do |key, value|
          instance.data[key] = value
        end
        instance.save!
        instance
      end
    end
    def params=(params)
      params.each do |key, value|
        self.data[key] = value
      end
    end
    private
    def fill_key_fields
      sel
      f.guid = self.entry_id
      self.published_at = self.published
    end
  end

  concerning :DataAccessorFeature do
    included do
      store_accessor :data, :title, :summary, :content, :url
    end
  end

  concerning :PublishFeature do
    def publish
      feed.bot.toot title: self.title,
      	description: self.description,
        url: srlf.url
    end
  end
end
