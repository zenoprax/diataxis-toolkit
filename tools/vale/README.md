# Vale

Vale is the toolkit's prose and style checker.
It runs the Diátaxis quadrant styles, A11y, Harper, Inclusive, Plain, and Readability over `docs/public/`, and its errors are part of the blocking QC checks.
Install it into `~/.local/bin` with the [install Vale guide](../../docs/public/how-to/install-vale.md).

## Configuration

[.vale.ini](.vale.ini) sets `StylesPath = styles`, `MinAlertLevel = suggestion`, `Vocab = Project, Toolkit`, and `Packages = A11y, Diataxis, Harper`.
Styles live under [styles/](styles/).
Each quadrant section applies `Vale, A11y, Harper, signs-of-ai-writing, Inclusive, Plain`, its own style (`Tutorial`, `HowTo`, `Reference`, or `Explanation`), and the matching readability style.
A tools section applies the shared base to tool Markdown, and `[**/README.md]` applies it to README files.
The `Diataxis` package supplies the quadrant styles, `A11y` supplies accessibility rules, `Harper` supplies grammar and style checks, `Inclusive` supplies inclusive-language substitutions, and `Vale` supplies the built-in checks.
The per-quadrant readability styles (`TutorialReadability`, `HowToReadability`, `ReferenceReadability`, and `ExplanationReadability`) are local adaptations of the [Readability](https://github.com/vale-cli/readability) formulas.
Accepted names live in vocabularies rather than by suppressing rules: `Toolkit` for the toolkit's own terms and `Project` for the documented project's.

Vale applies every matching section, and the last match wins per key.
The tools and README sections share one base, and the four quadrant sections are mutually exclusive.

## Readability and sentence limits

`Plain.Sentence` is a suggestion at 25 words per sentence.
`Plain.SentenceHard` is a warning at 35 words per sentence.
`Plain.Grade` remains the paragraph-level Flesch-Kincaid check for tools and README files.
The docs sections disable `Plain.Grade` and use the matching readability style instead:

- Tutorial: Flesch-Kincaid above 9, Gunning-Fog above 10.
- How-to: Flesch-Kincaid above 10, Gunning-Fog above 11.
- Reference: Flesch-Kincaid above 12, Gunning-Fog above 14.
- Explanation: Flesch-Kincaid above 12, Gunning-Fog above 14.

`Inclusive` and `Plain` run in every linted location.
The `voice/` tree remains excluded from prose linting.

The quadrant sections also carry deliberate rule overrides: `Tutorial.Steps` is disabled while the tutorial template uses heading steps; `signs-of-ai-writing.Passive` is disabled for reference and explanation; and `signs-of-ai-writing.Transitions` is disabled for explanation.

## Run

```bash
# Errors only, blocking:
vale --config tools/vale/.vale.ini --minAlertLevel error \
  --glob='!**/voice/**' docs/public

# Full scan, all severities:
vale --config tools/vale/.vale.ini --minAlertLevel suggestion \
  --glob='!**/voice/**' docs/public
```

The toolkit excludes the `voice/` tree from prose linting; the exemplar corpus is reference material, not prose to lint.
Pass the tool-local config explicitly; nothing is auto-discovered outside the tool directory.

## Alerting

Findings print as `file:line:column level RuleID message`.
Errors block; fix every one.
Warnings and suggestions are reviewed candidates, not verdicts.
A strictly reviewed corpus reaches 0 errors, 0 warnings, and 0 suggestions.

## Vocabularies

Put unknown product names in the `Project` vocabulary as plain words, one per line, never as regex patterns.
A regex entry breaks the built-in `Vale.Terms` rule in Vale 3.24: it flags every word that matches the pattern and suggests the pattern itself as the replacement.
A rule that needs a pattern carries it in its own `filters`; never put a regex in a vocabulary.

## Styles

Each style is a directory of YAML rules under `styles/`.
A rule's identifier is the style name plus the rule name, for example `HowTo.Steps`.
Change the rule file, not the config, when a rule needs a different check.
Alerts are `error` (confirmed violation, blocks), `warning` (confirmed violation, does not block), or `suggestion` (candidate; word-list rules produce false positives).
Suppress a rule only for a deliberate exception, with `<!-- vale Style.Rule = NO -->` and `= YES` around the exception.

## Caveats

- Only installed stylesets are active; run `vale sync` with network access before relying on a styleset that ships only in `Packages`.
- If `vale` is missing, reinstall it into `~/.local/bin` or point `--config` at a local copy.
