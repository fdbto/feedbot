class AddLastPostedAtToFeed < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :last_posted_at, :datetime
    add_index :feeds, :last_posted_at
  end
end
