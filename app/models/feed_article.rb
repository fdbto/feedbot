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
      self.guid = self.entry_id
      self.published_at = self.published
    end
  end

  concerning :DataAccessorFeature do
    included do
      store_accessor :data, :title, :summary, :content, :url
    end
    def content_text
      @content_text ||= begin
        Nokogiri::HTML(self.content).text.
          gsub(/\n/, ' ').
          gsub(/^\s+/, '').gsub(/\s+$/, '').
          gsub(/\s{2,}/, ' ')
      end
    end
  end
end
