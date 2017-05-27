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
          note: self.description.to_s[0,160],
          url: self.url
      }
      params[:avatar_url] = self.feed.avatar.url(:thumb) if self.feed.avatar.present?
      r = Mastodon::User.create params
      follow_bot
      throw :abort if r[:response].status != 200
    end
    private
    def follow_bot
      return nil unless self.feed.follow_bot
      identity = feed.user.identities.mastodon.first
      identity.client.remote_follow "#{self.username}@fdb.to"
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
      title = entry.title_text
      url = entry.url || entry.links.try(:first)
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
