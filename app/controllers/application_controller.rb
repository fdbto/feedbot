class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  concerning :SslFeature do
    included do
      force_ssl if: :use_ssl?
    end
    private
    def use_ssl?
      Rails.env.production?
    end
  end
end
