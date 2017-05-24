class RootController < ApplicationController
  def index
    redirect_to home_path if user_signed_in?
  end
  def home
    redirect_to root_path unless user_signed_in?
    @feeds = current_user.feeds.recently_created.limit(5)
  end
end
