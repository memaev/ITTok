# CLAUDE.md — ITiktok (TikTok for IT)

This file is read by the Claude Code AI assistant before working on this project. Every section contains actionable rules. Follow them precisely.

---

## 1. Project Overview

**App name:** ITiktok
**Tagline:** TikTok for IT
**Platform:** Flutter (iOS, Android, Web, Desktop via `lib/`)
**State management:** Riverpod
**Routing:** go_router

### What ITiktok Is

ITiktok is a vertical-scroll micro-learning app for IT professionals and students. Users swipe through bite-sized educational cards — exactly like TikTok — but every card teaches a real IT concept, command, code snippet, quiz question, or best practice.

The core loop:
1. Open the app and start scrolling the feed.
2. Each card is a self-contained learning unit (30–90 seconds to consume).
3. Like, save, or swipe past.
4. Track progress by topic and maintain a daily learning streak.

### Mission

Make high-quality IT education as frictionless and addictive as social media. Zero onboarding friction. Immediate value on the first card. Every session should leave the user knowing something they did not know before.

### Target Audience

- **Primary:** Junior to mid-level developers and sysadmins (0–5 years experience) who want to fill knowledge gaps efficiently.
- **Secondary:** Students in CS/IT programs looking for practical, beyond-the-textbook content.
- **Tertiary:** Senior engineers who want quick refreshers on topics outside their main stack.

Do not write content for absolute beginners who have never opened a terminal. Assume the reader has at least written one line of code or configured one server.

---

## 2. Content Philosophy

### Core Principle

Every card must deliver a concrete, usable insight. Never publish a card that only defines a term. Cards must answer: "What do I do differently because I read this?"

### Tone

- **Direct.** No preamble. Lead with the value, not the context.
- **Confident but not arrogant.** State facts plainly. Avoid hedging phrases like "it might be worth considering."
- **Peer-to-peer.** Write as a senior engineer explaining something to a smart colleague, not as a professor lecturing a class.
- **Terse.** Every sentence must earn its place. If a sentence can be cut without losing meaning, cut it.

### What to Avoid

- Marketing language ("powerful," "amazing," "unlock the power of").
- Vague advice ("always follow best practices," "use the right tool for the job").
- Padding sentences that restate what was just said.
- Condescension ("as you may already know," "simply just").
- Walls of unbroken text — use bullet points, code blocks, or line breaks to break up body copy.

### Depth Calibration

Match depth to the `Difficulty` enum value:

| Difficulty     | Reader Assumption | Card Goal |
|----------------|-------------------|-----------|
| `beginner`     | Has heard the term, never used it in production | Explain the "why" and show the minimal working pattern |
| `intermediate` | Uses the tool daily, knows the basics | Show non-obvious behaviour, gotchas, or a superior pattern |
| `advanced`     | Comfortable with the tool at depth | Cover edge cases, internals, performance implications, or architectural trade-offs |

A beginner card must not assume knowledge introduced in an intermediate card. An advanced card should not explain fundamentals.

---

## 3. Topic Taxonomy

Topics are defined in `lib/data/seed/seed_data.dart` as `Topic` objects and grouped into categories. The category string drives display grouping in the Explore screen.

### Current Topics and Categories

| Topic ID         | Name            | Category       | Color (hex) |
|------------------|-----------------|----------------|-------------|
| `docker`         | Docker          | DevOps         | `#2496ED`   |
| `python`         | Python          | Languages      | `#FFD43B`   |
| `kotlin`         | Kotlin          | Languages      | `#7F52FF`   |
| `cybersecurity`  | Cyber Security  | Security       | `#FF4444`   |
| `networking`     | Networking      | Infrastructure | `#00C853`   |
| `git`            | Git             | Tools          | `#F05032`   |

### Reserved Topic IDs (defined in `TopicColors`, not yet seeded)

`linux`, `cloud`, `databases`, `architecture`, `web`, `reactnative`

When adding a new topic, always add it to both `SeedData.topics` and `TopicColors._colors`. The topic color must be the canonical brand color for that technology (e.g., React blue for React Native, PostgreSQL teal for databases).

### Category Rules

- **Languages** — Programming language syntax, idioms, standard library, runtime behaviour.
- **DevOps** — Containerisation, CI/CD, orchestration, infrastructure as code.
- **Security** — OWASP, vulnerabilities, encryption, authentication, secure coding patterns.
- **Infrastructure** — Networking protocols, DNS, subnets, OSI model, load balancers, cloud primitives.
- **Tools** — Developer tooling that crosses language boundaries (Git, shell, editors, package managers).

