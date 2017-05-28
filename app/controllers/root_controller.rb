class RootController < ApplicationController
  def index
    redirect_to home_path if user_signed_in?
    @recent_active_feeds = Feed.recently_posted.limit(5)
  end
  def home
    redirect_to root_path unless user_signed_in?
  end
end
