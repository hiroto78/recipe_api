#!/bin/bash
set -e

cd /recipe_api

rm -f tmp/pids/server.pid

echo "The mode is ${MODE}."

bin/rails db:create RAILS_ENV=${MODE}
bin/rails db:migrate RAILS_ENV=${MODE}
bundle exec rails s -b '0.0.0.0' -e ${MODE}
