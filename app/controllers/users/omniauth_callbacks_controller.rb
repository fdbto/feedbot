class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def mastodon
    @user = User.find_for_oauth!(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Mastodon')
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.mastodon_data"] = request.env['omniauth.auth']
      redirect_to root_path, alert: 'Login failure.'
    end
  end
end
