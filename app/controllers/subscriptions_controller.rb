class SubscriptionsController < ApplicationController
  protect_from_forgery except: %w(webhook)
  before_action :verify_admin, only: %w(index)
  before_action :set_subscription, only: [:webhook]

  concerning :WebhookFeature do
    def webhook
      if request.get?
        verify_registration
      elsif request.post?
        receive_notification
      end
    end

    private
    def verify_registration
      if @subscription.valid_params?(params)
        @subscription.toggle! :subscribed
        render plain: params['hub.challenge']
      else
        not_found
      end
    end
    def receive_notification
      body = request.raw_post
      signature = request.env['HTTP_X_HUB_SIGNATURE']
      if @subscription.verify_signature(body, signature)
        @subscription.feed.receive_raw(body)
      end
      head :no_content
    end
  end

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.recently_created.page(params[:page])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
