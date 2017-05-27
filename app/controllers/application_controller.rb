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

  concerning :AdminFeature do
    def verify_admin
      throw :abort unless user_signed_in?
      throw :abort unless admin_emails.include?(current_user.email)
    end
    private
    def admin_emails
      ENV['ADMIN_EMAILS'].strip.split(/\s*,\s*/)
    end
  end

  concerning :NotFoundFeature do
    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