Do not create a new category unless no existing category is a reasonable fit. Prefer expanding existing categories over proliferating new ones.

### Topic Scope Guides

**Docker** — Dockerfile syntax and optimisation, multi-stage builds, layer caching, docker-compose, networking (bridge/host/none), volumes, health checks, Docker CLI, image security, BuildKit.

**Python** — Language features (comprehensions, generators, decorators, dataclasses), async/await, type hints, standard library modules, virtual environments, packaging, common idioms, performance patterns.

**Kotlin** — Coroutines, Flow, Compose UI, extension functions, sealed classes, data classes, KMP (Kotlin Multiplatform), null safety, scope functions, Android-specific patterns.

**Cyber Security** — OWASP Top 10, SQL injection, XSS, CSRF, JWT pitfalls, hashing vs encryption, TLS, secrets management, secure headers, input validation.

**Networking** — OSI layers, TCP vs UDP, DNS resolution, subnetting/CIDR, HTTP/HTTPS, WebSockets, load balancing, CDN, VPN, firewalls, common ports.

**Git** — Branching strategies, rebase vs merge, cherry-pick, stash, reflog, bisect, hooks, signed commits, monorepo patterns, conventional commits, CI/CD integration.

---

## 4. Card Content Guidelines

Card content lives in `lib/data/seed/seed_data.dart` as `ContentCard` objects. The `CardType` enum determines which widget renders the card.

### CardType Reference

| `CardType`    | Widget              | Required Fields                                                    | Use When |
|---------------|---------------------|--------------------------------------------------------------------|----------|
| `codeSnippet` | `CodeSnippetCard`   | `codeSnippet`, `language`                                          | The insight is best conveyed by reading runnable code |
| `tip`         | `TipCard`           | `body` (formatted prose or bullet list)                            | A rule, gotcha, or best practice with no mandatory code |
| `quiz`        | `QuizCard`          | `quizOptions` (3–4 items), `quizExplanation`                       | Testing recall or distinguishing between two similar concepts |
| `concept`     | `ContentCardWidget` | `body`                                                             | Explaining a mental model or system design idea |
| `command`     | `ContentCardWidget` | `codeSnippet`, `language: 'bash'`                                  | A terminal command or command sequence that is the entire point |
| `comparison`  | `ContentCardWidget` | `comparisonLeft`, `comparisonRight`, `comparisonLeftLabel`, `comparisonRightLabel` | Side-by-side contrast of two approaches, tools, or patterns |

### Field Rules

**`title`**
- 3–8 words maximum.
- No trailing punctuation.
- Must be specific enough to scan in a saved-cards list. Avoid generic titles like "Python Tips" — prefer "Python Walrus Operator: Assign Inside Expressions."

**`body`**
- `tip` cards: 40–120 words. Use bullet points (`•`) for lists. Do not use Markdown headers inside body strings — the card widget does not render them.
- `codeSnippet` and `command` cards: 1–3 sentences. The body is the explanation; the code block is the demonstration. Do not repeat what the code already shows.
- `concept` cards: 60–150 words. One idea per card. End with a concrete implication or rule of thumb.
- `quiz` cards: body is the question stem. Keep it under 25 words. Make it unambiguous — one reading, one correct interpretation.
- `comparison` cards: body is optional context. The `comparisonLeft` / `comparisonRight` fields carry the actual content. Keep each side under 80 words.

**`codeSnippet`**
- Must be copy-paste-runnable or clearly marked as pseudocode.
- No placeholder values like `YOUR_VALUE_HERE` without a comment explaining what to substitute.
- Maximum ~30 lines. If the snippet needs more, split it into two cards.
- Use the correct `language` string from the normalisation map in `CodeSnippetCard._normalizeLanguage`: `dockerfile`, `yaml`, `bash`, `python`, `kotlin`, `javascript`, `typescript`, `dart`, `http`, `json`, `sql`. Use `bash` as fallback for shell commands.
- Code must be syntactically correct. Run or mentally trace every snippet before adding it.

**`quizOptions`**
- Exactly 3 or 4 options per quiz card.
- Exactly one `isCorrect: true`.
- Wrong answers must be plausible — they should represent real misconceptions, not obvious nonsense.
- Option `id` values must be `'a'`, `'b'`, `'c'`, `'d'` in order.
- Option text: 5–20 words. Parallel grammatical structure across all options.

**`quizExplanation`**
- Required on every quiz card.
- 1–3 sentences. Explain why the correct answer is correct AND why the most tempting wrong answer is wrong.
- This text renders only after the user answers, so it can be slightly more detailed than body copy.

