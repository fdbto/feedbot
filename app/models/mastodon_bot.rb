=begin
class MadtodonBot < ApplicationRecord
  concerning :ConnectionFeature do
    def toot(params)
      content = format_params params
      command.exec :toot, content
      Notification.article_tooted params
    end
    private
    def format_params(params)
    end
  end
end
=end
