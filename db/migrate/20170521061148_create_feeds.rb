class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.references :user, foreign_key: true, index: true
      t.string :slug, null: false
      t.string :url, null: false
      t.string :avatar
      t.boolean :verified, default: false
      t.datetime :last_crawled_at
      t.datetime :will_crawled_at
      t.jsonb :data, default: {}

      t.timestamps
    end
    add_index :feeds, :slug, unique: true
    add_index :feeds, :url, unique: true
    add_index :feeds, :verified
    add_index :feeds, :last_crawled_at
    add_index :feeds, :will_crawled_at
    add_index :feeds, :data, using: :gin
    add_index :feeds, :created_at
    add_index :feeds, :updated_at
  end
end
