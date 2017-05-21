class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def mastodon
    @identity = Identity.from_auth request.env['omniauth.auth'], current_user
    @user = @identity.user
    if @identity.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Mastodon')
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.mastodon_data"] = request.env['omniauth.auth']
      redirect_to root_path, alert: 'Login failure.'
    end
  end
end
