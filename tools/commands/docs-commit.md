---
description: Commit documentation-only changes after checking scope and running the repository's docs QC checks.
agent: build
---

# Documentation commit

Commit a documentation-only change in this repository.
Optional scope or message hint: $ARGUMENTS.
The hint cannot authorize non-documentation paths.

## 1. Read the repository contract

Read the repository's agent instructions, contribution guide, README, CI workflows, and task runner.
Do this before staging or checking anything.
Find three things:

- The documentation roots and formats this repository treats as documentation.
- The exact documentation QC command or commands, including path filters.
- The commit convention, if it differs from the `docs` type.

Use the QC checks for the package or area that owns the changed pages.
Do not import checker paths, configuration files, or commands from another repository.
Do not install tools or invent QC checks.
If the repository has no documented QC checks, run only checkers the repository already uses for documentation.
If it has none, stop and report the gap.

## 2. Prove the staged set is documentation-only

Start with the staged set:

```bash
git status --short
git diff --cached --name-only
```

If nothing is staged, stage only the documentation paths named by the user.
If the user named none, inspect `git status --short`.
Stage only the documentation changes that belong to this commit.
If the intended change is ambiguous, stop and ask.
If no documentation changes remain, stop.
Use explicit paths.
Never use `git add .`, `git add -A`, or `git commit -a`.

A documentation-only set may contain prose, diagrams, and images that live under the repository's documentation roots, plus root-level or package-level documentation files the repository treats as docs.
Stop on code, tests, checker configuration, scripts, skills, and agents.
Also stop on build files, lock files, generated artifacts, snapshots, copied dependencies, submodules, and tooling metadata.
If the staged set mixes documentation with any of those, stop and split the work.
If it mixes formatting churn with content, split that too.

Review the staged diff:

```bash
git diff --cached
git diff --cached --check
```

Do not commit secrets, credentials, private URLs, customer data, or personal data.
If the diff contains any, remove it before continuing.

## 3. Apply the style and anti-slop check

Read the full staged diff.
Fix only documentation prose in this change when it breaks the repository's style or the rules below.
Do not invent facts, names, dates, numbers, links, examples, or citations.
Do not strengthen a claim the source does not support.
Keep code blocks, inline code, commands, paths, front matter, link targets, and data unchanged.

Remove these patterns when they appear:

- **Not X but Y**: the negative half names something no one claimed, or a split contrast that only adds weight.
- **One-line closers**: a sentence that restates the paragraph, explains an example the reader just saw, or asks the reader to pause on a claim.
- **Staged openers**: "Let's dive in", "Here's what you need to know", "Honestly", "The thing is", and similar run-ups before the point.
- **Forced triads**: three items or examples where the meaning has two, four, or one.
- **Rhetorical questions**: a question that sets up an answer the next sentence gives.
- **Document narration**: "This section covers", "In this guide", or comments about how the text was assembled.
- **Inflated claims**: "pivotal", "crucial", "testament", "landscape", "robust", "comprehensive", "seamless", "leverage", and sales language.
- **Borrowed authority**: unnamed experts, prestige lists, or vague "associated with" links that do not say how the things relate.
- **Shallow -ing riders**: "highlighting", "ensuring", "reflecting", "showcasing", and similar tails bolted onto a fact.
- **Repeated sentence openings** and stacked qualifiers that make every claim sound uncertain.
- **Decorative formatting**: bold labels with no informational value, emojis, arrows, and headings written for effect.
- **Chat residue**: greetings, offers to continue, and comments about the drafting process.

Prefer concrete verbs and plain `is`, `are`, and `has` over "serves as", "stands as", and "represents".
Follow the repository's voice, line-length, table, and heading rules.
If no voice sample exists, avoid em dashes and stock transitions.
Keep a contrast only when the negative half corrects a belief the reader holds.
Re-run the QC checks after any prose change.

## 4. Run the repository's documentation QC checks

Run the exact command or commands found in step 1 from the repository root.
Do not substitute a checker, configuration, or path from another repository.
Run every part of a multi-part QC run.

If a checker cannot run, report the exact missing command or failure and run the rest.
Do not install the checker.
Do not claim a check passed without its output.

Triage findings:

- **Error or blocking finding**: fix it before committing.
- **Warning**: fix it if this change introduced or aggravated it; otherwise explain why it stands.
- **Suggestion or informational finding**: no body note required.
- If the repository has no severity levels, treat a nonzero exit as blocking.

Do not commit while the QC checks fail unless the user explicitly accepts the failure.
Record that exception in the body.

## 5. Write the message

Use the `docs` type unless the repository's convention requires another type:

```text
docs: Verb the change
```

- Pick the verb that is true: Add, Remove, Update, Correct, Deprecate, Clarify, or another accurate verb.
- Keep the subject at 50 characters or fewer, including the type and scope prefix.
- Use the imperative mood and no trailing period.
- Keep one logical change.
- Follow the repository's scope convention if it has one; otherwise omit the scope.

Write the body unless the change is very minor.
Include what changed and why when the diff cannot show it.
Name any uncertainty.
That includes facts checked against an older source, behavior inferred from tests, or naming choices that could go either way.
Name style choices made for checkers when the resolution is not obvious.
Explain every warning left in place.
Do not narrate the tool run, restate the diff, or add a closing summary.
Do not add tool attribution, generated-by trailers, or co-author trailers unless the user asks.

## 6. Commit and verify

```bash
git commit -m "docs: ..." -m "..."
git show --stat --oneline HEAD
git status --short
```

If a hook modifies files, stage only the intended documentation again, re-run the QC checks, and create a new commit.
If the hook introduces a non-documentation path, stop.
Do not use `--no-verify`.
Do not amend, push, or open a pull request unless the user asks.
If the verification shows an unexpected path, stop and report it.
Do not rewrite history to hide the mistake.

Report the commit hash, subject, QC command and result, any warnings left in place, and any skipped check.
Stop after the commit.
If blocked, do not commit.
Report the blocker and the exact changed paths.
