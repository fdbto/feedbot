class Identity < ApplicationRecord
  belongs_to :user

  concerning :OmnituahtRegistrationFeature do
    class_methods do
      def from_auth(auth, user)
        identity = self.where(provider: auth.provider, uid: auth.uid).first
        if user.present?
          if identity.present?
            raise "user:#{user.id} it not match for identity.user.id=#{identity.user_id}" unless user == identity.user
            identity
          else
            user.identities.create provider: auth.provider, uid: auth.uid, data: auth
          end
        else
          if identity.present?
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
end
