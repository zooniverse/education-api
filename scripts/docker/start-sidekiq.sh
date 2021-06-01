#!/bin/bash -ex

cd /app

mkdir -p tmp/pids/
rm -f tmp/pids/*.pid

exec bundle exec sidekiq -i 1 -C /app/config/sidekiq.yml
