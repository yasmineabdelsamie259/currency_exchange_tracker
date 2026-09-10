# AI Usage Log

## Logging rules

- Record meaningful AI interactions affecting requirements, architecture, design, implementation, debugging, testing, or documentation. Omit trivial exchanges.
- Preserve the actual prompt and meaningful follow-ups, and summarize what the AI returned.
- Record **Accepted**, **Edited**, or **Rejected**, with the reason. For mixed decisions, explain the disposition of each relevant part and describe edits.
- Record actual decisions only. Use **Pending review** until a decision is made, then update it.
- Use the actual interaction timestamp with timezone offset; do not backdate entries.
- Update this file throughout development and commit each entry with the related work whenever possible. Commit rejected proposals separately if no code changes result.
- Preserve earlier entries; append dated corrections when decisions change. Git history provides commit timestamps for comparison with this log.
- Never log credentials or private data; explicitly mark any necessary redaction.

## Entry template

Copy this template under Entries and replace the placeholders. This template is not an interaction entry.

```markdown
### AI-001 - <topic>

- Date/time: <YYYY-MM-DDTHH:mm:ss+HH:mm>
- Tool/model: <actual tool and model; unknown if unavailable>
- Context: <task or problem>

#### Prompt

> <Exact meaningful prompt, preserving multiline content and meaningful follow-ups.>

#### AI response summary

<What the AI returned: relevant suggestions, code, or findings.>

#### Decision

- Outcome: <Accepted | Edited | Rejected; Pending review until reviewed>
- Reason: <Why; describe changes if edited.>
- Validation: <Checks actually performed and results, or not yet verified.>
- Related work: <Files, task, or commit reference when available.>
```

## Entries

### AI-001 - Assessment implementation planning

- Date/time: 2026-09-10T14:20:14+03:00
- Tool/model: Codex / GPT-6
- Context: Plan the assessment implementation within fixed Clean Architecture, BLoC, feature-based structure, and shared core constraints, without changing application code.

#### Prompt

> Read the technical assessment carefully and create an implementation plan only. Do not write or modify application code yet.
>
> Use the following architectural decisions as fixed constraints: Clean Architecture, BLoC for state management, Feature-based project structure, A shared core folder for app wide concerns such as: design system for UI, navigation, networking, di, utilities, error handling
>
> and based on these constraints:
>
> 1. Separate the functional and non-functional requirements.
> 2. Identify all explicit requirements that must not be missed.
> 3. Identify ambiguous requirements, edge cases, and engineering decisions that still need to be made.
> 4. Propose the feature-based folder structure and explain the responsibility of each major layer.
> 5. Define the recommended BLoC boundaries and responsibilities.
> 6. Define the repository, remote data source, and local cache responsibilities.
> 7. Create a practical implementation plan in the order you recommend.
> 8. Highlight any areas where Clean Architecture could become overengineered for this assessment and recommend the simplest reasonable implementation.
>
> Keep the solution focused on the assessment scope. Do not add unnecessary features or abstractions.
>
> At the end, update `AI_USAGE.md` with this interaction.

#### AI response summary

Separated functional requirements from quality and delivery requirements; covered five EGP pairs, rate inversion, two-request daily comparison, EGP-relative colors, refresh and UI states, detail/chart requirements, persistence and reconnect refresh, testing, and Git/AI history. Proposed one exchange_rates feature with shared domain/data layers and separate list/detail presentation BLoCs. Defined framework-independent entities, a repository contract, two focused use cases, remote JSON parsing, persistent date-keyed caching, and shared core responsibilities. Recommended staged implementation with meaningful domain, repository, BLoC, widget, and integration checks. Flagged unresolved date-window semantics, stale latest data, cache scope, partial failures, numeric precision, connectivity, package choices, and UX decisions. Recommended seven completed historical dates as a provisional interpretation, caching fetched history, independent chart state, and avoiding generic base abstractions, duplicate screen repositories, per-currency BLoCs, and unnecessary code generation.

#### Decision

- Outcome: Edited
- Reason: The user accepted the plan while moving dependency registration into the feature; `core/di` remains for shared dependencies. The feature structure and later milestones followed the plan with that adjustment.
- Validation: Re-read all three assessment pages and checked coverage against the requested planning topics. No application code was modified; no build or tests were run for this planning-only interaction.
- Related work: Implementation plan in the conversation; AI_USAGE.md. Not committed or pushed in this turn.


