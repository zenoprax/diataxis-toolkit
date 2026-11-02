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
The per-quadrant readability styles (`TutorialReadability`, `HowToReadability`, `ReferenceReadability`, and `ExplanationReadability`) are local adaptations of the [Readability](https://github.com/vale-cli/readability) formulas for Flesch-Kincaid, SMOG, and Gunning-Fog.
Accepted names live in vocabularies rather than by suppressing rules: `Toolkit` for the toolkit's own terms and `Project` for the documented project's.

Vale applies every matching section, and the last match wins per key.
The tools and README sections share one base, and the four quadrant sections are mutually exclusive.
A final `[*]` section disables the passive-voice rule everywhere.

## Readability and sentence limits

`Plain.Sentence` is a suggestion at 25 words per sentence.
`Plain.SentenceHard` is a warning at 50 words per sentence.
The hard cap is deliberately loose: Ubuntu explanations use sentences of up to about 50 words, and splitting every long sentence produces choppy prose.
The soft limit is the editing prompt; the hard cap is the failure.

`Plain.Grade` remains the paragraph-level Flesch-Kincaid check for tools and README files.
The docs sections disable `Plain.Grade` and use the matching readability style instead.
Each quadrant style defines three indices: Flesch-Kincaid at paragraph scope, SMOG at page scope, and Gunning-Fog at page scope.

| Quadrant     | Flesch-Kincaid | SMOG     | Gunning-Fog |
| ------------ | -------------- | -------- | ----------- |
| Tutorial     | above 11       | above 11 | above 13    |
| How-to       | above 11       | above 11 | above 13    |
| Reference    | above 11       | above 11 | above 15    |
| Explanation  | above 11       | above 11 | above 15    |
| Tools/README | above 9        | above 11 | not checked |

All three indices are suggestions.
Flesch-Kincaid grades each paragraph; SMOG and Gunning-Fog grade the whole page, and SMOG needs about 30 sentences to be stable.
The four quadrant Flesch-Kincaid targets follow Ubuntu's contribution guide, which sets grade 11 as the ceiling for both SMOG and Flesch-Kincaid.
Gunning-Fog sits above the observed Ubuntu range, so it acts as a secondary check on unusually dense pages rather than a warning on ordinary technical prose.
`Plain.Grade` stays at grade 9 because tools and README files are toolkit prose, not Ubuntu product documentation.

Sentence length is global on purpose.
A long sentence is hard to parse in any quadrant, and one 50-word cap gives a clear, predictable failure.
The quadrant difference belongs in the readability indices, which combine sentence length with vocabulary.
A separate per-quadrant sentence cap would add rules without adding signal; if one is ever needed, add it to that quadrant's readability style rather than lowering the global cap.

## Choosing a readability formula

Flesch-Kincaid is the primary paragraph check.
It uses average sentence length and syllables per word, maps directly to US grade levels, and responds quickly to long sentences.
Its weakness is that syllable counting treats technical terms and acronyms as hard words, and it ignores syntax and meaning.

SMOG is the page-level check.
It counts words of three or more syllables and sentences, and it is deliberately conservative, which makes it a useful signal for dense vocabulary.
It needs about 30 sentences to be stable, so the rule scores the whole page.
On short pages and code-heavy text it overestimates difficulty.

Gunning-Fog combines sentence length with the percentage of complex words, usually words of three or more syllables.
It is familiar to technical writers and gives a second view of the same two pressures.
It also counts technical terms as complex, and it weights sentence length heavily, so it can push writers toward short, uniform sentences.

The three indices overlap.
Use Flesch-Kincaid for the paragraph prompt, SMOG for the page-level vocabulary signal, and Gunning-Fog as a secondary check.
Do not optimize all three at once; the result is short, choppy prose that reads less like Ubuntu.

## Rule changes

`HowTo.Title` requires an imperative verb, and rejects `How to ...`, gerunds, articles, and bare noun titles such as "Deployment".
All four quadrant Flesch-Kincaid targets are grade 11, and Gunning-Fog is a suggestion with targets above the Ubuntu range.
`HowTo.Opening` was removed: Ubuntu opens with the outcome, while Diátaxis also allows "This guide shows you how to ...", so no single required phrase satisfies both.
`Tutorial.Options` and `Tutorial.Teaching` are suggestions.
`Tutorial.Opening` is a suggestion and accepts Ubuntu's forms, including "This tutorial will guide you", "Let's walk through", and "By the end".
`Explanation.Reference` allows up to eight table rows.
`Explanation.Why`, `Reference.Examples`, and `HowTo.Steps` are disabled.

## Diátaxis precedence

The rules are heuristics; the Diátaxis tenets are the contract.
Where a rule and a tenet disagree, the tenet wins.
Diátaxis sets the floor, not the ceiling: a house style may be stricter, as the imperative-only how-to title is.
An advisory rule is still a useful prompt, but a clean Vale run is not proof that a page follows Diátaxis.

The quadrant sections carry deliberate rule overrides:

- `Tutorial.Steps` is disabled while the tutorial template uses heading steps.
- `HowTo.Steps` is disabled because a how-to sequence can use ordered lists, bullet lists, headings, tabs, or definition lists.
- `Tutorial.Opening` is disabled on tutorial index pages, which list tutorials rather than restate an outcome.
- `HowTo.Title` is disabled on how-to index pages, which list guides rather than name a task.
- `Plain.SMOG` is disabled in the quadrant sections, where the matching readability style provides the SMOG check.
- `Reference.Examples` is disabled because a reference page about hardware or requirements may have no code to show; examples are still expected where the subject has a command or syntax surface.
- `Explanation.Why` is disabled because Ubuntu explanations answer why through mechanism and consequence, not a fixed list of cause words.
- `signs-of-ai-writing.Passive` is disabled everywhere; technical description needs passive voice when the actor is unknown or irrelevant.
- `signs-of-ai-writing.Transitions` is disabled for explanation.

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
Change the rule file when the check itself needs a different shape, and disable the rule in the config when the check is wrong for a quadrant.
Alerts are `error` (confirmed violation, blocks), `warning` (confirmed violation, does not block), or `suggestion` (candidate; word-list rules produce false positives).
Suppress a rule only for a deliberate exception, with `<!-- vale Style.Rule = NO -->` and `= YES` around the exception.

## Caveats

- Only installed stylesets are active; run `vale sync` with network access before relying on a styleset that ships only in `Packages`.
- If `vale` is missing, reinstall it into `~/.local/bin` or point `--config` at a local copy.
