class FeedCrawlingJob < ApplicationJob
  queue_as :default

  def perform(feed_id)
    feed = Feed.find_by(id: feed_id)
    if feed.present?
      feed.crawl_and_notify
    end
  end
end