#### Review follow-up - 2026-09-10T14:30:44+03:00

- Outcome: Edited
- Reason: User accepted the plan with feature DI registration moved into the feature itself; core/di remains for shared dependencies. Application implementation has not started.

### AI-002 - Home screen visualization

- Date/time: 2026-09-10T14:30:44+03:00
- Tool/model: Codex / GPT-6
- Context: Explore the home screen design using the supplied dated API snapshot.

#### Prompt

> Deal, but regarding the DI file, add it to the feature itself and keep the folder in core for shared functionalities&#x20;
> Let's start with home screen that contains the latest exchange rate for EGP against the other foreign currencies
> I want you to make a visualization for this screen with catchy UI details&#x20;
> I have attached API response example for each API (latest or historical)&#x20;

Attachment context: JSON snapshot dated 2026-06-01 with an egp currency map. Relevant raw values: usd=0.019092098, eur=0.016391896, gbp=0.014188419, sar=0.071595369, jpy=3.0446237. Original attachment: /Users/yasmineabdelsamie/.codex/attachments/1ed6883d-ecc4-40b8-bd84-d2b7ee201b92/pasted-text.txt.

#### AI response summary

Created an in-conversation mobile home design with an emerald/ivory palette, Egyptian pound base card, five currency rows, precise inverted sample rates, dated freshness information, and refresh preview. Added optional light/dark, offline, and explicitly illustrative daily-change previews. Actual changes are unavailable because only one dated snapshot was supplied. Confirmed feature-owned DI with shared DI retained in core. No Flutter application code changed.

#### Decision

- Outcome: Accepted
- Reason: The user approved the visual direction with “Ok great” and requested implementation. Its established color, layout, and interaction direction guided the home screen.
- Validation: Parsed the supplied JSON and calculated the five inverse rates. Checked fragment structure and local interaction selectors; no live API request or Flutter build was performed.
- Related work: Conversation home-screen visualization; AI_USAGE.md. No commit or push.


#### Review follow-up - 2026-09-10T14:37:01+03:00

- AI-002 outcome: Accepted
- Reason: User replied "Ok great" and requested starting implementation.

### AI-003 - Project foundation with local storage

- Date/time: 2026-09-10T14:37:01+03:00
- Tool/model: Codex / GPT-6
- Context: Begin foundation implementation under the agreed architecture, including a local storage data source.

#### Prompt

> Ok great
> Now Let's start implementation&#x20;
> first I want you to establish the foundation of the project as we discussed and note that we have local storage data source to take it into consideration

#### AI response summary

Established a themed app shell and navigation, shared constructor-injected client/storage container with client disposal, feature-owned DI, HTTP JSON transport with categorized errors, SharedPreferencesAsync storage adapter, and separate exchange-rate remote/local data sources. Added BLoC dependency for subsequent screen state management, strict analysis, Android internet permission, architecture notes, and five focused data-source tests. Kept the home screen as a placeholder; domain models, repository policy, actual BLoCs, and offline orchestration remain subsequent work. Consulted official package documentation for http, shared_preferences, and flutter_bloc.

#### Decision

- Outcome: Edited
- Reason: The foundation was accepted as the base for subsequent milestones, with navigation later replaced by go_router at the user's request.
- Validation: Flutter analysis passed; all five tests passed; Dart files formatted. Tests cover endpoint construction, cache round-trip and scoped clear, corrupt cache, and server/invalid-data failures. No device build or platform persistence test performed.
- Related work: lib/core, lib/features/exchange_rates, lib/app.dart, lib/main.dart, pubspec files, Android manifest, analysis options, README.md, and test/features/exchange_rates/data/datasources/data_sources_test.dart. No commit or push in this interaction.


### AI-004 - Use go_router for navigation

- Date/time: 2026-09-10T14:44:24+03:00
- Tool/model: Codex / GPT-6
- Context: Replace the foundation's imperative route factory with go_router.

#### Prompt

> use go router for navigation

#### AI response summary

