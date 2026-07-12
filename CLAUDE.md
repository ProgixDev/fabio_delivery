# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`fabio` is a Flutter food-delivery UI (Luxembourg market, French-language copy). It is a **front-end-only prototype**: there is no backend or network layer. All content is hard-coded mock data and all state lives in memory, so it resets on every launch.

## Commands

```bash
flutter pub get                       # install dependencies
flutter run                           # run on the connected device/emulator
flutter analyze                       # lint (flutter_lints + analysis_options.yaml)
dart analyze lib/features/<feature>   # scope analysis to one feature (used per-change, see Workflow)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
flutter build apk|ios|web|macos       # release builds
```

Dart SDK constraint: `^3.11.3`.

## Architecture

**Feature-first layout under `lib/`.** Each screen area is a self-contained feature folder with its own `screens/` and `widgets/` (and sometimes `models/`). Shared code is layered beneath:

- `lib/features/<name>/` — the app screens: `onboarding`, `shell`, `home`, `search`, `orders`, `favourites`, `profile`, `cart`, `restaurant`, `dish`.
- `lib/core/` — design system only: `theme/` (`AppColors`, `AppTheme`, `AppTextStyles`, `AppGradients`, `AppShadows`) and `constants/` (`AppSpacing`, `AppRadius`). Widgets pull colors/spacing/radii from here rather than hard-coding values — follow this when adding UI.
- `lib/shared/` — cross-feature reusable widgets (`asset_image`, `favourite_button`, `add_to_cart_button`, `price_text`, `shimmer_box`, etc.), the `FadeSlidePageRoute` transition, and animation helpers.
- `lib/models/` — plain immutable data classes (`Dish`, `Restaurant`, `FoodCategory`, `Promotion`, `CartLine`, `Order`).
- `lib/data/mock/mock_home_data.dart` — the single source of all catalog content (categories, restaurants, dishes, promotions). Change app content here.

**Navigation & app flow.** `main.dart` starts at `OnboardingScreen`, which `pushReplacement`s into `MainShell`. `MainShell` (`features/shell/`) is the persistent root: it holds a 5-tab `IndexedStack` (Home, Search, Orders, Favourites, Profile) via `HomeBottomNavigation`, and renders a `FloatingCartBar` above the nav bar whenever the cart is non-empty (on every tab). Detail screens (restaurant, dish, cart) are pushed as routes on top.

**State management: `provider` / `ChangeNotifier`.** Three providers are registered in a `MultiProvider` at the root of `main.dart`:
- `CartProvider` — cart lines; lines merge when the same dish is added with the same unit price (i.e. same size/extras config).
- `OrdersProvider` — order history; `placeOrder` moves cart contents into an `Order`. `activeCount` drives the Orders tab badge.
- `FavouritesProvider` — favourited dishes.

Read state with `context.watch<T>()` in `build`, mutate via `context.read<T>()`. Providers are deliberately mock/in-memory — there is no persistence.

## Assets

Images live under `assets/` in subfolders (`categories/`, `restos/`, `offers/`, `plats/`, `onboarding/`) registered in `pubspec.yaml`; onboarding uses Lottie JSON animations. Load bitmaps via the shared `AssetImage` widget. Fonts are Manrope via `google_fonts` (fetched at runtime, not bundled).

## Conventions

- **Daily report log:** every task is logged in `report/YYYY-MM-DD.md` under a `## Task: <name>` heading, noting the files touched and the result. When you complete a change, append an entry to today's report file (create it if missing).
- After editing a feature, run `dart analyze lib/features/<feature>` and confirm no issues — this is the established per-change verification step.