**`tags`**
- 2–4 tags per card. Lowercase, hyphen-separated (e.g., `multi-stage`, `best-practices`).
- Tags are displayed as `#tag` chips. They are used for discoverability, not categorisation — topics handle categorisation.
- Only the first 4 tags render in `TipCard._TagRow`. List the most discoverable tags first.

**`difficulty`**
- Every card must have an explicit `Difficulty` value. Do not default without intent.
- A topic's card set should cover all three difficulty levels. Do not add 10 intermediate cards before adding any beginner cards.

**`likes`**
- Seed data uses realistic mock values. Scale: 500–1000 for niche advanced cards, 1000–2500 for useful intermediate cards, 2500–4000 for widely applicable beginner/intermediate cards.
- Do not set likes below 200 or above 5000 in seed data.

### Content Accuracy Standard

Every technical claim must be verifiable against official documentation or a reproducible test. If a behaviour is version-specific, state the version. If a behaviour changed across versions, note the change. Do not write from memory alone on security or networking topics — verify specifics.

---

## 5. UX Copy Rules

### General Principles

- Use sentence case for all UI strings. Never title-case labels unless it is a proper noun or brand name.
- No exclamation marks except in genuine celebration moments (streak milestone, quiz correct answer).
- No ellipsis in button labels. Buttons describe actions, not pending states.
- Error messages must say what happened and what the user can do next. Never say "Something went wrong."

### Screen-Specific Copy

**Feed (universal and topic-specific)**
- No title shown on the universal feed — the cards are the content, not a titled list.
- Topic feed: screen title is the topic name only (e.g., "Docker"). No subtitle.

**Explore**
- Search placeholder: `Search topics...` — lowercase after first word, trailing ellipsis is acceptable only in placeholder text.
- Stats bar: `{n} topics available` — no period.
- Empty search state title: `No topics found` — no period, no exclamation.
- Empty search state subtitle: `Try a different search term.` — period, no exclamation.

**Saved**
- AppBar title: `Saved` — one word, no decoration.
- Action button: `Clear all` — sentence case.
- Empty state title: `No saved cards yet` — no period.
- Empty state subtitle: `Tap the bookmark on any card to save it here for later.` — full sentence, period.
- Confirmation dialog title: `Clear saved cards?` — ends with question mark, no other punctuation.
- Confirmation dialog body: `This will remove all saved cards. This action cannot be undone.` — plain, factual.
- Confirmation dialog cancel: `Cancel` — no period.
- Confirmation dialog confirm: `Clear` — destructive action, use `AppTheme.liked` (red) color.

**Profile**
- Section headers: `Learning Streak`, `Topics Explored` — title case is acceptable here as they are labelling data sections, not instructions.
- Stats labels: `Cards\nViewed`, `Cards\nSaved`, `Cards\nLiked`, `Day\nStreak` — two-line format, title case.
- Streak calendar label: `Last 14 days` — no period, no caps beyond first word.

**Card type badges (rendered inside card widgets)**
- `PRO TIP` — all caps, shown on `TipCard`.
- `QUIZ` — all caps, shown on `QuizCard`.
- Language name — all caps, shown on `CodeSnippetCard` (e.g., `PYTHON`, `DOCKERFILE`).

**Dialog and bottom sheet copy**
- Bottom sheet close icon: no label, icon only (`Icons.close`).
- Any destructive confirmation: always two buttons — neutral cancel on the left, destructive action on the right. Never reverse this order.

### Forbidden UX Copy Patterns

- Do not use "oops" in any string.
- Do not use "please" — it reads as passive.
- Do not use passive voice in empty states ("Cards will be shown here" is wrong; "No saved cards yet" is right).
- Do not add emoji to UI strings in Dart widget code. Emoji belong only in `Topic.emoji` fields and card body strings where the content explicitly calls for them.

---

## 6. Brand Voice

### Personality

ITiktok communicates as a knowledgeable peer who respects the user's time. The voice is:

- **Efficient** — says the most in the fewest words.
- **Precise** — uses correct technical terminology without over-explaining it.
- **Encouraging without being patronising** — acknowledges progress (streaks, cards viewed) without empty praise.
- **Opinionated where it matters** — "always use `.dockerignore`" not "you may want to consider using `.dockerignore`."

### Voice Applied by Context

