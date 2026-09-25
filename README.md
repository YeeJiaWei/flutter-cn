# flutter-snippets

A copy-in library of token-free Flutter widgets. The store itself is **not** a Dart
package — it has no `pubspec.yaml` and is never added as a dependency. (`widgetbook/` is a
separate Flutter app with its own `pubspec.yaml`, used only to browse the store; it is
never copied into a project — see below.)

## Install

macOS / Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.sh | bash
```

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.ps1 | iex
```

Then, quick start in a project:

```sh
cd your_app
fcn init          # writes fcn.json (source, dir)
fcn add button     # copy a snippet by name, folder/name, or symbol
```

See `cli/README.md` for the full command reference.

## Browsing the catalogue

`widgetbook/` is a [Widgetbook](https://pub.dev/packages/widgetbook) app that renders every
widget in this store with interactive knobs, so you can see a component before copying it.

```sh
cd widgetbook
flutter run -d chrome   # or: flutter run -d macos
```

See `widgetbook/README.md` for how it imports the store and how to add a use case for a
new snippet.

## Convention

1. Install `fcn`, the store's CLI, once per machine, then pull a snippet into your project
   with `fcn add` (see `cli/README.md`):
   ```sh
   curl -fsSL https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.sh | bash  # once
   cd your_app && fcn init --dir lib/ui/components                     # once per project
   fcn add base_dialog                                                 # like `npx shadcn add`
   ```
   `--source <store>` points `fcn init` at a fork or local checkout instead of the default
   store the installer cloned (`~/.fcn/store`).
   `fcn add` copies the file (and whatever it relative-imports) unchanged into your project
   and adds any pub package it needs. Without the CLI, copy the file by hand into the
   project's shared widgets folder (e.g. `lib/app/ui/shared/widgets/`) instead.
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

### components/buttons/

- `components/buttons/button.dart` — `ButtonSize`, `PrimaryButton`, `SecondaryButton`, `OutlineButton`,
  `PlainTextButton`. The four brand button variants sharing one internal `_Button` shell.

### components/cards/

- `components/cards/card.dart` — `SurfaceCard`. Rounded, padded surface with optional elevation
  shadow, optional outline, and optional tap ripple.

### components/chips/

- `components/chips/chip.dart` — `SelectableChip`. Pill-style chip with optional leading icon and
  selected state.
- `components/chips/tag_list.dart` — `TagList`. `Wrap` of `SelectableChip` with single- or multi-select.
- `components/chips/outline_chip.dart` — `OutlineChipVariant`, `OutlineChip`. Outlined rounded-rectangle
  chip for a single picked/displayed value, selectable outlined or brand-filled, with an
  optional trailing icon slot.

### components/dialogs/

- `components/dialogs/base_dialog.dart` — `BaseDialog` + `showBaseDialog<T>()`. A generic modal shell:
  a rounded, padded `Dialog` wrapping a `Column` of arbitrary children. No icon, no title, no
  buttons — those belong in the project's own widget built on top of this shell.
- `components/dialogs/dialog_icon.dart` — `DialogIcon`. Brand-colored circle icon slot for a dialog's
  illustration (icon or arbitrary child).
- `components/dialogs/confirm_dialog.dart` — `showConfirmDialog()`. Title/message `AlertDialog` with a
  confirm button and an optional cancel button, resolving to `true`/`false`/`null`.

### components/feedback/

- `components/feedback/badge.dart` — `CountBadge`. Small colored pill for counts/status markers.
- `components/feedback/empty_state.dart` — `EmptyState`. Icon-or-image + title + subtitle + optional
  CTA button placeholder.
- `components/feedback/loading.dart` — `LoadingIndicator`. Centered spinner with optional message.
- `components/feedback/rating_stars.dart` — `RatingStars`. 5-star rating, read-only or interactive with
  half-star precision.
- `components/feedback/skeleton.dart` — `Skeleton` (+ `.line`, `.avatar`, `.card` factories). Animated
  shimmer placeholder.
- `components/feedback/snackbar.dart` — `Toast`. Overlay-based top-anchored toast with slide/fade
  in-out and swipe-to-dismiss (`success`/`error`/`info`, each takes a `BuildContext`).
- `components/feedback/status_pill.dart` — `StatusPillVariant`, `StatusPill`. Read-only colored status
  chip, filled or outlined.

### components/inputs/

- `components/inputs/text_field.dart` — `FormTextField`. Labeled text input with hint/error/helper and
  prefix/suffix slots.
- `components/inputs/password_field.dart` — `PasswordField`. `FormTextField` with a show/hide toggle
  and a lock icon.
- `components/inputs/phone_field.dart` — `CountryCode`, `PhoneField`. Digits-only phone input with a
  fixed country-code prefix (defaults to `+60`).

### components/layout/

- `components/layout/app_bar.dart` — `TopBar`. `AppBar` wrapper with a back button (pop-or-fallback)
  and an optional wizard progress bar.
- `components/layout/divider.dart` — `FadingDivider`. Hairline divider that fades toward both ends.
- `components/layout/header_title.dart` — `HeaderTitle`. Standardised large page-title text style.
- `components/layout/page_header.dart` — `PageHeader`. Tab-page top bar matching `AppBar` geometry,
  title-or-leading plus trailing actions.
- `components/layout/page_dots.dart` — `PageDots`. Row of animated pill dots indicating the current page
  of a carousel.
- `components/layout/section_header.dart` — `SectionHeader`. Bold title with an optional trailing
  text link.
- `components/layout/list_tile.dart` — `InfoListTile`. 56px list row with leading icon/widget, title,
  subtitle, trailing slot.
- `components/layout/progress_stepper.dart` — `ProgressStepper`. Wizard progress bar as connected
  segments.
- `components/layout/pullable_empty.dart` — `PullableEmpty`. Makes an empty/error state scrollable so a
  parent `RefreshIndicator` still detects pull gestures.

### components/media/

- `components/media/avatar.dart` — `AvatarSize`, `Avatar`. Circular avatar with network image and
  initials fallback.
- `components/media/glass_label.dart` — `GlassLabel`. Frosted-glass pill label to overlay on imagery.
- `components/media/network_image.dart` — `NetImage`. `Image.network`-backed drop-in for a
  `CachedNetworkImage`-shaped API (placeholder/error builders).
- `components/media/svg_icon.dart` — `SvgIcon`. Thin sized, tintable wrapper over `SvgPicture.asset`.
  Needs `flutter_svg`.

### components/pickers/

- `components/pickers/dob_picker.dart` — `showDobPicker()`. Bottom-sheet day/month/year wheel picker.
- `components/pickers/height_picker.dart` — `showHeightPicker()`. Bottom-sheet single-column
  centimetre wheel picker.
- `components/pickers/year_picker.dart` — `showYearPicker()`. Bottom-sheet single-column year wheel
  picker, newest year first.
- `components/pickers/photo_crop_page.dart` — `PhotoCropPage`. Full-screen 4:3 portrait crop page.
  Needs `crop_your_image`.

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
