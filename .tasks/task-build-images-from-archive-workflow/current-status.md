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

### 4.3 Push-triggered Actions run
Status: failed.

Run: `25541524895`.
Event: `push`.
Failure: runtime image build failed at `npm install -g` with `EACCES` for `/usr/local/lib/node_modules/@playwright`.

## 5. Remediation

### 5.1 npm prefix fix
Status: in_progress.

Change runtime Dockerfile to install Node Playwright packages under `/home/daytona/.local` and include `/home/daytona/.local/lib/node_modules` in `NODE_PATH`.
