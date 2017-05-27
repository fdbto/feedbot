class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :feed, foreign_key: true, index: true
      t.string :secret
      t.string :hub
      t.boolean :subscribed, default: false
      t.timestamps
    end
    add_index :subscriptions, :subscribed
    add_index :subscriptions, :created_at
    add_index :subscriptions, :updated_at
  end
end
