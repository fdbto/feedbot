class FeedBot < ApplicationRecord

  concerning :BasicFeature do
    included do
      belongs_to :feed
      delegate :title, :description, :url, to: :feed
    end
  end

  concerning :LinkToMastodonFeature do
    included do
      after_create :link_to_mastodon
    end
    private
    def link_to_mastodon
      r = Mastodon::User.create username: self.username,
                            display_name: self.title,
                            note: self.description,
                            url: self.url,
                            avatar_url: self.feed.avatar.url(:thumb)
      throw :abort if r[:response].status != 200
    end
  end
end
