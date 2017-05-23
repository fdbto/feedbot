class ClockController < ApplicationController
  before_action :verify_authorized_access
  def tick
    TickCronJob.perform_later
    render text: 'tack'
  end
  private
  def verify_authorized_access
    raise unless request.headers['Authorization-Token'] ==
        ENV['CLOCK_TICK_AUTHORIZATION_TOKEN']
  end
end