| Context | Voice Example |
|---|---|
| Empty state | "No saved cards yet" — neutral, factual, no guilt |
| Streak milestone | "7-day streak" — let the number do the work, no exclamation needed in label text |
| Quiz correct answer | Green visual feedback is the celebration; the explanation does the teaching |
| Quiz wrong answer | Red visual + correct answer revealed + explanation — no "Oops!" or "Not quite!" |
| Card body (tip) | "A missing `.dockerignore` is one of the most common Docker mistakes." — direct, opinionated lead |
| Card body (concept) | State the model, give the implication, stop. |

### Consistency Rules

- The app is called **ITiktok** (capital I, capital T, no space). Never "iTikTok," "itiktok," or "TikTok for IT" in UI strings (the tagline is for marketing, not in-app copy).
- Refer to content units as **cards**, not "posts," "lessons," or "tips."
- Refer to the vertical scroll feed as the **feed**, not "stream," "timeline," or "home."
- The action of marking a card for later is **saving** (bookmark icon). The action of appreciating a card is **liking** (heart icon). Do not swap these verbs.

---

## 7. Adding New Content — Checklist

Before committing a new `ContentCard` to `seed_data.dart`:

- [ ] `title` is 3–8 words, no trailing punctuation, specific enough to scan in a list.
- [ ] `body` length and format matches the `CardType` rules in Section 4.
- [ ] `codeSnippet` (if present) is syntactically correct and uses a supported `language` string.
- [ ] `quizOptions` has 3–4 options, exactly one correct, ids are `a/b/c/d`, wrong answers are plausible.
- [ ] `quizExplanation` explains both the correct and the most tempting wrong answer.
- [ ] `tags` are 2–4, lowercase, hyphen-separated, most discoverable first.
- [ ] `difficulty` is intentionally chosen, not defaulted.
- [ ] `likes` is in the 200–5000 range and reflects the card's relative appeal.
- [ ] Technical claims have been verified against documentation or a running system.
- [ ] Tone matches the brand voice in Section 6.

## 8. Adding New Topics — Checklist

Before adding a new `Topic` to `SeedData.topics`:

- [ ] `id` is lowercase, no hyphens or spaces (e.g., `reactnative`, not `react-native`).
- [ ] `name` is the canonical display name (e.g., `React Native`).
- [ ] `emoji` is the single most recognisable emoji for that technology.
- [ ] `description` is one sentence, 8–15 words, lists 3–5 sub-topics covered.
- [ ] `category` matches an existing category string or a new one is justified in a code comment.
- [ ] A corresponding entry has been added to `TopicColors._colors` using the technology's brand color.
- [ ] At least 5 seed cards exist for the topic before it is shipped, covering at least 2 difficulty levels and at least 2 card types.

---

## 9. Architecture

### Style
Feature-first clean architecture. Every feature owns its full vertical slice — data, domain, and presentation — all nested under `lib/features/<feature>/`.

### Directory layout
```
lib/
  main.dart                         # Entry point — ProviderScope + SystemChrome setup only
  app.dart                          # MaterialApp.router wired to appRouter + AppTheme.dark
  core/
    constants/app_constants.dart    # Shared compile-time values (durations, storage keys, daily goal)
    router/
      app_router.dart               # GoRouter definition + _AppShell (bottom nav shell)
      routes.dart                   # Routes class — all path constants + path builder methods
    theme/
      app_theme.dart                # AppTheme static color tokens + ThemeData.dark factory
      topic_colors.dart             # TopicColors.forTopic(id) — topic-to-Color lookup
    utils/extensions.dart           # BuildContext / String / int extensions
    widgets/                        # Widgets shared across features (TopicBadge, EmptyStateWidget)
  data/
    seed/seed_data.dart             # SeedData — static source of truth for all topics and cards
  features/
    feed/
      data/mock_feed_data_source.dart       # MockFeedDataSource implements FeedRepository
      domain/
        models/content_card.dart            # ContentCard, CardType, Difficulty, QuizOption
        models/topic.dart                   # Topic model
        repositories/feed_repository.dart   # Abstract FeedRepository interface
      presentation/
        providers/feed_provider.dart        # feedRepositoryProvider + all derived query providers
        providers/card_interaction_provider.dart  # Liked / Saved / Viewed notifiers
        screens/universal_feed_screen.dart
        screens/topic_feed_screen.dart
        widgets/card_scroll_view.dart       # Vertical PageView + _KeepAliveCard wrapper
        widgets/content_card_widget.dart    # Dispatcher — routes CardType enum to card widget
        widgets/code_snippet_card.dart
        widgets/tip_card.dart
        widgets/quiz_card.dart
        widgets/interaction_bar.dart
    explore/
      data/mock_topics_data_source.dart
      domain/models/topic_summary.dart
      presentation/
        providers/topics_provider.dart
        screens/explore_screen.dart
        widgets/topic_grid_tile.dart
    saved/
      presentation/
        providers/saved_cards_provider.dart  # Derives savedCardsListProvider from saved IDs
        screens/saved_screen.dart
    profile/
      presentation/screens/profile_screen.dart
```

