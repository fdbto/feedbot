class FeedArticle < ApplicationRecord
  belongs_to :feed
  concerning :KeyFields do
    included do
      scope :guid, -> guid { where(guid: guid) }
    end
    class_methods do
      def create_from_entry!(entry)
        instance = new
        instance.data = entry.to_h
        instance.send :fill_key_fields, guid: entry.id, published_at: entry.published
        instance.save!
        instance
      end
    end
    private
    def fill_key_fields(params = {})
      self.guid = params[:guid]
      self.published_at = params[:published_at]
    end
  end

  concerning :DataAccessorFeature do
    included do
      store_accessor :data, :title, :summary, :content, :url, :links
    end
    def content_text
      @content_text ||= clean_text_with_html(self.content)
    end
    def title_text
      @title_text ||= clean_text_with_html(self.title)
    end
    private
    def clean_text_with_html(text)
      Nokogiri::HTML(text).text.
        gsub(/\n/, ' ').
        gsub(/^\s+/, '').gsub(/\s+$/, '').
        gsub(/\s{2,}/, ' ')
    end
  end
end
