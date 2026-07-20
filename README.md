# Rentdo — Flutter App

Production-ready Flutter client for the Rentdo property marketplace, built to
mirror the reference web UI (https://rentdonew.razinsoft.com). Material 3,
light + dark themes, Riverpod state management, GoRouter navigation, and a Dio
networking layer wired for a Laravel REST backend.

## Getting started

```bash
flutter pub get
flutter run
```

Configure the backend without touching code (defaults in `core/constants/app_config.dart`):

```bash
flutter run \
  --dart-define=API_BASE_URL=https://your-api.example.com \
  --dart-define=FLAVOR=prod
```

## Architecture

Data flows in one direction per the clean-architecture layering:

```
Repository  ->  API Service  ->  Model  ->  Provider (Riverpod)  ->  UI
```

- **Networking**: a single `ApiClient` (Dio) with an `AuthInterceptor` that
  attaches the Bearer token and transparently refreshes it on `401`, replaying
  the failed request. All errors are normalized to `ApiException`
  (network / timeout / validation / server), including Laravel `422` field errors.
- **Auth**: `flutter_secure_storage` holds access + refresh tokens.
  `AuthController` (Riverpod `Notifier`) owns session bootstrap, login, register
  and logout; the router redirects on auth-state changes.
- **State per screen**: Loading / Success / Empty / Error / Retry are handled
  explicitly (see `PropertyListController` and the shared `state_views.dart`).
- **Pagination**: `PaginatedResponse<T>` parses Laravel paginator responses;
  the list controller supports infinite scroll + pull-to-refresh.

## Structure

```
lib/
├── core/
│   ├── constants/   app_config, api_endpoints, app_strings
│   ├── network/     api_client, auth_interceptor, api_exception
│   ├── providers/   core_providers (DI), theme_provider
│   ├── services/    token_storage
│   ├── theme/       app_colors, app_text_styles, app_theme, spacing, radius, shadows
│   └── utils/       formatters, validators
├── features/
│   ├── auth/        login + register (models, screens, widgets, controllers, repository, services)
│   ├── onboarding/  splash + onboarding
│   ├── home/
│   ├── properties/  list + filters + detail (fully API-ready)
│   ├── saved/
│   └── profile/
├── shared/
│   ├── widgets/     PrimaryButton, AppTextField, CustomCard, NetworkImageWidget,
│   │                state_views (Loading/Empty/Error), SectionHeader, AppBadge,
│   │                AppSearchBar, AppShell (bottom nav)
│   ├── models/      api_response, paginated_response
│   └── extensions/  context_extensions
├── routes/          app_routes, app_router (GoRouter, centralized)
├── app.dart
└── main.dart
```

## API integration notes (Laravel)

- All endpoint paths live in `core/constants/api_endpoints.dart`.
- Auth expects `{ access_token, refresh_token, user }` (also accepts `token`).
- List endpoints expect `page`, `per_page`, plus filter params
  (`type`, `min_price`, `max_price`, `beds`, `baths`, `featured`, `verified`, `q`, `sort`).
- File upload is supported via `ApiClient.upload(FormData)`.
- No business logic is faked — every screen reads from repositories/providers
  that call the placeholder endpoints; point them at the real API and the UI
  fills in.
