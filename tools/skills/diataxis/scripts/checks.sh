#!/usr/bin/env bash
set -u

export PATH="$HOME/.local/bin:$PATH"

status=0

vale --config tools/vale/.vale.ini --minAlertLevel suggestion --glob='!**/voice/**' docs/public || status=1
markdownlint-cli2 --config tools/markdownlint/.markdownlint-cli2.jsonc 'docs/public/**/*.md' || status=1
python3 tools/skills/diataxis/scripts/frontmatter.py docs/public || status=1
python3 tools/skills/diataxis/scripts/visual.py . || status=1
lychee --no-progress --config tools/lychee/lychee.toml 'docs/public/**/*.md' || status=1

exit "$status"
