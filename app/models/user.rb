class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  concerning :OmnituahtRegistrationFeature do
    class_methods do
      def find_for_oauth!(auth)
        user = User.where(uid: auth.uid, provider: auth.provider).first
        return user if user.present?
        User.create!(
            uid: auth.uid,
            provider: auth.provider,
            email: auth.uid,
            password: Devise.friendly_token[0, 64]
        )
      end
    end
  end
end
