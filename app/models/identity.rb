class Identity < ApplicationRecord
  belongs_to :user

  concerning :OmnituahtRegistrationFeature do
    class_methods do
      def from_auth(auth, user)
        identity = self.where(provider: auth.provider, uid: auth.uid).first
        if user.present?
          if identity.present?
            raise "user:#{user.id} it not match for identity.user.id=#{identity.user_id}" unless user == identity.user
            identity.update! data: auth
            identity
          else
            user.identities.create provider: auth.provider, uid: auth.uid, data: auth
          end
        else
          if identity.present?
            identity.update! data: auth
            identity
          else
            Identity.create provider: auth.provider, uid: auth.uid, data: auth,
                             user: create_user_from_auth!(auth)
          end
        end
      end
      private
      def create_user_from_auth!(auth)
        user_params = begin
          case auth.provider
          when 'mastodon'
            user_params_from_mastodon!(auth)
          else raise "Unacceptable auth.provider=#{auth.provider}"
          end
        end
        User.create! user_params.merge(password: Devise.friendly_token(64))
      end
      def user_params_from_mastodon!(auth)
        { email: auth.uid }
      end
    end
  end

  concerning :ClientFeature do
    def client
      @client ||= send("#{self.provider}_client")
    end
  end
  concerning :MastodonFeature do
    included do
      scope :mastodon, -> { where(provider: 'mastodon') }
    end
    def mastodon_client
      uri = URI.parse(self.data.path('/info/urls/Profile'))
      base_url = "#{uri.scheme}://#{uri.host}"
      Mastodon::REST::Client.new base_url: base_url, bearer_token: self.data.path('/credentials/token')
    end
  end
end