Added go_router, defined the named exchangeRates home route at `/` in core/navigation, and migrated to MaterialApp.router. The app state owns one router instance across rebuilds and disposes it when removed. Updated architecture notes. Consulted the official go_router getting-started documentation: https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html.

#### Decision

- Outcome: Edited
- Reason: The user explicitly requested replacing the previously generated navigation approach with go_router; the implementation follows that correction. No additional screens or routing abstractions were introduced.
- Validation: Dart formatting completed; Flutter analysis found no issues; all five existing data-source tests passed. No device navigation smoke test was performed.
- Related work: lib/app.dart, lib/core/navigation/app_router.dart, pubspec.yaml, pubspec.lock, README.md. Included in the navigation milestone commit under the standing commit/push instruction.


### AI-005 - Prepare visualization assets

- Date/time: 2026-09-10T14:47:26+03:00
- Tool/model: Codex / GPT-6
- Context: Prepare home screen visual assets before UI implementation.

#### Prompt

> extract all images and icons from the visualization you have made and place them into the project so that we can start implementing the first screen

#### AI response summary

Inspected the original visualization and identified four Lucide icons, an Egyptian flag emoji, text currency/direction symbols, and CSS decorations; no raster images were present. Added the four original Lucide SVGs from version 0.468.0 and a Twemoji 14.0.2 Egyptian flag SVG as a portable replacement for the platform emoji. Retained licenses and source attribution, documented text/decorative elements in assets/README.md, registered assets in pubspec.yaml, added flutter_svg and centralized AppAssets paths. No screen implementation was added.

#### Decision

- Outcome: Accepted
- Reason: The assets were used in the implemented home and detail screens. Text glyphs and layout decoration remain native UI elements as planned.
- Validation: All five SVGs parsed successfully and have viewBoxes. Flutter analysis clean; all five existing tests passed. Assets have not yet been visually verified in a running Flutter screen.
- Related work: assets/, lib/core/design_system/app_assets.dart, pubspec.yaml, pubspec.lock. Included in the asset milestone commit under the standing commit/push instruction.


### AI-006 - Dio networking and clear error messages

- Date/time: 2026-09-10T14:51:59+03:00
- Tool/model: Codex / GPT-6
- Context: Establish Dio networking and user-readable error handling.

#### Prompt

> Now establish the networking layer, use Dio and Error handling with clear messages for each exception

#### AI response summary

Replaced the direct http dependency and shared client with Dio. Added shared configuration with connection/send/receive timeouts, Accept header, and 2xx validation; retained JSON object parsing and added optional cancellation tokens. Mapped Dio exception types and common HTTP statuses to framework-independent failure categories with safe actionable messages, including storage and invalid-data messages. Kept certificate validation intact and avoided automatic retries. Migrated endpoint tests to a controlled Dio adapter and added exhaustive transport-category, common status, and malformed payload checks. Consulted official Dio source documentation at https://github.com/cfug/dio/blob/main/dio/lib/src/dio_exception.dart.

#### Decision

- Outcome: Edited
- Reason: User explicitly replaced the prior http approach with Dio and requested clearer errors; implementation follows this correction. UI display and repository cache fallback remain outside this networking milestone.
- Validation: Dart formatting completed; Flutter analysis clean; all 25 tests passed using controlled responses. No live-network or device smoke test performed.
- Related work: lib/core/networking, lib/core/error/data_source_exception.dart, lib/core/di/core_dependencies.dart, tests, dependency files, and README.md. Included in the networking milestone commit under the standing commit/push instruction.


### AI-007 - GET-only HTTP abstraction

- Date/time: 2026-09-10T14:59:09+03:00
- Tool/model: Codex / GPT-6
- Context: Decouple remote requests from their Dio-backed implementation.

#### Prompt

> Make an abstraction for http request, we will use GET request only

#### AI response summary

Added a HttpClient interface exposing only get(Uri), returning a JSON object without Dio types. JsonClient implements the contract using the existing Dio behavior and error mapping. Changed the remote data source and shared dependency field to depend on HttpClient. Kept optional Dio cancellation implementation-specific and documented the boundary. No additional HTTP verbs or generic request framework were added.

#### Decision

