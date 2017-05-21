class CreateMastodonClients < ActiveRecord::Migration[5.1]
  def change
    create_table :mastodon_clients do |t|
      t.string :domain, null: false
      t.string :client_id, null: false
      t.string :client_secret, null: false

      t.timestamps
    end
    add_index :mastodon_clients, :domain, unique: true
    add_index :mastodon_clients, :created_at
    add_index :mastodon_clients, :updated_at
  end
end
