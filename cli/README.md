# fcn — the flutter-snippets CLI

A shadcn/ui-style `add` command for this store: pulls the store to your machine, then copies
just the components you ask for (and whatever they import) into your project, unchanged.

## Install

macOS / Linux, one-line installer (downloads the prebuilt `fcn` binary from the latest
GitHub Release, or builds from source if none matches your OS/arch yet):

```sh
curl -fsSL https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.sh | bash
```

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.ps1 | iex
```

For a private fork, or while developing the store locally, point `FCN_REPO` at it (used
only for cloning/pulling the snippet store, not the `fcn` binary itself):

```sh
git clone <repo-url> flutter-snippets
FCN_REPO=$(pwd)/flutter-snippets bash flutter-snippets/install.sh
```

Both scripts are idempotent — re-run them (or run `fcn upgrade`) any time to pull the
latest store and update the `fcn` binary. They install to `~/.fcn/bin/fcn` (`.exe` on
Windows), clone/pull the store to `~/.fcn/store`, and add `~/.fcn/bin` to your PATH
(`~/.zshrc` / `~/.bashrc` / `~/.profile` on macOS/Linux; the user PATH on Windows).

- `FCN_VERSION=v1.2.3` pins the install to a specific release instead of the latest.
- `FCN_BUILD_FROM_SOURCE=1` skips the prebuilt binary and compiles from source with Dart
  (also the automatic fallback when no release exists yet, or your OS/arch isn't built).

## Commands

```sh
cd your_app

fcn init --dir lib/ui/components                                    # writes fcn.json
fcn list                                                          # browse what's available
fcn add button confirm_dialog PrimaryButton                       # copy by file name or symbol
fcn diff                                                          # see what's changed since you copied
fcn docs                                                          # index of every component's usage doc
fcn docs button                                                   # print one component's usage doc
fcn upgrade                                                       # re-run the hosted installer
fcn --version                                                     # print the installed fcn version
```

- `fcn init` defaults to the store the installer cloned (`~/.fcn/store`). Pass `--source
  <path or git URL>` only to point at a fork or a local checkout of the store instead. If
  `--dir` isn't given and you're at an interactive terminal, it's asked for; otherwise it
  defaults to `lib/ui/components`.
- `fcn add <name...>` matches a name against a snippet file (`button`, `dialogs/confirm_dialog`)
  or a public symbol it exports (`PrimaryButton`, `showConfirmDialog`). When a bare name matches
  more than one file, pass `folder/name` instead. It follows relative imports to pull in
  whatever else a snippet needs, and adds any missing pub package with `flutter pub add`
  (skip with `--no-pub`). Existing files are left alone unless you pass `--overwrite`.
  `--dry-run` prints what would happen without touching anything.
- `fcn diff [name]` runs `git diff --no-index` between the store's current version and your project's copy,
  for the one snippet named, or every installed snippet when no name is given. Exits `0` when
  everything matches.
- `fcn docs [name]` shows a component's usage doc from `docs/components/`.
  - No name: an index of every component, grouped by folder, with its `use_when`/`avoid_when`
    and an `[installed]` mark for ones your `fcn.json` already lists. A component with no doc
    yet shows `(no doc)`.
  - A name (bare file name, `folder/name`, or a public symbol, resolved the same way as
    `fcn add`): the component's full doc.
  - `--json` on either form prints machine-readable JSON instead.
  - `--check` (for store maintainers and CI) validates every component has a doc, every doc
    has a component, and each doc's front matter is complete and accurate — no
    `use_when`/`avoid_when` missing, `symbols` matching the source file, and every `related`
    entry resolving. Prints one line per problem and exits `1`, or a summary and exits `0`
    when everything's in sync.
  - Resolves the store the same way as the other commands (`fcn.json`'s `source`, falling back
    to `~/.fcn/store`), plus its own `--source <path or git URL>` to point at a store directly
    without a `fcn.json`.

## fcn.json

Written by `fcn init` at the project root, next to `pubspec.yaml`:

```json
{
  "source": null,
  "dir": "lib/ui/components",
  "installed": { "buttons/button.dart": "<store commit sha>" }
}
```

`source` is `null` for the default store (`~/.fcn/store`, the one the installer cloned), or
a local path/git URL when you passed `--source`.

`installed` records where each file came from without editing the file itself; `fcn diff`
reads it to know what to compare.