### Layer dependency rules
- **Domain** (`domain/models/`, `domain/repositories/`) — zero Flutter imports. No `package:flutter/...`. Only Dart core.
- **Data** (`data/`) — imports `domain/` and `lib/data/seed/seed_data.dart`. Must not import `presentation/`.
- **Presentation** (`presentation/`) — imports `domain/` and reads data only via a provider. Screens import providers. Widgets import models and providers but never import other screens.
- **Core** (`core/`) — shared infrastructure only. Any feature may import `core/`. `core/` must never import any `features/` path.
- `lib/data/seed/seed_data.dart` is a shared singleton. Both `feed` and `explore` data sources read from it. Do not copy or duplicate it per feature.

---

## 10. State Management (Riverpod 2.x)

### Provider types in use

| Need | Type |
|---|---|
| Repository / service singleton | `Provider<T>` |
| Read-only derived / computed data | `Provider<T>` watching another provider |
| Parameterised query | `Provider.family<T, Arg>` |
| Simple mutable input (search query string) | `StateProvider<String>` |
| Business-logic mutation with named intent | `NotifierProvider<Notifier, State>` |

### Naming conventions
- Repository providers: `<name>RepositoryProvider` — e.g., `feedRepositoryProvider`.
- Data query providers: `<dataDescription>Provider` — e.g., `universalFeedProvider`, `allTopicsProvider`.
- Family providers: same pattern with a typed argument — e.g., `topicFeedProvider(topicId)`, `cardsByIdsProvider(ids)`.
- `StateProvider` for search/filter inputs: `<scope>QueryProvider` — e.g., `searchQueryProvider`, `topicSearchQueryProvider`.
- `NotifierProvider`: notifier class named `<Entity>Notifier`, provider named `<entityPlural>Provider` — e.g., `LikedCardsNotifier` / `likedCardsProvider`.

### Provider file organisation
- All providers for a feature live in `features/<feature>/presentation/providers/`.
- The repository provider and its direct query providers live together in one file when tightly coupled (see `feed_provider.dart`).
- Derived providers that compose across features go in the consuming feature's provider file — e.g., `saved_cards_provider.dart` composes `savedCardIdsProvider` (feed) with `cardsByIdsProvider` (feed) to produce `savedCardsListProvider` (saved).

### Notifier rules
- `Notifier.build()` returns only the initial state. No async calls, no side effects.
- State is always replaced, never mutated in-place: `state = Set.from(state)..add(id)`, not `state.add(id)`.
- Expose named intent methods (`toggle`, `increment`, `reset`). Do not expose raw `state =` setters to the UI.
- Use `.select()` to prevent unnecessary rebuilds when only one field of a large collection matters:
  `ref.watch(likedCardsProvider.select((s) => s.contains(card.id)))`.

### What not to do
- Do not call `ref.read()` inside `build()` — use `ref.watch()` or `ref.listen()`.
- Do not create providers inside a widget `build()` method.
- Do not use `StateNotifierProvider` — the project uses the Riverpod 2.x `NotifierProvider` exclusively.
- Do not use `ChangeNotifier`.

---

## 11. Navigation (go_router 14.x)

### Route path constants
All paths are constants on the `Routes` class in `lib/core/router/routes.dart`. Never write a raw path string in a widget. Use a `Routes` constant or a `Routes` builder method.

```dart
// Correct
context.go(Routes.explore);
context.push(Routes.topicFeedPath(topicId));

// Wrong
context.go('/explore');
context.push('/explore/topic/$topicId');
```

### Router structure
A single `ShellRoute` injects `_AppShell` (which renders the bottom nav) around all tab-level routes. `TopicFeedScreen` is a child route of `/explore` so it lives inside the shell, but `_AppShell` hides the nav bar for it by checking whether the matched location contains `/explore/topic/`.

### Navigation method semantics
- `context.go()` — tab switches. Replaces the entire stack. Use for all bottom nav taps.
- `context.push()` — drill-downs. Preserves the back stack. Use for `TopicFeedScreen` and any future detail screens.
- `Navigator.of(context).pop()` — back-navigate from a screen that was reached via `context.push()`. `TopicFeedScreen` uses this. Do not mix `context.pop()` (go_router) and `Navigator.pop()` in the same screen.

