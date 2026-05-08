# Daytona minimal runtime images

## Runtime image

```bash
docker buildx build \
  --platform linux/amd64 \
  -t daytona-runtime:local \
  -f Dockerfile.runtime .
```

Smoke check is already executed at build time, but can be repeated:

```bash
docker run --rm daytona-runtime:local smoke-runtime
```

## DinD e2e image

```bash
docker buildx build \
  --platform linux/amd64 \
  --build-arg BASE_IMAGE=daytona-runtime:local \
  -t daytona-runtime-dind:local \
  -f Dockerfile.dind .
```

Run privileged DinD smoke:

```bash
docker run --rm --privileged daytona-runtime-dind:local smoke-dind
```

Run against host Docker socket instead of inner dockerd:

```bash
docker run --rm \
  -e START_DOCKERD=0 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  daytona-runtime-dind:local smoke-dind
```
