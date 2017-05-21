class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.references :user, foreign_key: true, index: true
      t.string :slug, null: false
      t.string :url, null: false
      t.datetime :last_crawled_at
      t.jsonb :data, default: {}

      t.timestamps
    end
    add_index :feeds, :slug, unique: true
    add_index :feeds, :url, unique: true
    add_index :feeds, :last_crawled_at
    add_index :feeds, :data, using: :gin
  end
end