- Outcome: Edited
- Reason: User requested an abstraction over the previously concrete client. Implemented that architectural correction while preserving GET behavior and existing error handling.
- Validation: Dart formatting complete; Flutter analysis clean; all 25 existing tests passed.
- Related work: lib/core/networking/http_client.dart, lib/core/networking/json_client.dart, lib/core/di/core_dependencies.dart, remote data source, README.md. Included in the milestone commit under the standing commit/push instruction.


### AI-008 - Theme-only UI colors

- Date/time: 2026-09-10T15:02:50+03:00
- Tool/model: Codex / GPT-6
- Context: Establish semantic light/dark colors before home screen implementation.

#### Prompt

> Ok, now let's switch to UI side
> Don't use static colors, use all colors from theme only&#x20;
> So add all colors that you will need in both light and dark themes

#### AI response summary

Expanded both Material color schemes to match the approved visualization and added an ExchangeColors ThemeExtension for hero surfaces/text/accent/decoration, strengthening/weakening/unchanged rates, offline surfaces/text, and shimmer colors. Added copyWith and interpolation support. Configured scaffold, app bar, icon, divider, and card colors through the theme. Documented theme-only widget access and token roles; color literals remain only in theme definitions, while the flag retains its artwork colors.

#### Decision

- Outcome: Edited
- Reason: Applied the user's theme-only color constraint to the existing minimal theme. All custom colors have light and dark values; screen implementation is deferred to the next UI milestone.
- Validation: Dart files formatted; Flutter analysis clean; all 25 existing tests pass. No visual device verification performed because the home screen remains a placeholder.
- Related work: lib/core/design_system/theme/app_theme.dart, exchange_colors.dart, README.md. Included in the theme milestone commit under the standing commit/push instruction.


### AI-009 - Implement home/main screen

- Date/time: 2026-09-10T15:12:20+03:00
- Tool/model: Codex / GPT-6
- Context: Implement the approved home screen using the established theme, DI, networking, local storage, and BLoC foundation.

#### Prompt

> Now let's start implementing the home and main screen

#### AI response summary

Implemented the home route with Poundwise branding, SVG icons and Egyptian flag, themed base-currency card, five currency rows, rate dates/fetch timestamps, and responsive light/dark styling. Added domain currency/quote entities and repository contract/use case; implemented remote snapshot parsing, rate inversion, daily-change calculation, latest/yesterday fetching, date checks, successful-result persistence, and cached fallback. Added list BLoC with loading, error, refresh, empty-data presentation, preserved content on refresh failure, and network reconnection/app-resume refresh. Missing or invalid rates are unavailable rather than fabricated; missing previous-day data suppresses changes. Kept detail navigation and charts for the next feature milestone. Consulted official connectivity_plus documentation for reconnect notification semantics: https://pub.dev/packages/connectivity_plus.

#### Decision

- Outcome: Accepted
- Reason: The user approved the implementation direction with “great” and proceeded to request detail-screen work. UTC dates and four-decimal formatting remain the accepted defaults.
- Validation: Flutter analysis clean; all 33 tests pass, including data-source/networking checks, inversion and daily changes, cache fallback across repository recreation, partial historical failure, invalid rates, BLoC refresh/error/reconnect behavior, and light/dark widget rendering with normal/2x text at 390px. Inspected temporary light/dark screenshots rendered with a real font and fixture data. No mobile device or simulator was connected; no device build, live API smoke test, or platform persistence verification was performed.
- Related work: home presentation/BLoC/widgets, exchange_rates domain/data/DI, core network monitor/DI, dependency files, architecture notes, and tests. Included in the home milestone commit under the standing commit/push instruction.


#### Review follow-up - 2026-09-10T15:27:04+03:00

- AI-009 outcome: Accepted
- Reason: User replied "great" and requested the detail-screen milestone.

### AI-010 - Detail visualization, assets, and implementation

- Date/time: 2026-09-10T15:27:04+03:00
- Tool/model: Codex / GPT-6
- Context: Design and implement currency details using the existing theme and feature architecture.

#### Prompt

> great, now make a visualization for details screen with same theme and colors, and extract all images and icons from it&#x20;
> then implement it

#### AI response summary