### Adding a new top-level tab screen
1. Add a path constant to `Routes`.
2. Add a `GoRoute` inside `ShellRoute.routes` in `app_router.dart`.
3. Add a `_NavItem` to `_BottomNav.build()` and update `_tabIndex()` in the same class.
4. Create the screen at `features/<feature>/presentation/screens/<name>_screen.dart`.

### Adding a new drill-down screen
1. Add a path constant and a builder method to `Routes`.
2. Add a `GoRoute` as a child of the appropriate parent route in `app_router.dart`.
3. Extract path parameters in the builder with `state.pathParameters['paramName']!`.

---

## 12. Code Style

### File naming
- All files: `snake_case.dart`.
- Screens: `<name>_screen.dart`.
- Widgets: `<name>_card.dart`, `<name>_tile.dart`, `<name>_bar.dart`, `<name>_widget.dart` depending on role.
- Providers: `<name>_provider.dart`.
- Models: singular noun — `content_card.dart`, `topic.dart`, `topic_summary.dart`.
- Data sources: `mock_<name>_data_source.dart` (keep the `mock_` prefix until a real backend exists).

### Class naming
- Screens: `PascalCase` + `Screen` suffix.
- Widgets: `PascalCase` + a role suffix (`Card`, `Tile`, `Bar`, `Badge`, `View`, `Sheet`).
- Private file-scoped sub-widgets: `_PascalCase` prefix — e.g., `_BottomNav`, `_ActionButton`, `_CardTypeChip`.
- Notifiers: `PascalCase` + `Notifier` suffix.

### Widget conventions
- Default to `StatelessWidget` or `ConsumerWidget`.
- Use `ConsumerStatefulWidget` + `ConsumerState` only when you need both `ref` and local `State` (e.g., `CardScrollView`, `ExploreScreen`).
- Use plain `StatefulWidget` (no Riverpod) for purely local ephemeral UI state with no provider interaction (e.g., `_CopyButton`, `QuizCard`).
- Every widget whose constructor arguments are all compile-time constants must have a `const` constructor and be instantiated with `const`.
- Use the `super.key` shorthand in all constructors — not the verbose `Key? key` + `: super(key: key)` pattern.

### Theming and colors
- All colors from `AppTheme` static constants or `TopicColors.forTopic(topicId)`. Do not inline `Color(0xFF...)` hex literals in widget files — add new colors to `AppTheme` or `TopicColors` first.
- All text styles from `Theme.of(context).textTheme.*`. Do not construct a `TextStyle` with a raw font family string — use `GoogleFonts.inter(...)` or `GoogleFonts.jetBrainsMono(...)`.
- `JetBrainsMono` is for code blocks only (`_CodeBlock` in `code_snippet_card.dart` and the code preview in `_CardDetailSheet`). All prose uses Inter.
- Use `.withValues(alpha: x)` for opacity — not the deprecated `.withOpacity(x)`.

### Extensions
Add `BuildContext` helpers, `String` utilities, and `int` formatters to `lib/core/utils/extensions.dart`. Do not scatter ad-hoc extension methods across feature files.

---

## 13. Adding New Content (Technical Steps)

### Adding a new topic

1. **`lib/data/seed/seed_data.dart`** — add a `Topic` to `SeedData.topics`:
   ```dart
   Topic(
     id: 'linux',          // lowercase, no spaces — this is the canonical key used everywhere
     name: 'Linux',
     emoji: '🐧',
     description: 'One sentence, 8–15 words, listing 3–5 sub-topics.',
     category: 'Infrastructure',
   ),
   ```
2. **`lib/core/theme/topic_colors.dart`** — add the topic color to `TopicColors._colors`. The key must exactly match `Topic.id`:
   ```dart
   'linux': Color(0xFFFCC624),
   ```
3. **`lib/features/feed/presentation/widgets/interaction_bar.dart`** — add the emoji to `_topicEmoji()`:
   ```dart
   'linux': '🐧',
   ```
   (This duplication exists because `InteractionBar` receives a `ContentCard`, not a `Topic`. The canonical emoji is `SeedData.topics[n].emoji`.)

4. Add seed cards (see below). No other files need changes — the topic appears automatically in the Explore grid and is navigable via `TopicFeedScreen`.

### Adding seed cards

Add `ContentCard` entries to `SeedData.cards` in `lib/data/seed/seed_data.dart`.

**ID convention:** `<topicId>_<zero-padded-three-digit-number>` — e.g., `linux_001`, `linux_002`.

**Required fields by `CardType`:**

