#!/usr/bin/env bash
set -euo pipefail

/usr/local/bin/smoke-runtime

docker version
docker info
docker buildx version
docker compose version

cat > /tmp/Dockerfile.e2e-smoke <<'DOCKERFILE'
FROM alpine:3.22
CMD ["sh", "-lc", "echo docker-e2e-ok"]
DOCKERFILE

docker build -t dind-e2e-smoke:local -f /tmp/Dockerfile.e2e-smoke /tmp
docker run --rm dind-e2e-smoke:local | grep -q 'docker-e2e-ok'
