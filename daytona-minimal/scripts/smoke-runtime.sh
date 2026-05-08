#!/usr/bin/env bash
set -euo pipefail

python --version
python -m pip --version
uv --version
pytest --version
node --version
npm --version
npx playwright --version
go version
chromium --version
bash -lc 'nvm --version'

# Daytona injects helper binaries before sandbox user process startup. The OCI
# runtime requires the target path to exist in the image rootfs for stable file
# bind mounts.
test -d /usr/local/bin/.tmp
test -d /usr/local/bin/.tmp/binaries
test -f /usr/local/bin/.tmp/binaries/daytona-computer-use
test -w /usr/local/bin/.tmp/binaries

chromium \
  --headless=new \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --dump-dom 'data:text/html,<html><body>chromium-ok</body></html>' \
  | grep -q 'chromium-ok'

python - <<'PY'
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(
        executable_path="/usr/bin/chromium",
        headless=True,
        args=["--no-sandbox", "--disable-dev-shm-usage"],
    )
    page = browser.new_page()
    page.set_content("<html><body><h1>playwright-python-ok</h1></body></html>")
    assert "playwright-python-ok" in page.text_content("body")
    browser.close()
PY

node - <<'JS'
const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({
    executablePath: '/usr/bin/chromium',
    headless: true,
    args: ['--no-sandbox', '--disable-dev-shm-usage'],
  });
  const page = await browser.newPage();
  await page.setContent('<html><body><h1>playwright-node-ok</h1></body></html>');
  const text = await page.textContent('body');
  if (!text.includes('playwright-node-ok')) throw new Error('Node Playwright smoke failed');
  await browser.close();
})();
JS