| `cardType` | Required extra fields |
|---|---|
| `codeSnippet` | `codeSnippet` (non-null string), `language` (see supported values below) |
| `tip` | none beyond the base fields |
| `quiz` | `quizOptions` (3–4 `QuizOption`s with ids `'a'`/`'b'`/`'c'`/`'d'`), `quizExplanation` |
| `concept` | none (renders via `TipCard` layout) |
| `command` | `codeSnippet`, `language: 'bash'` (renders via `CodeSnippetCard`) |
| `comparison` | none currently (renders via `TipCard`; `comparisonLeft`/`Right` fields are reserved) |

**Supported `language` values** (from `_CodeBlock._normalizeLanguage` in `code_snippet_card.dart`):
`dockerfile`, `yaml`, `bash`, `shell`, `python`, `kotlin`, `javascript`, `js`, `typescript`, `ts`, `dart`, `http`, `json`, `sql`. Anything else falls back to `bash`.

**`QuizOption.id` values** must be single lowercase letters `'a'`, `'b'`, `'c'`, `'d'` in order — they are displayed uppercased as option labels in `QuizCard`.

### Adding a new card type

1. Add the variant to the `CardType` enum in `lib/features/feed/domain/models/content_card.dart`.
2. Add any type-specific nullable fields to `ContentCard` and mirror them in `copyWith`.
3. Create `lib/features/feed/presentation/widgets/<type>_card.dart`. Accept `final ContentCard card`. Use `StatelessWidget` unless the card has interactive local state, in which case use `StatefulWidget`.
4. Wire the new type in the exhaustive `switch` inside `ContentCardWidget._buildCardContent()` in `content_card_widget.dart`.
5. Add the icon + label pair to the `switch` inside `_CardTypeChip.build()` in the same file.
6. Add the icon to the `switch` inside `_SavedCardTile.build()` in `saved_screen.dart`.
7. If the card uses syntax highlighting with a new language, add the language alias to `_normalizeLanguage` in `code_snippet_card.dart`.

---

## 14. Package Conventions

### Approved packages

| Package | Purpose | Primary location |
|---|---|---|
| `flutter_riverpod` + `riverpod_annotation` | State management | All provider files |
| `go_router` | Navigation | `core/router/` |
| `freezed_annotation` + `json_annotation` | Immutable models (available; not yet active — models use manual `copyWith`) | Future use |
| `flutter_highlight` | Syntax highlighting | `code_snippet_card.dart` |
| `google_fonts` | Inter (prose) + JetBrainsMono (code) | `app_theme.dart`, `code_snippet_card.dart` |
| `flutter_animate` | Declarative animations | Feed cards, explore grid, saved list |
| `share_plus` | Native share sheet | `interaction_bar.dart` |
| `shared_preferences` | Local persistence (streak, progress counters) | Keys defined in `AppConstants`; implementation pending |
| `riverpod_generator` + `freezed` + `json_serializable` + `build_runner` | Code generation (dev only) | — |

### Evaluating new packages
Before adding any package, verify all four:
1. Supports both iOS and Android without requiring native configuration changes.
2. Does not introduce a competing state management or navigation solution.
3. Null-safe, pub.dev score 130+, actively maintained.
4. The functionality cannot reasonably be achieved with what is already in the approved list above.

Do not add packages for: bottom sheets (`showModalBottomSheet`), simple dialogs (`showDialog`), basic entry animations (`flutter_animate`), or snackbars (`context.showSnack` extension).

---

## 15. Do's and Don'ts

### Do
- Apply `ValueKey(card.id)` to `ContentCardWidget` and to `AnimatedSwitcher` children that track card identity — this is how `PageView` and `AnimatedSwitcher` correctly diff items on navigation.
- Wrap interactive card types in `_KeepAliveCard` inside `CardScrollView`. `_KeepAliveCard` uses `AutomaticKeepAliveClientMixin` to preserve local widget state (e.g., `QuizCard` answer selection) across swipes. Any new `StatefulWidget` card type that holds user interaction state must be kept alive this way.
- Use `MediaQuery.paddingOf(context)` and `MediaQuery.sizeOf(context)` — not `MediaQuery.of(context).padding` / `.size`. The focused selectors avoid full-tree rebuilds on unrelated `MediaQuery` changes.
- Use `WidgetsBinding.instance.addPostFrameCallback` for any first-frame side effect (as in `CardScrollView.initState` tracking the initial viewed card).
- Always call `controller.dispose()` in `dispose()` for every `PageController`, `TextEditingController`, and `AnimationController`.
- Guard every `setState()` that follows an `await` with `if (mounted)`.

