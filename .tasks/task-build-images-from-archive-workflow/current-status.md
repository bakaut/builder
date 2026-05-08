# Current status: task-build-images-from-archive-workflow

## 1. Target repository

### 1.1 Repository switch
Status: completed.

Target repository is `bakaut/builder`.

### 1.2 Publication method
Status: completed.

Publication uses gateway-side GitHub commit creation, not sandbox push.

### 1.3 Trigger method
Status: completed.

Workflow is configured to run from a `push` event to `main` or `chatgpt/**`. Manual `workflow_dispatch` is intentionally not used for this slice.

## 2. Test-first contract

### 2.1 Acceptance criteria
Status: completed.

- A commit pushed to `chatgpt/build-daytona-minimal-images` triggers `.github/workflows/daytona-minimal-images.yml`.
- Workflow builds the runtime image from `daytona-minimal/Dockerfile.runtime`.
- Workflow runs `smoke-runtime`.
- Workflow builds the DinD image from `daytona-minimal/Dockerfile.dind` using the runtime image as `BASE_IMAGE`.
- Workflow runs `smoke-dind`.
- Workflow fails on missing Dockerfiles, missing scripts, failed build, or failed smoke.

### 2.2 Test inventory
Status: completed.

- Static archive structure check.
- Workflow YAML parse check.
- Workflow path reference check.
- Dockerfile-to-script reference check.
- GitHub Actions runtime build/smoke check on push.

## 3. Static validation

### 3.1 Archive structure
Status: completed.

Expected files are present under `daytona-minimal/`.

### 3.2 Workflow syntax
Status: completed.

Workflow YAML parses, and the top-level `on` key is quoted for YAML 1.1 compatibility.

### 3.3 Path references
Status: completed.

Workflow and Dockerfiles reference existing package paths.

## 4. GitHub publication

### 4.1 Branch
Status: completed.

Branch: `chatgpt/build-daytona-minimal-images`.

### 4.2 Initial commit
Status: completed.

Commit: `45c056fedecd9a2144708a6d9ce828b8691afcd9`.

### 4.3 Push-triggered Actions run 1
Status: failed.

Run: `25541524895`.
Event: `push`.
Failure: runtime image build failed at `npm install -g` with `EACCES` for `/usr/local/lib/node_modules/@playwright`.

### 4.4 Remediation commit 1
Status: completed.

Commit: `083cb36a1524ef884bd6404b6a3b538e320d4bf4`.
Change: install npm global packages under `/home/daytona/.local` and include `/home/daytona/.local/lib/node_modules` in `NODE_PATH`.

### 4.5 Push-triggered Actions run 2
Status: failed.

Run: `25541664268`.
Event: `push`.
Failure: Python Playwright and Node Playwright both attempted to own `/home/daytona/.local/bin/playwright`, causing npm `EEXIST`.

### 4.6 Remediation commit 2
Status: completed.

Commit: `d6da1f76ac61d99ece33f5ace3923453d23e3914`.
Change: keep Python Playwright package, remove only its CLI wrapper before installing Node Playwright CLI/test runner.

### 4.7 Push-triggered Actions run 3
Status: failed.

Run: `25541792748`.
Event: `push`.
Result: runtime image build passed and `smoke-runtime` passed. DinD build failed because buildx with the docker-container driver did not see the local `daytona-runtime:ci` image and tried to pull `docker.io/library/daytona-runtime:ci`.

### 4.8 Remediation commit 3
Status: completed.

Commit: `d9c897a95c8e7783180a3a286a62332394658229`.
Change: switched both builds to local `DOCKER_BUILDKIT=1 docker build`.

### 4.9 Push-triggered Actions run 4
Status: failed.

Run: `25541997145`.
Event: `push`.
Failure: local Docker build made runtime build-time Chromium/Playwright smoke unstable; Chromium exited with `SIGSEGV` during Python Playwright launch.

### 4.10 Remediation commit 4
Status: completed.

Commit: `3e50106079131f5ba7132ea8aedfedced5e3ad84`.
Change: split builder strategy. Runtime image builds with `docker buildx build --load`; DinD image builds with local `DOCKER_BUILDKIT=1 docker build` so it can use the local `daytona-runtime:ci` base image.

### 4.11 Push-triggered Actions run 5
Status: completed.

Run: `25542143570`.
Event: `push`.
Head SHA: `3e50106079131f5ba7132ea8aedfedced5e3ad84`.
Conclusion: `success`.

Successful steps:
- `Build runtime image`
- `Smoke runtime image`
- `Build DinD image`
- `Smoke DinD image`

## 5. Remediation

### 5.1 npm prefix fix
Status: completed.

### 5.2 Playwright CLI collision fix
Status: completed.

### 5.3 Local runtime image visibility fix
Status: revised.

Full local Docker build fixed DinD base visibility but regressed runtime smoke stability.

### 5.4 Split builder strategy
Status: completed.

Use `docker buildx build --load` for the runtime image, which builds and smoke-tests successfully, then use local `DOCKER_BUILDKIT=1 docker build` only for the DinD image so `FROM daytona-runtime:ci` resolves from the runner local image store.

## 6. Readiness

### 6.1 Current readiness
Status: ready for review.

