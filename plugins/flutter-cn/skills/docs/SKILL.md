---
name: docs
description: "Use when choosing between flutter-cn components for a task, or before using, configuring, or customising one — runs `fcn docs` for the index or `fcn docs <name>` for a component's usage doc (when to use, example, key parameters, tokens to bind). Also invoked directly as /flutter-cn:docs [name]."
argument-hint: "[name|folder/name|Symbol]"
---

# flutter-cn docs

Reads the per-component usage docs that ship with the flutter-cn store, via
`"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" docs`. `use-components` and `add` both delegate their
doc lookups to this skill. Never call a bare `fcn` — the wrapper installs it non-interactively
on first use, so nothing here needs the user to run an installer themselves. If the project
has no `fcn.json` yet, run `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" init` first (default `--dir
lib/ui/components`, pass `--dir <path>` only if the user specified one; no prompt) before
continuing.

## With no argument

Run:

```sh
"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" docs
```

This prints the index: every component grouped by folder, with its `use_when` / `avoid_when`,
and which ones are already installed in the current project. Read it against the task at hand
and summarise the 1-3 best-fitting candidates, with the reasoning from their `use_when` /
`avoid_when`.

## With a name

Run:

```sh
"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" docs <name>
```

`<name>` resolves the same way `fcn add` does: a bare file name (`button`), `folder/name`
(`dialogs/confirm_dialog`), or a public symbol (`PrimaryButton`, `showConfirmDialog`). Use
`folder/name` if a bare name is ambiguous. Pull out and present:

- **When to use** / **When not to use** — the decision to reuse this component or not.
- **Usage** — the minimal compiling example, to base the real usage on.
- **Key parameters** — only the ones that matter for the task.
- **Bind to your tokens** — which constructor defaults must be swapped for the project's
  design tokens before shipping.

Add `--json` when the output needs to be parsed rather than read.

## Fallback when `fcn.sh` fails

If the wrapper can't resolve or install `fcn` (no network, no curl/git), read the doc
directly instead:

1. `~/.fcn/store/docs/components/<folder>/<file>.md`, if that store clone exists locally.
2. Otherwise, fetch the raw GitHub copy:
   `https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/docs/components/<folder>/<file>.md`.
