class Subscription < ApplicationRecord
  include Rails.application.routes.url_helpers
  include TimeScope
  concerning :BasicFeature do
    included do
      belongs_to :feed
      validates :feed_id, presence: true
      before_create :set_secret
    end
    private
    def set_secret
      self.secret = friendly_token(64)
    end
    def friendly_token(length)
      r_length = (length * 3) / 4
      SecureRandom.urlsafe_base64(r_length)
    end
  end

  concerning :PushFeature do
    included do
      before_create :verify_feed_has_hub, :copy_hub_from_feed
      before_destroy :unregister_subscription
    end
    def valid_params?(params)
      o2.valid?(params['hub.topic'])
    end
    def verify_signature(body, signature)
      o2.verify(body, signature)
    end
    def o2
      @o2 ||= begin
        OStatus2::Subscription.new(self.feed.url, secret: secret,
                                   webhook: webhook_subscription_url(self.id),
                                   hub: self.hub)
      end
    end
    def register!
      register_subscription
    end
    def unregister!
      unregister_subscription
    end
    private
    def verify_feed_has_hub
      throw :abort if self.feed.hub.blank?
    end
    def copy_hub_from_feed
      self.hub = self.feed.hub
    end
    def register_subscription
      o2.subscribe unless self.subscribed?
    end
    def unregister_subscription
      o2.unsubscribe if self.subscribed?
    end
  end
end
