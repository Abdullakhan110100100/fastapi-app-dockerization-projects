#!/bin/sh

# Get host and port from first argument
hostport="$1"
shift  # Remove first argument

# Split host and port
host=$(echo "$hostport" | cut -d : -f 1)
port=$(echo "$hostport" | cut -d : -f 2)

# Wait for the port to be available
until nc -z "$host" "$port"; do
  >&2 echo "Waiting for $host:$port..."
  sleep 1
done

>&2 echo "$host:$port is available - executing command"
exec "$@"