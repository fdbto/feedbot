class User < ApplicationRecord
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

  concerning :RecentOrderFeature do
    included do
      scope :recently_created, -> { order('created_at desc') }
      scope :recently_updated, -> { order('updated_at desc') }
    end
  end
end
