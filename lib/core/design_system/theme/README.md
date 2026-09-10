# Theme colors

All UI colors must come from `Theme.of(context).colorScheme` or
`Theme.of(context).exchangeColors` (import exchange_colors.dart).
Color literals are restricted to this theme directory. Do not use `Colors.*`,
hardcoded hex values, or static palette access from widgets.

| UI role | Theme token |
| --- | --- |
| Page background | colorScheme.surface |
| Currency icon tile / raised surface | colorScheme.surfaceContainerLowest |
| Main text / icons | colorScheme.onSurface |
| Secondary text | colorScheme.onSurfaceVariant |
| Dividers / subtle border | colorScheme.outlineVariant |
| Focus / prominent border | colorScheme.outline |
| Actions | colorScheme.primary / onPrimary |
| Error message | colorScheme.error |
| Hero and brand tile | exchangeColors.heroBackground / onHero |
| Hero badge / brand arrows | exchangeColors.heroAccent / onHeroAccent |
| Hero ring decoration | exchangeColors.heroDecoration |
| Negative rate change (EGP strengthens) | exchangeColors.strengthening |
| Positive rate change (EGP weakens) | exchangeColors.weakening |
| Zero/unavailable change | exchangeColors.unchanged |
| Offline notice | exchangeColors.offlineBackground / onOffline |
| Loading shimmer | exchangeColors.shimmerBase / shimmerHighlight |

Both themes define every custom role and support interpolation during theme changes.
Use color plus direction/text for daily change. Tint monochrome SVG icons with the
appropriate theme token; the Egyptian flag keeps its source artwork colors.
