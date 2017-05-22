class HealthCheckController < ApplicationController
  def index
    render text: User.order(:id).limit(1).pluck(:id)[0].to_s
  end
  def use_ssl?
    false
  end
end
