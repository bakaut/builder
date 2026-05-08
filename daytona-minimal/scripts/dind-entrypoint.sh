#!/usr/bin/env bash
set -euo pipefail

if [[ "${START_DOCKERD:-1}" == "1" ]]; then
  sudo mkdir -p /var/lib/docker /var/run

  # Must run the container with --privileged for real DinD.
  sudo dockerd \
    --host=unix:///var/run/docker.sock \
    --storage-driver="${DOCKER_DRIVER:-overlay2}" \
    > /tmp/dockerd.log 2>&1 &

  for _ in $(seq 1 60); do
    if docker info >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  if ! docker info >/dev/null 2>&1; then
    echo "dockerd did not become ready" >&2
    tail -200 /tmp/dockerd.log >&2 || true
    exit 1
  fi
fi

exec "$@"
