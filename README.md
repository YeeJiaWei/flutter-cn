# flutter-cn

**shadcn/ui for Flutter.** A library of token-free Flutter widgets that you *copy into your
project and own*, instead of installing as a dependency. Every visual value is a constructor
parameter with a plain default, so binding them to your design tokens is a find-and-replace.

The store itself is **not** a Dart package — it has no root `pubspec.yaml` and is never added
as a dependency. Components live in `components/`, their usage docs in `docs/components/`.

## Install

Pick one. Both end the same way: component files copied into your project under
`lib/ui/components/<folder>/`, owned by you.

### Option A — Claude Code plugin (marketplace)

In Claude Code, add the marketplace and install the plugin. This is the only manual step:

```
/plugin marketplace add YeeJiaWei/flutter-cn
/plugin install flutter-cn@flutter-cn
```

From then on Claude does the rest:

- installs the `fcn` CLI the first time it needs it (into `~/.fcn`);
- runs `fcn init` in the project (default `lib/ui/components`);
- checks `fcn docs` for a fitting component before hand-writing a widget, and pulls it in with
  `fcn add`, reading its usage doc first.

You can also drive it yourself:

| Skill | What it does |
|---|---|
| `/flutter-cn:docs [name]` | Component index, or one component's usage doc |
| `/flutter-cn:add <names…>` | Copy components (plus what they import) into the project |
| `/flutter-cn:init [dir]` | Set the project up with a specific components folder |

Update with `/plugin marketplace update flutter-cn`.

### Option B — Manual (CLI)

Install `fcn` once per machine:

```sh
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.ps1 | iex
```

