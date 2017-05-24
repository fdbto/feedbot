class CreateCronJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :cron_jobs do |t|
      t.string :name, null: false
      t.string :schedule
      t.string :command
      t.datetime :next_run_at
      t.boolean :enabled, default: true
      t.text :description

      t.timestamps
    end
    add_index :cron_jobs, :name, unique: true
    add_index :cron_jobs, :created_at
    add_index :cron_jobs, :updated_at
    add_index :cron_jobs, :next_run_at
    add_index :cron_jobs, :enabled
  end
end
