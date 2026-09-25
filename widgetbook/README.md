# widgetbook

A [Widgetbook](https://pub.dev/packages/widgetbook) catalogue for browsing every widget in
the [flutter-snippets](../README.md) store. This app is a harness only — it imports the
store's `.dart` files by relative path (via a symlink at `lib/store`, see below) and is
never itself copied into a project.

## Running

```sh
cd widgetbook
flutter run -d chrome   # or: flutter run -d macos
```

## How it's wired to the store

Dart forbids a file under `lib/` from relatively importing anything outside its package's
`lib/` directory, so a plain `import '../../../components/buttons/button.dart';` from
`lib/use_cases/...` does not resolve. `lib/store` is a single symlink to the repo's
`components/` directory (`lib/store -> ../../components`). Use-case files then do an
ordinary relative import through that symlink, e.g.
`import '../../store/buttons/button.dart';`. No store file is copied, moved, or modified —
the symlink is the only thing living under `widgetbook/`. A new folder under `components/`
appears under `lib/store/` automatically, with no symlink to add.

## Adding a use case for a new snippet

1. Create `lib/use_cases/<folder>/<snippet>_use_cases.dart`, importing the snippet through
   `../../store/<folder>/<file>.dart`. For each public widget or show-function, write a
   `Widget xUseCase(BuildContext context)` "Default" use case using `context.knobs.*` for
   its meaningful parameters, plus extra named use cases only where a knob can't express a
   variant (e.g. a named constructor). A show-function (`showXDialog`, a picker, `Toast`)
   should render a button that triggers it.
2. Export a `final xComponents = [WidgetbookComponent(...)]` list from that file.
3. Add the file's import and its `xComponents` to `lib/directories.dart`, in the same
   folder and order as the root README's catalogue.
4. `flutter analyze` and `flutter build web` should stay clean.
