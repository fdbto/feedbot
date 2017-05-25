class FeedBot < ApplicationRecord

  concerning :BasicFeature do
    included do
      belongs_to :feed
      delegate :title, :description, :url, to: :feed
    end
  end

  concerning :MastodonFeature do
    included do
      validates :username, presence: true, length: { maximum: 30 }
      after_create :link_to_mastodon
    end
    def toot(text)
      Mastodon::User.toot(self.username, text)
    end
    private
    def link_to_mastodon
      display_name = self.title[0,30]
      if self.feed.verified?
        display_name = display_name[0,28] + " \u2705"
      end
      params = {
          username: self.username,
          display_name: display_name,
          note: self.description[0,160],
          url: self.url
      }
      params[:avatar_url] = self.feed.avatar.url(:thumb) if self.feed.avatar.present?
      r = Mastodon::User.create params
      throw :abort if r[:response].status != 200
    end
  end

  concerning :NotificationFeature do
    def notify_entries(entries)
      entries.each do |entry|
        text = format_entry(entry)
        self.toot(text)
      end
    end
    def format_entry(entry)
      title = entry.title
      url = entry.url
      content_max_length = 500 - (title.length + url.length + 2)
      content = entry.content_text[0, content_max_length]
      text = <<EOL
#{title}
#{content}
#{url}
EOL
      text.chomp
    end
  end
end
