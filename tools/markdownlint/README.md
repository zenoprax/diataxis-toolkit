# markdownlint-cli2

markdownlint-cli2 checks Markdown structure for the toolkit's QC checks.
It runs the markdownlint rule set through the Node CLI.
Install it into a user-level prefix with the steps in [install-markdownlint.md](../../docs/public/how-to/install-markdownlint.md).

## Configuration

[.markdownlint-cli2.jsonc](.markdownlint-cli2.jsonc) is JSON with comments and records the repository's text-line conventions.
The toolkit disables line-length enforcement, because its style fixes sentence length rather than line length.
It also keeps a front matter `title` from counting as a top-level heading.

## Run

```bash
markdownlint-cli2 --config tools/markdownlint/.markdownlint-cli2.jsonc \
  'docs/public/**/*.md'
```

Pass the tool-local config explicitly; nothing is auto-discovered outside the tool directory.

## Alerting

The exit code is `0` when clean and `1` when findings exist.
Findings block the Markdown QC checks.
The tool prints each finding as `file:line:column severity ruleID message`, then a summary line.
Quote the glob so the shell does not expand it, and pass explicit files for manifest-scoped runs.
A path with no Markdown files exits `0` with `Summary: 0 issues in 0 files`.
