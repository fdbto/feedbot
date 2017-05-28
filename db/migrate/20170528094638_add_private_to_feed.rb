class AddPrivateToFeed < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :private, :boolean, default: false
    add_index :feeds, :private
  end
end
