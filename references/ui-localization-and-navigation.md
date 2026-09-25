# UI, Localization, and Navigation

Use Flutter's [internationalization guide](https://docs.flutter.dev/ui/internationalization) and the matching `flutter-setup-localization` skill when available. Consult the Flutter agent-plugins catalog for relevant responsive-layout, layout-debugging, or declarative-routing skills when those tasks arise.

## Theme and visual consistency

- Configure application-wide visuals in one app theme consumed by `MaterialApp.router`: `ColorScheme`, `TextTheme`, component themes, and shared spacing/radius tokens or `ThemeExtension` values.
- Use semantic theme values such as `colorScheme.surface` and `colorScheme.onSurface`; avoid hard-coded colors, one-off font styles, and local `Theme` overrides that bypass app-wide changes.
- Configure light and dark `ThemeData` at the app boundary and use `themeMode` consistently. Components should obtain colors and styles from the active theme so adding dark mode does not require editing individual screens.
- Keep shared widgets visually coherent and accessible. Respect text scaling, contrast, focus, semantics, touch target size, and platform conventions.
- Use responsive constraints and adaptive layouts rather than assuming a single fixed screen size. Check long localized strings and right-to-left direction as part of layout decisions.

## Localization with Flutter gen_l10n

- Use `flutter_localizations`, `intl`, Flutter's `gen_l10n`, and ARB resources. Do not add a second localization framework without a concrete project requirement.
- For new apps, create `lib/l10n/app_en.arb` as the template and `lib/l10n/app_ja.arb` as the initial Japanese translation. Add further locales as product requirements define them.
- Enable `flutter.generate: true` in `pubspec.yaml` and add root `l10n.yaml` with `arb-dir: lib/l10n`, `template-arb-file: app_en.arb`, and generated output configured under the app source (commonly `lib/l10n/generated`). Keep generated output out of hand editing.
- Register `AppLocalizations.localizationsDelegates` and `AppLocalizations.supportedLocales` in `MaterialApp.router`. Configure locale resolution only when product behavior requires more than Flutter's normal supported-locale resolution.
- Define one UI-layer extension in a shared location, such as `lib/core/l10n/build_context_l10n.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:your_app/l10n/generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}
```

- Use `context.l.someKey` or `context.l.someMessage(value)` for all user-facing strings in widgets. Ensure the extension is imported where used; do not create duplicate `l` extensions in feature folders.
- Keep translated copy out of providers, repositories, and domain models. Expose semantic error/state information and resolve it to localized text at the presentation boundary.
- Add ARB descriptions and named placeholders for interpolated values. Use ICU plural/select support and locale-aware date, number, and currency formatting; do not concatenate translated fragments.
- Localize labels, validation and error messages, empty/loading states, dialogs, accessibility semantics, notifications, and app title where shown to users.
- Store a manually selected locale in app-level Riverpod state and persist it through an appropriate repository when required. Otherwise, follow the device locale.
- Test locale switching, missing/invalid translations, text expansion, right-to-left direction where supported, and large text scaling.

`context.l` is available only below the initialized localization scope. Avoid using it before `MaterialApp.router` has installed its delegates. If the app title needs translation, use `onGenerateTitle` with the provided context.

## Navigation with go_router

- Use `go_router` for declarative navigation and `go_router_builder` for generated typed route APIs. Put router setup and route definitions in the app/router area or alongside features when that matches the route ownership model.
- Define page routes with `GoRouteData` and builder annotations, include the generated part file, and run build_runner after route changes. Use generated route objects for normal navigation and represent path/query parameters as typed fields.
- Avoid scattering literal route paths or using string navigation for normal in-app transitions. A raw URI can still be appropriate when the application is intentionally handling a dynamic external link.
- Centralize auth redirects, error routes, deep-link behavior, and shared navigation shells in router configuration. Keep route-level authorization decisions explicit and testable.
- Use `ShellRoute` or `StatefulShellRoute` for persistent navigation shells when the UX calls for nested navigators. Keep navigation state out of unrelated feature providers.
- Localize route-generated titles and route errors in the UI boundary; route classes should not retain a `BuildContext` beyond framework callbacks.
