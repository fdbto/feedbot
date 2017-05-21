#!/bin/ash

bundle exec rake db:migrate
# bundle exec sidekiq -d -P tmp/pids/sidekiq.pid -L log/sidekiq.log
bundle exec rails server -p 3000 -b 0.0.0.0
# bundle exec sidekiqctl stop tmp/pids/sidekiq.pid

