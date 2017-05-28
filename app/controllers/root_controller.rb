class RootController < ApplicationController
  def index
    @recent_active_feeds = Feed.in_public.recently_posted.limit(5)
  end
  def home
    if user_signed_in?
      @feeds = current_user.feeds.recently_created.page(params[:page])
    else
      redirect_to root_path
    end
  end
end
