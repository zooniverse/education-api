#!/bin/bash -ex

cd /app

mkdir -p tmp/pids/
rm -f tmp/pids/*.pid

bin/rake db:migrate

exec bundle exec puma -C config/puma.rb
