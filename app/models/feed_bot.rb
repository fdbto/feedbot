class FeedBot < ApplicationRecord

  concerning :BasicFeature do
    included do
      belongs_to :feed
      delegate :title, :description, :url, to: :feed
    end
  end

  concerning :LinkToMastodonFeature do
    included do
      after_create_commit :link_to_mastodon
    end
    private
    def link_to_mastodon
      Mastodon::User.create username: self.username,
                            display_name: self.title,
                            note: self.description,
                            url: self.url,
                            avatar_url: self.feed.avatar.url(:thumb)
    end
  end
end
