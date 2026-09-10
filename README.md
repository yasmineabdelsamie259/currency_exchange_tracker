# Currency Exchange Tracker

Flutter mobile technical assessment project targeting Android and iOS.

## Current status

Project scaffold only. `lib/main.dart` is the unmodified Flutter empty-template entry point. Assessment features have not been implemented.

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
