class CreateFeedBots < ActiveRecord::Migration[5.1]
  def change
    create_table :feed_bots do |t|
      t.references :feed, foreign_key: true, index: true
      t.string :username, null: false
      t.jsonb :data, default: {}

      t.timestamps
    end
    add_index :feed_bots, :username, unique: true
    add_index :feed_bots, :data, using: :gin
    add_index :feed_bots, :created_at
    add_index :feed_bots, :updated_at
  end
end
