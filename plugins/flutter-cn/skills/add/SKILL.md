---
name: add
description: "Use when the user asks to add, install, or pull in one or more flutter-cn components (by file name, folder/name, or symbol), or when Claude has picked a flutter-cn component via the docs/use-components skills and needs to copy it into the project. Also invoked directly as /flutter-cn:add <name...>."
argument-hint: "<name|folder/name|Symbol>..."
---

# flutter-cn add

Copies one or more flutter-cn components into the current project via
`"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh"`. Never call a bare `fcn` — the wrapper installs it
non-interactively on first use, so installing the plugin is the only manual step.

0. **No `fcn.json` yet?** Run `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" init` yourself first
   (default `--dir lib/ui/components`; pass `--dir <path>` only if the user specified one; no
   prompt) before continuing.
1. **Preview first for a bigger ask.** If `$ARGUMENTS` names more than 3 components, run
   `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" add $ARGUMENTS --dry-run` first and confirm the
   file list looks right before the real run.
2. **Copy.** Run:

   ```sh
   "${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" add $ARGUMENTS
   ```

   This copies the named file(s) — plus whatever they relative-import — unchanged into
   `<dir>/<folder>/`, and runs `flutter pub add` for any pub package they need.
3. **Report** the files that were written and any packages that were added.
4. **Show usage.** For each component just added, use the `docs` skill
   (`"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" docs <name>`) to pull its **Usage** and **Bind to
   your tokens** sections and print them, so the next step is binding tokens and wiring the
   import, not re-deriving how the component works.
