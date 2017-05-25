class ClockController < ApplicationController
  protect_from_forgery except: :tick
  before_action :verify_authorized_access
  def tick
    TickCronJob.perform_later
    render text: 'tack'
  end
  private
  def verify_authorized_access
    authorization_token = request.headers['Authorization-Token']
    raise "Authorization Token not match. param:#{authorization_token}" unless authorization_token ==
        ENV['CLOCK_TICK_AUTHORIZATION_TOKEN']
  end
end
