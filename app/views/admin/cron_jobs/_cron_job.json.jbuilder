json.extract! cron_job, :id, :name, :schedule, :command, :next_run_at, :enabled, :description, :created_at, :updated_at
json.url cron_job_url(cron_job, format: :json)
