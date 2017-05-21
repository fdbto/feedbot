json.extract! feed, :id, :user_id, :name, :url, :last_crawled_at, :data, :created_at, :updated_at
json.url feed_url(feed, format: :json)
