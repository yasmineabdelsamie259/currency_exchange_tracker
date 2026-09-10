# Home screen assets

Extracted asset inventory from the approved `exchange-home` visualization.

| Visualization element | Project asset / implementation |
| --- | --- |
| Brand exchange arrows | `icons/arrow-left-right.svg` |
| Refresh button | `icons/refresh-cw.svg` |
| Rate date | `icons/calendar-days.svg` |
| Pull-to-refresh arrow | `icons/arrow-down.svg` |
| Egyptian flag emoji | `images/egypt-flag.svg` (portable Twemoji replacement; platform emoji appearance varies) |
| USD, EUR, GBP, SAR, JPY symbols | Render as text: `$`, `€`, `£`, `ر.س`, `¥` |
| Daily-change arrows | Render as text: `↓` and `↑` |
| Poundwise wordmark | Render as text; the arrow icon above supplies its mark |
| Hero rings, icon tiles, borders, home indicator | Layout decoration, not image assets |

No photos or raster images were present in the visualization. SVG icons retain
`currentColor`; apply a Flutter SVG color filter using the current theme when
rendering them. Keep the flag's original colors. Use `AppAssets` for paths.

## Sources and licenses

- Lucide 0.468.0: https://github.com/lucide-icons/lucide/tree/0.468.0/icons
  Original icon SVGs; ISC license and included Feather MIT notice retained in
  `licenses/lucide.txt`.
- Twemoji 14.0.2, copyright Twitter, Inc. and other contributors:
  https://github.com/twitter/twemoji/blob/v14.0.2/assets/svg/1f1ea-1f1ec.svg
  Unmodified flag artwork licensed CC BY 4.0:
  https://creativecommons.org/licenses/by/4.0/
  Full license retained in `licenses/twemoji-graphics.txt`.

Include these attribution notices in the app's licenses/credits at delivery.
