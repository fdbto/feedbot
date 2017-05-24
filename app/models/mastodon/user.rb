class Mastodon::User
  def self.username_exist?(username)
    command = <<EOL
Account.where(username: #{q(username)}).exists?
EOL
    RemoteCommandRunner.run(command)
  end

  def self.create(params = {})
    params = params.slice(:username, :display_name, :note, :url, :avatar_url)
    email = Devise.friendly_token(32) + '@bot.feedbot.ch'
    password = Devise.friendly_token(64)
    command = <<EOL
params = { account_attributes: {
             username: #{q(params[:username])},
             display_name: #{q(params[:display_name])},
             note: #{q(params[:note])},
             url: #{q(params[:url])}
           },
           email: #{q(email)}, password: #{q(password)},
           confirmed_at: Time.zone.now
         }
params[:account_attributes][:avatar] = URI.parse(#{q(params[:avatar_url])}) if #{q(params[:avatar_url])}.present?
user = User.create params
{ user: user, account: user.account }
EOL
    RemoteCommandRunner.run(command)
  end

  def self.toot(username, text)
    command = <<EOL
account = Account.find_by(username: #{q(username)})
return false if account.blank?    
PostStatusService.new.call(account, #{q(text)})
EOL
    RemoteCommandRunner.run(command)
  end

  def self.q(value)
    "%q*#{value.to_s.gsub(/\*/, '\*')}*"
  end
end
