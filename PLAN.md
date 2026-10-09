# malkiab — Phase Plan

Soft-glam cosmetics boutique mobile app, built on the Beautify Flutter skeleton.

- **Target dir:** `/home/dot/Documents/projt/beautify`
- **Tooling:** Flutter 3.19.6 / Dart 3.3.4 at `/opt/flutter`
- **Stack kept:** Bloc (per-feature) + GetX (DI/controllers) + Hive caching + MVVM layout (`view` / `viewmodel` / `model` / `configs`)
- **Design direction:** Soft glam / rose — blush, mauve-rose, champagne gold, espresso text; Playfair Display + Manrope
- **Data:** Mock/local repository behind the existing `HomeDataSource` interface (real API swappable later)
- **Navigation:** 4 tabs — Home / Shop / Cart / Profile
- **Brand name:** malkiab (single `AppStrings.brandName` constant)

> Keep this file updated as phases progress. Check items off as they finish.

---

## Phase 0 — Baseline

- [x] Clone repo into `projt/beautify`; `/opt/flutter/bin` on PATH for sessions
- [x] `flutter pub get` + `flutter analyze` → inventory pre-existing issues
- [x] Fix baseline breakage (dead code, unpinned deps, `provider` transitive import) so we start from 0 errors — result: 0 errors, 0 warnings (128 style infos remain in files to be rewritten)

## Phase 1 — Mock data layer

- [x] Extend `ProductEntity` with `brand`, `category`, `rating`, `shades[]`, `badge`, `isFeatured`; regenerate Hive `.g.dart` via build_runner
- [x] New `MockHomeDataSource implements HomeDataSource`: ~30 curated products (32 products, 4 banners, 7 categories, 3 collections; all Pexels URLs verified 200) (Lips/Face/Eyes/Skincare/Tools), banners, collections, category chips; keyword filtering for search; simulated latency for loading states
- [x] Swap DI in `InitialController`/`HomeController` to mock source — `HomeRepository` interface untouched (dead `makeup-api.herokuapp.com` retired)
- [x] Mock auth session + orders/addresses/favourites — verified already fully local (GetStorage/Hive); exercised in Phase 5 tests
- [x] Product images: 32 curated Pexels URLs (verified); placeholder fallback widget lands in Phase 2 design kit

## Phase 2 — Design system (rewrite `lib/configs/` + new kit)

- [x] **Palette:** light — cream `#FAF5F2` scaffold, white surfaces, rose `#B76E79` primary, champagne `#D9B98C` accent, espresso `#3B2B30` text; dark — deep plum `#171214` with rose/gold pops
- [x] **Type:** `google_fonts` — Playfair Display (display) + Manrope (UI/body), full scale & letter-spacing in `app_typography.dart`
- [x] **Space/radius/shadow:** retained Space/AppDimensions API; radii 16/24/pill + rose-tinted layered shadows (`ui_props.dart`)
- [x] **ThemeData:** complete ColorScheme + component themes (transparent AppBar, pill buttons, soft filled inputs, chips, cards, sheets, dialogs, snackbar) in `core_theme.dart` — light + dark
- [x] **Component kit** in `lib/view/widgets/design/`: `GlowButton`, `SoftCard`, `PillChip`, `SectionHeader`, `ProductCard` (badge/heart/shades/price), `ShimmerBox`, `RatingStars`, `QtyStepper`, `PriceText`, `ProductImage` (cached + shimmer + fallback), `EmptyState`, `AppTextField` + barrel `design.dart`
- [x] **New deps:** `google_fonts` 6.3.0, `flutter_animate` 4.5.2 added; rest of pubspec kept

## Phase 3 — Shell & onboarding

- [x] Rebrand all strings/splash/title to **malkiab** (`AppStrings.brandName`; main/home/landing titles, Android label, iOS display name, cream splash background, theme controller wired to `Get.changeThemeMode`)
- [x] Custom **4-tab bottom bar**: Home / Shop / Cart / Profile — frosted glass, animated pill indicator, live cart badge (`malkiab_bottom_bar.dart`, replaces `BottomNavyBar`); cart box pre-opened in `HighPriorityInitial` to avoid listenable race
- [x] Onboarding/landing rebuilt: full-bleed imagery, gradient scrim, animated dots, Playfair wordmark, skip/continue pills
- [x] Shop tab v1 created (`shopscreen/shop_tab_screen.dart`) — category pills, sort chips, grid, shimmer skeleton, empty state

