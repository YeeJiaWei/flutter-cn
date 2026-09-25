# CLAUDE.md

Guidance for Claude Code when working in this folder.

## What this is

A **Flutter take on [shadcn/ui](https://ui.shadcn.com)**: a library of reusable UI
components that projects *copy into their own codebase and own*, rather than install. Like
shadcn, it is not a package: no root `pubspec.yaml` (only the `widgetbook/` harness and the
`cli/` tool have one), never a dependency, no shared runtime to keep in sync. Projects pull
components in with the `fcn` CLI (the `npx shadcn add` equivalent) or by hand, bind their
design tokens, and diverge freely. `README.md` holds the full convention, the provenance, and the
catalogue — read it first.

What carries over from shadcn:

- **You own the code.** A copied component is the project's code from then on; the store is
  the reference, not the source of truth for any project.
- **Unstyled-by-default knobs, not a theme system.** Where shadcn leans on CSS variables,
  a snippet exposes every visual value as a constructor parameter with a literal default,
  and the copying project binds its own tokens.
- **Variants over subclasses.** Prefer one component with a `variant`/`size` enum (see
  `buttons/button.dart`, `feedback/status_pill.dart`) to many near-duplicate widgets.
- **Composable primitives.** Ship the shell (`BaseDialog`, `SurfaceCard`) and let projects
  compose product widgets on top, the way shadcn composes `Dialog` + `DialogHeader` + …

When adding a component the store doesn't have yet, use shadcn/ui's component list and
naming as the checklist (Accordion, Alert, Sheet, Tabs, Tooltip, Select, Switch, …), mapped
to the idiomatic Flutter equivalent rather than a literal port of the web API.

Sibling projects that consume it live next door under `~/projects/etcteam/` (the first was
`verolink-flutter`, whose `lib/app/ui/shared/widgets/` `Mx*` widgets were the source).

## Hard rules

- **Framework only.** A snippet imports `package:flutter/material.dart` (or `cupertino.dart`),
  optionally one pub package named in the README's "Dependencies" section, and other snippets
  by **relative path** inside this folder (`fcn add` follows these imports to copy
  dependencies, so never reach another snippet any other way). Never GetX, baseX, an app's routes, models,
  services, session, or asset paths.
- **No design tokens.** Every visual value (colour, spacing, radius, shadow, text style) is a
  constructor parameter with a literal default. No `AppColors.*`, `AppSpacing.*`, or any
  project token type. If a value must be shared across several params, make it a `static const`
  on the widget, still literal.
- **No previews inside a snippet.** No `@Preview` functions, no `widget_previews` or
  `widgetbook` import in a snippet file. Previews live only in the `widgetbook/` harness (see
  below), which is never copied into a project.
- **Shell, not product.** Keep a snippet at the level a second app would still want: a dialog
  shell, not an "illustrated upsell dialog"; a status pill, not a "billing status pill". Domain
  resolution (status → colour, tier → label) stays with the caller.
- **Names avoid Flutter collisions.** Drop the source project's prefix, then rename if the
  bare name shadows a core widget (`Chip` → `SelectableChip`, `Card` → `SurfaceCard`,
  `AppBar` → `TopBar`). The README lists the current mapping; keep it updated.
- **One widget family per file** is fine (a widget plus its enum, or four button variants
  sharing a private shell). Anything else gets its own file in the matching folder.
- **Doc comment on every public class and function** saying what it renders and what the
  caller must supply.

## Adding or updating a snippet

1. Start from the source project's widget on its current branch. Strip tokens, previews and
   app coupling per the rules above. Prefer a callback parameter over any framework call
   (`onFallback: VoidCallback` instead of `Get.offAllNamed`).
2. Place it under `components/`, in the folder that matches its role: `buttons/ cards/
   chips/ dialogs/ feedback/ inputs/ layout/ media/ pickers/`. Add a folder only when none
   fits. Nothing but component folders lives in `components/`; tooling stays at the root.
3. Add one line to the README catalogue (path, class(es), one-phrase purpose) and, if a pub
   dependency is needed, one line to "Dependencies some snippets need".
4. Add its Widgetbook use case (see "Widgetbook catalogue" below). A snippet without a use
   case is not done.
5. Verify from `widgetbook/`: `flutter analyze` clean and `flutter build web` succeeds. Every
   snippet is imported by a use case, so this compiles the whole store. Do this for every
   change; there is no CI here.
6. If the snippet came from a project, note that project and date in the README's
   provenance paragraph when it is the first snippet from that source.

There is no registry to update: `fcn` scans `components/` at runtime, and Widgetbook sees
it through one symlink, so a new folder under `components/` is picked up by both
automatically.

## Widgetbook catalogue

`widgetbook/` is a standalone Flutter app (web + macOS) that renders every snippet with
[Widgetbook](https://pub.dev/packages/widgetbook) — the Storybook of this store, so
components can be designed and reviewed without any consuming project. It is the only
app here; the store itself stays pubspec-free.

- Run: `cd widgetbook && flutter run -d chrome` (or `-d macos`).
- Snippets reach the app through one symlink, `widgetbook/lib/store` → `../../components`
  (Dart rejects a relative import from `lib/` that leaves the package). Use cases import
  `../../store/buttons/button.dart`. Never copy or move a snippet into `widgetbook/`, and
  never make a snippet import from it.
- Use cases render inside their own navigator in the device frame. Show-functions and
  overlays in snippets must expose `useRootNavigator` / `useRootOverlay` (default `true`) so
  the harness can pass `false` and keep them inside the frame.
- Manual tree, no codegen: one `lib/use_cases/<folder>/<snippet>_use_cases.dart` per snippet
  file, mirroring the store folders, registered in `lib/directories.dart` in README
  catalogue order.
- Each component gets a "Default" use case driven by **knobs** for its meaningful params
  (variant/size enums, label, loading/disabled/selected, colours). Add separate named use
  cases only for what a knob can't express. Show-functions (`showBaseDialog`, pickers,
  `Toast`) get a button that triggers them, plus an "Inline" use case rendering the widget
  statically where one exists (e.g. `BaseDialog`).
- Pub dependencies a snippet needs (`flutter_svg`, `crop_your_image`) are added to
  `widgetbook/pubspec.yaml` as well as listed in the README.
- Demo data (placeholder image URLs, sample SVG in `widgetbook/assets/`) stays in the
  harness, never in a snippet's defaults.

## `fcn` CLI

`cli/` is the `fcn` command (Dart, `args` + `path` only). `install.sh` (macOS/Linux) and
`install.ps1` (Windows) are its one-line installers. `cli/README.md` has the full usage.
Repo: https://github.com/YeeJiaWei/flutter-cn (public; issues on, pull requests off).

- Installers download the prebuilt binary for the OS/arch from the latest GitHub Release
  (`FCN_VERSION` pins a tag), verify it against `checksums.txt`, install to `~/.fcn/bin`, clone
  the store to `~/.fcn/store` for components, and add PATH once. No release or unsupported
  arch → build from source with Dart (`FCN_BUILD_FROM_SOURCE=1` forces it; reports `dev`).
  `fcn upgrade` re-runs the hosted installer. `FCN_REPO` overrides the store source.
- **Releasing:** bump `version:` in `cli/pubspec.yaml`, commit, tag `vX.Y.Z` (must equal the
  pubspec version or the workflow fails). The `v*` tag triggers `.github/workflows/release.yml`,
  which tests and compiles `fcn-macos-arm64`, `fcn-macos-x64`, `fcn-linux-x64`,
  `fcn-windows-x64.exe` and publishes them with `checksums.txt`. `ci.yml` runs cli tests and
  the Widgetbook analyze/build on every push to `main`. Release asset names are what the
  installers download; rename them in all three files together.
- In a project: `fcn init` writes `fcn.json` (`source`, `dir`, `installed` file → store
  commit). `fcn add <file|folder/file|Symbol>…` copies the file plus every snippet it imports,
  **unchanged**, into `<dir>/<folder>/`, skips existing files unless `--overwrite`, and runs
  `flutter pub add` for missing packages. `fcn list`, `fcn diff [name]` for the rest.
- Snippets are parsed by regex (imports, public top-level symbols, first doc-comment line),
  so keep declarations at column 0 and the doc comment directly above them.
- Only `components/` is scanned (skipping `build/`, `.dart_tool/`, hidden dirs); paths in
  `fcn.json` and in the project (`<dir>/buttons/button.dart`) are relative to `components/`.
  A relative import that leaves `components/` is an error.
- Verify CLI changes with `cd cli && dart analyze && dart test`, plus an end-to-end
  `fcn init` + `fcn add` in a throwaway `flutter create` app in the scratchpad, then
  `flutter analyze` there. Never run `install.sh` against the real `$HOME` — use
  `HOME=<scratchpad>/home`.

## Pulling a snippet into a project

Use `fcn add` (or copy by hand per the README), rename with the project prefix if wanted,
bind tokens, and customise on top. Do not edit the store to suit one
project's look. If a project's customisation reveals a missing generic knob, add the knob
here as a plain parameter with a literal default, not the project's value.

## Git

Git repo, default branch `main`, remote `origin` → github.com/YeeJiaWei/flutter-cn. Commit
messages use the conventional prefix and no attribution trailers; nothing is pushed from a
session (branches and release tags are pushed by the user).
