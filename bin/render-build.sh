#!/usr/bin/env bash
# エラーが出たら、そこで止める
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate
