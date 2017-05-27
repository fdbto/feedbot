class User < ApplicationRecord
  include TimeScope
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  concerning :IdentityRegistrationFeature do
    included do
      has_many :identities, dependent: :destroy
    end
  end

  concerning :FeedFeature do
    included do
      has_many :feeds, dependent: :destroy
    end
  end
end
