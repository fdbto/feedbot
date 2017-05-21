class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.jsonb :data, default: {}

      t.timestamps
    end
    add_index :identities, [:provider, :uid], unique: true
    add_index :identities, :data, using: :gin
  end
end