## Phase 4 — Rebuild every screen (bloc logic preserved, UI replaced)

- [x] **Home** — greeting header, search entry, category pills, autoplay hero carousel, "Trending" rail, curated collection cards, bestseller grid, pull-to-refresh, shimmer skeleton
- [x] **Shop** (tab) — all products, category pills, sort chips, shimmer/empty states, live search entry, deep-link category requests from Home
- [x] **Search** — modern field, trending/popular discovery chips, live results, empty/error states, `initialQuery` deep-links from Home collections
- [x] **Product details** — gallery w/ page dots, shade selector, expandable description, rating, sticky add-to-bag bar, share/wishlist, delivery note
- [x] **Cart** — grouped lines w/ QtyStepper (+/−/remove), floating summary (subtotal/delivery/total), empty/error states; qty = repeated Hive entries (`quantityOf`/`increment`/`decrement`/`removeProduct`)
- [x] **Checkout** — address radio cards + shared address sheet, delivery options (Standard/Express), summary, login gate, address-required guard → Payment
- [x] **Payment** — mock method selection (Card/Wallet/COD), order details card, confirm dialog, order saved + cart cleared, animated success screen (custom scale/check, no Lottie)
- [x] **Profile** — gradient identity card w/ avatar picker badge, quick tiles, dark-mode switch, account menu, sign-in/out dialogs, version footer
- [x] **Auth** — refined login/signup w/ animated header + mode pill, validation via existing blocs, remember/forgot, reset-credentials dialog (social buttons skipped — out of scope)
- [x] **Favourites** — reactive heart grid (removal → snackbar → bloc refresh), empty state → Shop
- [x] **Orders + order detail** — newest-first cards, status timeline, buy-again → bag
- [x] **Address list + add/edit** — cards w/ edit/delete, shared bottom sheet (`widgets/address_sheet.dart`), empty/error states
- [x] Retire the legacy shared widgets: **23 files deleted** (duplicate template, lottie empty/loading/exception, horizontal product views, badges, legacy bottom sheets, textfield, etc.); only `address_sheet.dart` + `design/` remain
- [x] Polished transitions (flutter_animate entrances), empty/error/loading states everywhere, light+dark parity via theme
- [x] Dead dependency purge: removed lottie, badges, auto_size_text(+field), barcode, flutter_svg, dropdown_button2, flutter_staggered_grid_view, bottom_navy_bar, flutter_rating_bar, intro_slider, loading_animation_widget, shared_preferences + `PaymentFunctions`

## Phase 5 — Verification

- [x] `flutter analyze` → 0 issues ("No issues found!")
- [x] Smoke widget tests: app boots, home renders mock catalog, cart add/remove works → `flutter test` (6/6 pass)
- [x] Compile check via `flutter build web --release` → EXIT=0 (no Android SDK on this machine — APK builds aren't possible here)

---

## Notes

- `google_fonts` fetches fonts on first run (cached after); images need network
- Original `makeup-api.herokuapp.com` backend is dead — mock layer replaces it
- Verification strategy: analyze + tests + web build (no Android SDK available)

## Change log

| Date | Change |
|------|--------|
| 2026-10-09 | Plan created; Phase 0 started (repo cloned) |
| 2026-10-09 | Phase 0 done: 0 errors / 0 warnings after baseline import cleanup |
| 2026-10-09 | Phase 1 done: extended ProductEntity (14 Hive fields), MockHomeDataSource + catalog, DI swapped |
| 2026-10-09 | Phase 2 done: soft-glam theme (light+dark), Playfair/Manrope type, 12-widget design kit, google_fonts + flutter_animate |
| 2026-10-09 | Phase 3 done: malkiab branding, 4-tab frosted shell w/ cart badge, onboarding rebuilt, Shop tab v1 |
| 2026-10-09 | Phase 4 done: all 13 screens rebuilt (Home/Shop/Search/Detail/Cart/Checkout/Payment/Profile/Auth/Fav/Orders/OrderDetail/Address), 23 legacy widgets deleted, dead deps purged |
| 2026-10-09 | Phase 5 done: analyze 0 issues, 6 smoke tests pass (home overflow 96→110px fixed; test lints cleaned), web release build EXIT=0 |
