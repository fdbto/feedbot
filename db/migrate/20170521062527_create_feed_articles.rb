class CreateFeedArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :feed_articles do |t|
      t.references :feed, foreign_key: true, index: true, null: false
      t.string :guid, null: false
      t.datetime :published_at, null: false
      t.jsonb :data, default: {}

      t.timestamps
    end
    add_index :feed_articles, [:feed_id, :guid], unique: true
    add_index :feed_articles, :published_at
    add_index :feed_articles, :created_at
    add_index :feed_articles, :updated_at
  end
end
