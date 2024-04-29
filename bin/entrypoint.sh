#!/bin/bash -e

# If running the rails server then create or migrate existing database
if [ "${1}" == "./bin/rails" ] && [ "${2}" == "server" ]; then
  echo "Preparing database..."
  ./bin/rails db:migrate
fi

# Remove any existing server.pid to avoid startup issues
rm -f /rails/tmp/pids/server.pid

exec "${@}"
