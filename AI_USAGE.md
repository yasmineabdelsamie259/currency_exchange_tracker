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

- Outcome: Pending review
- Reason: The user requested a proposal; acceptance, edits, or rejection have not yet been provided. Fixed architectural constraints were treated as requirements, while recommended defaults remain proposals.
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

- Outcome: Pending review
- Reason: The design is proposed for user review; no acceptance of the visual has been provided yet.
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

- Outcome: Pending review
- Reason: Implementation requested and completed locally; user has not yet reviewed the resulting foundation.
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
