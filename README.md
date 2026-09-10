# Currency Exchange Tracker

Flutter mobile technical assessment project targeting Android and iOS.

## Current status

Foundation established: application shell, light/dark theme, routing, constructor injection, shared Dio networking and persistent key-value adapters, and feature-owned remote/local data sources. The screen remains a placeholder. Rate models, repository policy, BLoCs, UI, and offline refresh behavior are not implemented yet.

## Assessment scope

- Display USD, EUR, GBP, SAR, and JPY against EGP, with currency names, codes, rates, and absolute/percentage daily changes.
- Fetch latest and yesterday's rates in two requests; support pull-to-refresh and loading, error, and empty states.
- Invert API values to show EGP per one foreign currency unit. Green indicates EGP strengthening; red indicates EGP weakening.
- Provide a detail screen with current rate, daily change, last update date, and a seven-day line chart from seven historical dates. Use shimmer while the chart loads and friendly error/empty messages.
- Persist fetched rates, show cached data and its last update when offline, and refresh automatically when connectivity returns.
- Use layered architecture and domain-driven BLoC separation, categorized exceptions, meaningful tests, polished UX, and incremental Git commits.

All API requests use `egp.json`: latest rates at `https://latest.currency-api.pages.dev/v1/currencies/egp.json`, and historical rates at `https://{YYYY-MM-DD}.currency-api.pages.dev/v1/currencies/egp.json`. The assessment describes daily updates and no API key requirement.

## Setup

```sh
flutter pub get
flutter run
```

## AI usage

See [AI_USAGE.md](AI_USAGE.md). Record meaningful interactions throughout development with prompts, response summaries, decisions, and reasons, alongside related commits.

## Architecture

- `lib/core/di`: shared Dio client/storage ownership and disposal.
- `lib/core/storage`: storage contract and SharedPreferencesAsync adapter.
- `lib/core/networking` and `lib/core/error`: JSON transport and categorized data-source exceptions.
- `lib/core/design_system`, `navigation`, `utilities`: app theme, go_router configuration, and date formatting. The app owns and disposes its router; the home route is `/`.
- `lib/features/exchange_rates/di`: feature dependency construction; future repository/use-case/BLoC factories belong here.
- `lib/features/exchange_rates/data/datasources`: latest/historical EGP requests and versioned local JSON document persistence.
- `lib/features/exchange_rates/domain`: reserved pure-Dart boundary for entities, repository contract, and use cases.
- `lib/features/exchange_rates/presentation`: placeholder home page; future list/detail BLoCs belong here.

The local source stores one versioned feature document. The future repository will own date indexing, API dates versus fetch timestamps, retention, schema validation, and fallback. Storage does not clear unrelated preferences. Missing cache returns null; malformed JSON produces a categorized failure. No requests run at app startup yet.

## Validation

```sh
flutter analyze
flutter test
```

Foundation tests use controlled HTTP responses and an in-memory storage implementation. They do not verify platform persistence on a device.

## Networking and errors

Dio is configured with 15-second connection, send, and receive timeouts, JSON
accept headers, and 2xx status validation. JsonClient returns JSON objects and
accepts an optional cancellation token. Core DI owns and closes Dio.

DataSourceException exposes a typed kind, optional HTTP status, and a safe message.
Mappings distinguish connection/send/receive/transform timeout, connection failure,
certificate failure, cancellation, unauthorized/forbidden/not-found/rate-limited
responses, other request errors, server failures, invalid JSON, storage, and unknown
failures. Raw response/error strings are never used as UI messages. Cancellation
should be ignored by future BLoCs when leaving a screen. No automatic retries or
certificate bypasses are configured. Cache fallback remains repository work.
