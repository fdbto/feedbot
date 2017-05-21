json.extract! feed_article, :id, :feed_id, :guid, :published_at, :data, :created_at, :updated_at
json.url feed_article_url(feed_article, format: :json)