The installer downloads the prebuilt `fcn` for your OS from the latest
[release](https://github.com/YeeJiaWei/flutter-cn/releases), clones the store to `~/.fcn/store`
and adds `~/.fcn/bin` to your PATH. Then, in a project:

```sh
cd your_app
fcn init                        # writes fcn.json; components go to lib/ui/components
fcn docs                        # which component for which job
fcn docs PrimaryButton          # usage doc for one component
fcn add PrimaryButton showConfirmDialog   # copy by file name, folder/name, or symbol
fcn diff                        # compare your copies with the store
fcn upgrade                     # update fcn and the store
```

`fcn add` copies the file and every component it imports, unchanged, and runs
`flutter pub add` for any package it needs. See [`cli/README.md`](cli/README.md) for every
command and option (`--dir`, `--source` for a fork, `--dry-run`, `--overwrite`).

**No CLI at all?** Copy the `.dart` file from `components/<folder>/` (and any component it
imports) into your project by hand, and read its doc in `docs/components/<folder>/`. The
[Convention](#convention) below applies either way.

## Browsing the catalogue

`widgetbook/` is a [Widgetbook](https://pub.dev/packages/widgetbook) app that renders every
widget in this store with interactive knobs, so you can see a component before copying it.

```sh
cd widgetbook
flutter run -d chrome   # or: flutter run -d macos
```

See `widgetbook/README.md` for how it imports the store.

## Convention

1. Pull the component into your project — via the Claude Code plugin, `fcn add`, or by hand
   (see [Install](#install)).
2. Rename the widget with the project's prefix (e.g. `BaseDialog` → `MxBaseDialog`,
   `showBaseDialog` → `showMxBaseDialog`), and the file to match
   (`base_dialog.dart` → `mx_base_dialog.dart`).
3. Swap the plain constructor params for the project's design tokens (colors, radii,
   spacing) where the project has them — the snippet's defaults are deliberately generic
   (`Colors.white`, hardcoded `EdgeInsets`, etc.) so this step is a find-and-replace, not a
   rewrite.
4. Customise on top: add project-specific variants, extra slots, or a higher-level widget
   built on the copied shell (e.g. `MxIllustratedDialog` built on `MxBaseDialog`).
5. Leave a one-line header comment on the copied file pointing back here, e.g.
   `// Copied from ../flutter-snippets/components/dialogs/base_dialog.dart and bound to app tokens.`

Because each copy is independent, projects can diverge freely after copying — there is no
shared runtime dependency to keep in sync. Pull updates by re-diffing against this repo by
hand when useful.

## Provenance

Most of the snippets below were extracted from the Metaxy app's
`lib/app/ui/shared/widgets/` (verolink-flutter, branch `feature/reuse-extraction-batch1`)
on 2026-09-25, with app design tokens (`AppColors`/`AppSpacing`/`AppRadius`/`AppShadows`)
replaced by literal constructor defaults equal to the token's value at that time, and app
coupling (GetX, baseX, app routes, app asset paths) cut or replaced with plain callbacks.

Some snippet class names differ from the app's `Mx*` name beyond just dropping the prefix,
where the natural drop-prefix name collides with a core Flutter widget (e.g. `MxChip` →
`SelectableChip`, not `Chip`; `MxCard` → `SurfaceCard`; `MxListTile` → `InfoListTile`;
`MxTextField` → `FormTextField`; `MxDivider` → `FadingDivider`; `MxBadge` → `CountBadge`;
`MxLoading` → `LoadingIndicator`; `MxNetworkImage` → `NetImage`; `MxAppBar` → `TopBar`;
`MxTextButton` → `PlainTextButton`; `MxSnackbar` → `Toast`). Pick whatever name suits the
copying project — these are just collision-free defaults.

## Dependencies some snippets need

The store itself has no `pubspec.yaml`; add these to the **copying project** only if you
copy the snippet that needs them:

- `flutter_svg` — `components/media/svg_icon.dart`
- `crop_your_image` — `components/pickers/photo_crop_page.dart`

Everything else is plain `package:flutter/material.dart` (or `cupertino.dart` for the wheel
pickers), no extra dependency.

## Snippets

Each component links to its usage doc (when to use it, when not, example, key parameters,
tokens to bind). From a project, `fcn docs` prints the same index.

| Folder | Components |
|---|---|
| `buttons/` | [button](docs/components/buttons/button.md) |
| `cards/` | [card](docs/components/cards/card.md) |
| `chips/` | [chip](docs/components/chips/chip.md), [outline_chip](docs/components/chips/outline_chip.md), [tag_list](docs/components/chips/tag_list.md) |
| `dialogs/` | [base_dialog](docs/components/dialogs/base_dialog.md), [confirm_dialog](docs/components/dialogs/confirm_dialog.md), [dialog_icon](docs/components/dialogs/dialog_icon.md) |
| `feedback/` | [badge](docs/components/feedback/badge.md), [empty_state](docs/components/feedback/empty_state.md), [loading](docs/components/feedback/loading.md), [rating_stars](docs/components/feedback/rating_stars.md), [skeleton](docs/components/feedback/skeleton.md), [snackbar](docs/components/feedback/snackbar.md), [status_pill](docs/components/feedback/status_pill.md) |
| `inputs/` | [password_field](docs/components/inputs/password_field.md), [phone_field](docs/components/inputs/phone_field.md), [text_field](docs/components/inputs/text_field.md) |
| `layout/` | [app_bar](docs/components/layout/app_bar.md), [divider](docs/components/layout/divider.md), [header_title](docs/components/layout/header_title.md), [list_tile](docs/components/layout/list_tile.md), [page_dots](docs/components/layout/page_dots.md), [page_header](docs/components/layout/page_header.md), [progress_stepper](docs/components/layout/progress_stepper.md), [pullable_empty](docs/components/layout/pullable_empty.md), [section_header](docs/components/layout/section_header.md) |
| `media/` | [avatar](docs/components/media/avatar.md), [glass_label](docs/components/media/glass_label.md), [network_image](docs/components/media/network_image.md), [svg_icon](docs/components/media/svg_icon.md) |
| `pickers/` | [dob_picker](docs/components/pickers/dob_picker.md), [height_picker](docs/components/pickers/height_picker.md), [photo_crop_page](docs/components/pickers/photo_crop_page.md), [year_picker](docs/components/pickers/year_picker.md) |

## Releasing

1. Bump `version:` in `cli/pubspec.yaml`.
2. Commit the bump.
3. Tag the commit `vX.Y.Z` (matching the pubspec version) and push the tag.

Pushing the tag triggers the `Release` workflow, which builds the `fcn` binary for macOS
(arm64 + x64), Linux and Windows, and publishes them with `checksums.txt` to a GitHub
Release for that tag. The install scripts then pick up the new release automatically.

If a tag push doesn't trigger a run (e.g. the tag was pushed together with the first push
of the repo), re-run it without re-tagging: Actions → Release → Run workflow, entering the
existing tag (e.g. `v0.1.0`).