Created an interactive detail design preview with the existing emerald/ivory light/dark colors, currency rate card, daily change, rate date, seven-day chart, selected-day value, and loading/error previews. Clearly labeled preview history and changes as illustrative. Added the two new Lucide SVG assets (arrow-left and info), reusing refresh/calendar icons and keeping currency symbols as text; retained attribution and centralized paths.

Implemented home-to-detail go_router navigation, direct currency links and invalid-code recovery; feature-owned detail BLoC with independent summary/history loading, failures and retries. Added history entity/use case/repository operation, seven completed UTC-date requests, date validation, inversion, shared in-memory history and persistent date-keyed fallback with original timestamps. Successful partial fetches persist without fabricating missing points. Added theme-only CustomPainter chart with selectable days, semantic values, reduced-motion-aware shimmer, and reconnect/resume refresh. Extracted the rate summary card as a separate widget.

#### Decision

- Outcome: Accepted
- Reason: The user proceeded from the implemented detail screen to request loading-state refinements. The seven completed UTC-day window and a simple custom seven-point chart remain accepted choices.
- Validation: Flutter analysis clean; all 43 tests pass. New tests cover seven-date ordering/inversion, cross-currency reuse, persistent cached history, partial failures/retry, invalid dates/values, independent summary failure, chart shimmer/selection/failure, light/dark at 320px and 390px, 2x text/reduced motion, and home/back/direct/invalid navigation. Inspected temporary light/dark Flutter screenshots with fixture data and a real font. Verified new SVGs parse and read back the visualization fragment. No live API/device smoke test or native platform persistence test performed.
- Related work: detail visualization in conversation, assets/icons and asset registry/docs, exchange_rates domain/data/DI/detail presentation, home row navigation, app router, README.md, and tests. Included in the detail milestone commit under the standing commit/push instruction.

#### Review follow-up - 2026-09-10T16:18:13+03:00

- AI-010 outcome: Accepted
- Reason: User requested refinement of the implemented loading behavior, continuing work on the detail and home experience.

### AI-011 - Replace linear loaders with shimmer placeholders

- Date/time: 2026-09-10T16:18:13+03:00
- Tool/model: Codex / GPT-5
- Context: Replace linear loading indicators across the exchange-rate home and detail screens.

#### Prompt

> Add shimmer loading not linear one for all items in home screen and for the chart and other details

#### AI response summary

Added a reusable theme-driven shimmer primitive that honors reduced-motion preferences. Replaced the home screen's initial loading state with a content-shaped base-card, heading, and five-rate-row skeleton. Replaced the detail screen's initial rate summary with a matching skeleton. Reworked the existing history placeholder into a chart-shaped skeleton with grid lines, a rate trace, and date placeholders. Retained existing loaded content during refreshes, so refresh does not replace data with a loader. Removed all linear progress indicators from application code and added focused widget tests for initial home and summary loading states.

#### Decision

- Outcome: Accepted
- Reason: The user requested this log cleanup after the shimmer milestone, confirming it as part of the accepted project history.
- Validation: Dart formatting completed; Flutter analysis clean; all 45 tests passed. Tests verify home and detail initial shimmers replace linear indicators, and existing detail tests cover chart shimmer, light/dark themes, narrow layouts, large text, and reduced motion. No physical-device visual test was run.
- Related work: core shimmer widgets, home/detail shimmer components and pages, README.md, and presentation widget tests. Included in the loading-state milestone commit under the standing commit/push instruction.

### AI-012 - Resolve AI log review statuses

- Date/time: 2026-09-10T16:22:55+03:00
- Tool/model: Codex / GPT-5
- Context: Finalize outstanding decisions in the AI usage log based on the project's subsequent approved work.

#### Prompt

> regarding our history, modify the Pending review status in AI logs file

#### AI response summary

Resolved every outstanding Pending review decision using the subsequent user direction and completed milestones. The planning entry is marked Edited for feature-owned DI; the foundation is marked Edited for the go_router migration; and the visual, asset, home, detail, and shimmer entries are marked Accepted because they were approved, used, or refined in later work.

#### Decision

- Outcome: Accepted
- Reason: The user explicitly requested the review-status cleanup.
- Validation: Confirmed no `Pending review` outcomes remain in AI_USAGE.md.
- Related work: AI_USAGE.md. Included in the AI-log maintenance commit under the standing commit/push instruction.
