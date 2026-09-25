---
name: init
description: "Use when setting up flutter-cn in a project for the first time — no fcn.json yet, or the fcn CLI itself isn't installed. Also invoked directly as /flutter-cn:init [--dir <path>]."
argument-hint: "[--dir <path>]"
---

# flutter-cn init

Sets up flutter-cn in the current Flutter project, for when the user wants to choose the
directory explicitly rather than accepting the default. `use-components`, `docs` and `add`
already auto-init with the default directory when `fcn.json` is missing — reach for this
skill when the user names a `--dir`, or asks to (re-)run init directly.

Always run `fcn` via the plugin's self-bootstrapping wrapper,
`"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh"` — never a bare `fcn`, and never tell the user to run
an installer themselves; the wrapper installs `fcn` non-interactively on first use.

1. **Initialise the project.** Run:

   ```sh
   "${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" init --dir lib/ui/components
   ```

   passing `--dir $ARGUMENTS` when a directory was given in the arguments, otherwise leave it
   at the default `lib/ui/components`. This bootstraps `fcn` itself if it isn't installed yet,
   then writes `fcn.json` (`source`, `dir`, `installed`) at the project root, next to
   `pubspec.yaml`.
