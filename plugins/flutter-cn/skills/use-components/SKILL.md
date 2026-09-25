---
name: use-components
description: "Use when writing or modifying Flutter UI in a project — a new widget, page, dialog, button, form, list row, or any hand-rolled visual element — before writing it from scratch. Applies proactively whenever the project has flutter-cn installed (an fcn.json at the project root) or flutter-cn components are already imported nearby."
---

# Use flutter-cn components

flutter-cn is a copy-in Flutter component store. A copied component is the project's own code
from then on — never a dependency — so reaching for one first is free: no lock-in, no runtime
coupling.

Never call a bare `fcn`. Always run it via the plugin's self-bootstrapping wrapper,
`"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh"` — it resolves an installed `fcn`, installs one
non-interactively if there isn't one yet, then runs the command. Installing the plugin is the
only manual step; never tell the user to run an installer or install `fcn` themselves.

## Working rules

0. **No `fcn.json` yet?** Run `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" init` yourself first
   (default `--dir lib/ui/components`; pass `--dir <path>` only if the user specified one) —
   don't ask the user to do it, and don't stop to ask which directory unless they already said.
1. **Check before building.** Look at the installed components in `fcn.json` first, then run
   `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" docs` for the full index. Pick a component by
   matching the task against each entry's `use_when` / `avoid_when`.
2. **Read the doc before using it.** Run `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" docs <name>`
   (or use the `docs` skill) before wiring up any flutter-cn component — it has the usage
   example, key parameters, and which defaults are meant to be swapped for the project's
   tokens.
3. **Import from the project's copy**, not the store: `<dir>/<folder>/<file>.dart`, where
   `<dir>` is `fcn.json`'s `dir` (default `lib/ui/components`). Add a missing component with
   `"${CLAUDE_PLUGIN_ROOT}/scripts/fcn.sh" add` (or the `add` skill) rather than copying it by
   hand.
4. **Bind the project's tokens.** The copied file's constructor defaults are literal
   placeholders (`Colors.white`, hardcoded `EdgeInsets`, …) — pass the project's real
   colors/spacing/radii instead of relying on them.
5. **Compose on the shells.** Prefer building on `BaseDialog`, `SurfaceCard`, and similar
   shells over writing a new dialog or card widget from scratch.
6. **Never edit `~/.fcn/store`.** That's the store's own clone, not the project's code —
   customise the project's copy under `<dir>` instead.