The branch has a push-triggered workflow that has successfully built and smoke-tested both runtime and DinD images in GitHub Actions.

### 6.2 Remaining risks
Status: tracked.

- Workflow currently targets `linux/amd64` only.
- The workflow includes `pull_request` trigger in addition to `push`; manual `workflow_dispatch` is not used.

## 7. Publish linux/amd64 images

### 7.1 Publish target
Status: completed.

Registry target is GHCR.

Runtime image target:
- `ghcr.io/bakaut/daytona-runtime`

DinD image target:
- `ghcr.io/bakaut/daytona-runtime-dind`

### 7.2 Publish tag contract
Status: completed.

For each image, the workflow publishes linux/amd64 tags:
- `linux-amd64`
- `sha-<12-char-sha>-linux-amd64`
- `<sanitized-branch-name>-linux-amd64`

For branch `chatgpt/build-daytona-minimal-images`, the branch tag suffix is:
- `chatgpt-build-daytona-minimal-images-linux-amd64`

### 7.3 Workflow publish update
Status: completed.

Commit: `b022f0d8432a46edafa9fba188549796d0d24b3a`.

Workflow now performs:
- build runtime image
- smoke runtime image
- build DinD image
- smoke DinD image
- GHCR login
- push linux/amd64 tags
- remote tag verification with `docker buildx imagetools inspect`

### 7.4 Push-triggered publish run
Status: completed.

Run: `25542767976`.
Event: `push`.
Head SHA: `b022f0d8432a46edafa9fba188549796d0d24b3a`.
Conclusion: `success`.

Successful publish run steps:
- `Build runtime image`
- `Smoke runtime image`
- `Build DinD image`
- `Smoke DinD image`
- `Login to GHCR`
- `Push linux/amd64 image tags`
- `Verify published image tags`

### 7.5 Published tags
Status: completed.

Runtime image tags:
- `ghcr.io/bakaut/daytona-runtime:linux-amd64`
- `ghcr.io/bakaut/daytona-runtime:sha-b022f0d8432a-linux-amd64`
- `ghcr.io/bakaut/daytona-runtime:chatgpt-build-daytona-minimal-images-linux-amd64`

DinD image tags:
- `ghcr.io/bakaut/daytona-runtime-dind:linux-amd64`
- `ghcr.io/bakaut/daytona-runtime-dind:sha-b022f0d8432a-linux-amd64`
- `ghcr.io/bakaut/daytona-runtime-dind:chatgpt-build-daytona-minimal-images-linux-amd64`

## 8. Daytona sandbox runtime compatibility

### 8.1 Failure report
Status: received.

Reported sandbox startup failure:
- `Sandbox failed to start: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error mounting "/usr/local/bin/.tmp/binaries/daytona-computer-use" to rootfs ...`

### 8.2 Contract update
Status: completed.

The runtime image must precreate Daytona helper binary mountpoints before the sandbox user process starts:
- `/usr/local/bin/.tmp`
- `/usr/local/bin/.tmp/binaries`
- `/usr/local/bin/.tmp/binaries/daytona-computer-use`

### 8.3 Implementation
Status: completed.

Commit: `d6f1b91c6f90e82a5f615cbf7cce449138630103`.

`Dockerfile.runtime` precreates the mountpoint directory and placeholder file. `smoke-runtime.sh` asserts those paths exist and are writable before browser checks.

### 8.4 Push-triggered validation run
Status: completed.

Run: `25544206782`.
Event: `push`.
Head SHA: `d6f1b91c6f90e82a5f615cbf7cce449138630103`.
Conclusion: `success`.

Successful validation steps:
- `Build runtime image`
- `Smoke runtime image`
- `Build DinD image`
- `Smoke DinD image`
- `Login to GHCR`
- `Push linux/amd64 image tags`
- `Verify published image tags`

### 8.5 Published tags after mountpoint fix
Status: completed.

Runtime image tags:
- `ghcr.io/bakaut/daytona-runtime:linux-amd64`
- `ghcr.io/bakaut/daytona-runtime:sha-d6f1b91c6f90-linux-amd64`
- `ghcr.io/bakaut/daytona-runtime:chatgpt-build-daytona-minimal-images-linux-amd64`

DinD image tags:
- `ghcr.io/bakaut/daytona-runtime-dind:linux-amd64`
- `ghcr.io/bakaut/daytona-runtime-dind:sha-d6f1b91c6f90-linux-amd64`
- `ghcr.io/bakaut/daytona-runtime-dind:chatgpt-build-daytona-minimal-images-linux-amd64`

## 9. Final readiness

### 9.1 Current readiness
Status: ready for Daytona runtime verification.

The branch has a push-triggered workflow that successfully builds, smoke-tests, publishes, and verifies linux/amd64 runtime and DinD image tags in GHCR after adding the Daytona helper binary mountpoint contract.

### 9.2 Remaining risks
Status: tracked.

- CI verifies the image-side mountpoint contract, but the real Daytona host mount source and final destination are controlled by Daytona runtime.
- If Daytona mounts a directory instead of a file at the same path, a separate adjustment may be required.
- Multi-arch publishing is not included; this slice publishes linux/amd64 only.
- Tag `linux-amd64` is mutable and points to the latest successful push on the branch or main.