### Don't
- Do not use `Navigator.of(context).pop()` on a tab-level screen that was reached with `context.go()` — that pops the shell itself. `Navigator.pop` / `context.pop` is only correct after `context.push()`.
- Do not put filtering, sorting, or search logic inside a widget `build()` method — move it to a `Provider`.
- Do not import `SeedData` from any file other than `MockFeedDataSource` and `MockTopicsDataSource`. Those two classes are the only intended consumers of `SeedData`.
- Do not create a parallel repository layer for the `explore` feature. `TopicSummary` is derived from `SeedData` inside `MockTopicsDataSource`; the `feed` feature's `FeedRepository` / `MockFeedDataSource` already owns topic data. Keep derivation there and avoid a second competing abstraction.
- Do not store a `BuildContext` inside a `Notifier` or provider. Pass context at the call site from the widget.
- Do not use `print()`. Use `debugPrint()` for any temporary diagnostic logging, and remove it before committing.
- Do not use `Colors.*` named material colors in widget files. The only exceptions are `QuizCard`'s semantically correct `Colors.green` and `Colors.red` for correct/wrong answer feedback. All other colors must come from `AppTheme` or `TopicColors`.
- Do not hard-code topic emojis in more than one place. The canonical source is `SeedData.topics[n].emoji`. The `InteractionBar._topicEmoji()` map is a known duplication kept only because `InteractionBar` receives a `ContentCard` without access to a `Topic` — consolidate if `Topic` becomes available at that call site.
- Do not replicate the `isTopicFeed` location-string check outside of `_AppShell`. That pattern is scoped to the shell's nav-bar visibility logic.

---

## 16. Testing Guidelines

### What to unit test (high value, no widget tree needed)

- `ContentCard.copyWith()` — verify that every optional field round-trips correctly and that omitted fields retain their original value.
- `MockFeedDataSource`:
  - `getFeedForTopic(id)` returns only cards whose `topicId` matches.
  - `searchCards(query)` matches on `title`, `body`, `topicName`, and `tags`; returns empty list for blank query.
  - `getCardsByIds(ids)` returns the correct subset without duplicates.
- `MockTopicsDataSource.getAllTopicSummaries()` — `cardCount` per topic matches the count in `SeedData.cards`.
- `TopicColors.forTopic(id)` — known IDs return their expected `Color`; unknown ID returns the fallback `Color(0xFF6C63FF)`.
- `Routes.topicFeedPath(topicId)` — returns correctly interpolated path string.
- Notifiers:
  - `LikedCardsNotifier.toggle()` — adds on first call, removes on second call for the same ID.
  - `SavedCardsNotifier.toggle()` — same contract; verify list ordering is preserved for non-toggled items.
  - `ViewedCardsNotifier.increment()` and `reset()`.
- `IntExtensions.compactFormat` — boundary values: 999 → `"999"`, 1000 → `"1.0K"`, 999999 → `"1000.0K"`, 1000000 → `"1.0M"`.

### What to widget test (medium value)

- `CardScrollView` with a list of mock cards: verify a `PageView` is present; verify each page is wrapped in `_KeepAliveCard` (use `find.byType`).
- `QuizCard`: tap an option, verify the option becomes visually selected and `_revealed` is true (check for the explanation container); tap a second time after reveal, verify nothing changes.
- `InteractionBar`: verify `likedCardsProvider` and `savedCardIdsProvider` toggle on tap. Use a `ProviderScope` with overrides in the widget test.
- `EmptyStateWidget`: renders icon, title text, and subtitle text.

### What not to test

- `AppTheme.dark` `ThemeData` construction — pure configuration, not logic.
- `SeedData` card and topic content — editorial data, not code logic.
- `_AppShell` bottom-nav visibility — requires a full router context; cover in an integration test only.

### Test conventions

- Mirror `lib/` structure under `test/` — e.g., `test/features/feed/domain/models/content_card_test.dart`.
- Use `ProviderContainer` from `flutter_riverpod` for notifier and derived provider unit tests (no widget tree needed).
- Always override the repository provider in widget tests:
  ```dart
  ProviderScope(
    overrides: [feedRepositoryProvider.overrideWithValue(FakeFeedRepository())],
    child: const WidgetUnderTest(),
  )
  ```
  Never let a widget test reach `SeedData` directly.
- Do not `pump` with explicit `Duration` delays to wait out animations — use `tester.pumpAndSettle()`.

### Running tests
```bash
flutter test                         # all tests
flutter test test/features/feed/     # feature-scoped run
flutter analyze                      # must report zero issues; run before every PR
```
