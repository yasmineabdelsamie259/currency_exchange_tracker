# Currency Exchange Tracker

Flutter mobile technical assessment project targeting Android and iOS.

## Current status

Home screen implemented with theme-driven light/dark styling, real latest/yesterday
requests, daily changes, BLoC state, persistent fallback, pull-to-refresh, retry,
and refresh on reconnect/app resume. Currency detail screens include independently loaded summaries and seven-day historical charts.

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
- `lib/features/exchange_rates/domain`: pure-Dart entities, repository contract, and use case.
- `lib/features/exchange_rates/presentation`: home page and list BLoC; detail BLoC, summary, shimmer, and interactive history chart.

The local source stores the last successful latest/previous payloads and fetch time
in a versioned document. The repository checks dates, inverts positive finite
rates, and returns cached data when fetching fails. Historical payloads use a separate bounded seven-date cache shared across all currencies. App startup performs one latest request and one
previous UTC calendar-date request; stale latest data has no daily change.
Connectivity events are retry hints, not proof of internet availability.

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

## GET request abstraction

`core/networking/http_client.dart` defines the GET-only `HttpClient` interface.
Remote data sources and shared dependency consumers use this contract, which
accepts a URI and returns a JSON object without exposing Dio types. `JsonClient`
implements it using Dio and preserves the existing error mapping. Optional
Dio cancellation remains an implementation-specific capability. No POST, PUT,
PATCH, or DELETE operations are exposed.

## Currency detail

Tap a currency to open `/currency/:code` with go_router. The detail screen uses
its own BLoC, preserving the current rate while history loads or fails. Direct
links fetch their own summary; unknown codes show a recovery link.

History requests the seven completed UTC dates before today, one request per date.
All seven payloads are shared between currencies and cached with original fetch
timestamps. Failed dates fall back to validated cached snapshots. A missing date
or currency produces a retryable chart error, never a fabricated/interpolated point.
Successful dates are persisted even when another request fails. Explicit refresh
bypasses in-memory reuse. The current-rate cache and history cache use separate keys.

The chart shows a shimmer while fetching (respects reduced motion), theme-derived
line/grid/text colors, padded axes that support flat series, and accessible day
selection. Summary and chart failures/retries are independent. Refresh runs on
reconnection and app resume. Light/dark and 320px/390px rendering are covered by
widget tests; device networking and platform persistence still need a device smoke test.

## Loading states

All initial content loading uses theme-driven shimmer placeholders. The home screen
uses a base-card and five-row skeleton; currency details use a summary-card skeleton;
and the historical chart uses a chart-shaped skeleton. Shimmer motion respects the
system reduced-motion setting. Refreshes retain loaded content so the interface does
not flash back to placeholders. Linear progress indicators are not used.
