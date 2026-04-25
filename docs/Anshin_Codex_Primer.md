# Anshin — Codex Context Primer

> **Codex: Read this document FIRST before any task. This is the only context you need to begin work.**
> **Last updated:** April 2026

---

## 1. What is Anshin?

Anshin is a **panic attack and anxiety relief mobile app** for Android, targeting women aged 22–35 in the US, UK, Canada, and Australia. The app is built in **Flutter** and is preparing for Google Play Store submission.

App identity:
- Name: **Anshin** (Japanese: 安心, "peace of mind")
- Package: `com.anshin.app`
- Tagline: "Peace of mind, one breath at a time"
- Positioning: "The panic attack app that actually works mid-attack — and teaches you to need it less over time"

---

## 2. Your role (Codex)

You are working on **UI/UX refinement and mascot redesign only**. You are NOT building new features. The app's core functionality is already complete. Your job is to make it look like a production-grade product before Play Store submission.

**You will NOT:**
- Add new features
- Modify routing or navigation logic
- Change Firebase, RevenueCat, or any backend code
- Modify state management (Riverpod providers)
- Change the data model or Firestore schema
- Build V1.1 (Chat with Anna) or V1.2 (Visualize/Sleep) features

**You WILL:**
- Improve visual design of existing screens
- Replace placeholder/poor-quality mascot SVGs
- Add illustrated scene backgrounds to screens
- Refine typography, spacing, color usage
- Ensure consistency across the app
- Match a production-grade design standard

---

## 3. Tech stack (do not change)

| Layer | Choice |
|---|---|
| Frontend | Flutter (Dart) |
| State | Riverpod (StateNotifier) |
| Routing | GoRouter |
| Backend | Firebase (Auth, Firestore, FCM, Analytics, Crashlytics, Remote Config) |
| Local DB | Drift (SQLite) |
| Subscriptions | RevenueCat + Google Play Billing |
| Voice | flutter_tts |
| Crash | Firebase Crashlytics |

When you write Flutter code, use these existing patterns. Do not introduce new state management, routing, or styling frameworks.

---

## 4. Project structure (existing)

```
anshin/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_typography.dart
│   │   │   └── app_theme.dart
│   │   ├── constants/
│   │   │   └── strings_*.dart (all user-facing copy)
│   │   ├── widgets/
│   │   │   ├── mascot_widget.dart
│   │   │   └── scene_painter.dart
│   │   └── services/
│   ├── features/
│   │   ├── auth/                  (gate screen)
│   │   ├── onboarding/            (3 onboarding screens)
│   │   ├── home/                  (home screen)
│   │   ├── sos/                   (SOS active, post-session)
│   │   ├── breathing/             (picker, active session)
│   │   ├── grounding/             (picker, technique screens)
│   │   ├── daily/                 (check-in)
│   │   ├── journal/               (home, calendar, entry flow)
│   │   ├── progress/              (charts, stats)
│   │   ├── learn/                 (home, lesson detail)
│   │   ├── visualize/             (empty state — V1.2)
│   │   ├── sleep/                 (empty state — V1.2)
│   │   ├── subscription/          (paywall)
│   │   └── settings/              (settings screen)
│   └── routing/
│       ├── app_router.dart
│       ├── app_routes.dart
│       └── shell_scaffold.dart
├── assets/
│   └── mascot/                    (all mascot SVGs)
└── docs/
    └── (specification documents)
```

---

## 5. Design system (foundation)

### Colors (light theme — default)

| Element | Hex |
|---|---|
| Background | `#F8F5F0` (warm cream) |
| Surface / cards | `#FFFFFF` |
| Primary text | `#2D2A26` (warm dark) |
| Secondary text | `#7A7267` (muted brown) |
| Accent (SOS, primary actions) | `#E8907A` (warm coral) |
| Calm accent | `#7BA8B0` (soft teal) |
| Warm accent | `#D4B480` (muted gold) |
| Card border | `#E8E2D9` (light warm gray) |

### Colors (dark theme — option)

| Element | Hex |
|---|---|
| Background | `#1A1F2E` (deep navy) |
| Surface | `#252B3D` (charcoal) |
| Primary text | `#E8E8EC` (off-white) |
| Secondary text | `#9CA3B5` (silver) |
| Coral accent | same `#E8907A` |
| Card border | `#353B4D` (dim gray) |

**Critical rule:** SOS active screen is ALWAYS dark regardless of user theme.

### Typography

- Major headings (screen titles): 24sp, weight 700
- Section headings: 18sp, weight 600
- Body text: 15sp, weight 400, line height 1.6
- Card titles: 16sp, weight 600
- Card subtitles: 13sp, weight 400
- Button text: 16sp, weight 600
- Captions / muted: 12sp, weight 400

### Spacing

- Card corner radius: 16dp (everywhere, no exceptions)
- Card padding: 16dp internal
- Screen edge padding: 24dp horizontal
- Spacing between cards: 16dp vertical
- Section spacing: 32dp vertical

### Buttons

- Primary button: full coral `#E8907A`, 56dp height, 16dp corner radius, white text weight 600
- Outlined button: 1.5dp coral border, transparent fill, coral text
- Disabled state: muted gray `#E8E2D9`, gray text

---

## 6. The 6 home screen sections

These exist as cards on the home screen and as detail screens:

| Section | Theme | Status |
|---|---|---|
| Breathe | Forest (soft green, mist) | Working — needs visual refinement |
| Ground | River with stones (teal, water) | Working — needs visual refinement |
| Journal | Indoor by window with rain (warm amber) | Working — needs visual refinement |
| Learn | Sunny meadow (warm green, gold) | Working — 2 free lessons live |
| Visualize | Waterfall mist (purple-blue) | Empty state — V1.2 |
| Sleep | Moonlit night (deep blue, stars) | Empty state — V1.2 |

The home screen also has:
- Greeting bar (top)
- Check-in card (recommendation)
- 6 section cards (2-column grid)
- SOS button (large, coral, fixed bottom)
- Bottom nav: Home / Journal / Progress / Settings

---

## 7. The mascot

The mascot is the core visual identity. It appears throughout the app with different expressions and contextual poses. The current SVGs are placeholder quality and need a complete redesign.

**Reference style locked:** Right-panel style from the reference image — small, round, kawaii, glossy, expressive faces. Body color: blue-gray (#7BA8B8 base). Body must have a glossy upper-left highlight (white oval at 35% opacity). Eyes must have small white highlight dots in upper-right.

**12 emotion variants** (used in journal mood picker and throughout):
1. Calm
2. Anxious
3. Panicked
4. Sad
5. Tired
6. Overwhelmed
7. Hopeful
8. Relieved
9. Grateful
10. Frustrated
11. Numb
12. Proud

**Context variants** (Anshin-specific, not generic kawaii props):
- Breathing pose (eyes closed, arms slightly raised)
- Grounded pose (sitting cross-legged)
- Holding pen (for journal)
- Reading book (for learn — with simple round glasses)
- Sleeping pose (ZZZ above head)
- Eyes closed peaceful (for visualize)

**Hero scene variants** (mascot inside a full illustrated nature scene, used as section card backgrounds):
- breathe_hero (forest dawn)
- ground_hero (river with stones)
- journal_hero (cozy indoor with rain)
- learn_hero (sunny meadow)
- visualize_hero (waterfall mist)
- sleep_hero (moonlit night)

**Critical mascot rules:**
- The mascot uses ONLY Anshin-specific props (pen, book, ZZZ, breathing pose) — NOT generic kawaii props (no laptops, coffee cups, gifts, hearts, crowns, chef hats, 404 signs)
- The mascot is large enough to be clearly visible from 30–40 cm away (minimum 100dp on hero screens, 64dp on cards)
- The mascot does NOT appear on: SOS active screen, paywall

---

## 8. Voice and tone (how the app talks to users)

The app's voice is a "friend who has had panic attacks herself, talking at 2 AM."

**Voice rules:**
- Honest over comforting ("Panic attacks feel terrifying, and they're not dangerous" — not "Everything will be okay")
- Short over thorough
- Specific over abstract
- Present over performative

**Hard don'ts:**
- No "you've got this!"
- No exclamation marks
- No gamification language ("Level up! Bravery points!")
- No wellness-industrial jargon

**You will NOT change any user-facing copy.** All strings come from existing `lib/core/constants/strings_*.dart` files. Do not invent or modify copy.

---

## 9. What's working in the current app (do not break)

These screens function correctly — only visual refinement needed:

- First launch gate (two-button choice screen)
- 3 onboarding screens with progress dots
- Home screen with 6 section cards + SOS
- SOS active screen with breathing circle (dark, working — DO NOT visually change beyond minor polish)
- 4 breathing patterns (Box, 4-7-8, Physiological Sigh, Coherent)
- 4 grounding techniques (5 Senses, Body Scan, Cold Water, Movement)
- Daily check-in with mood scale + anxiety slider + tags
- Journal full flow (5 screens) with calendar view and shareable card
- Progress screen with 7-day charts and stats
- Learn home + 2 free lessons + locked future lessons
- Settings with theme toggle, share, rate, subscription
- Paywall with monthly + annual + 7-day trial
- RevenueCat sandbox integration (works, real products link at T21)
- Firebase Auth + Firestore for user data
- Offline-first SOS (must keep working in airplane mode)

---

## 10. What is incomplete (do NOT build these now)

These are V1.1 and V1.2 features. They have empty placeholder screens. **Do not build them. Codex's scope is UI refinement only.**

- Chat with Anna (V1.1) — placeholder home card needed (will be specified separately)
- Visualize sessions (V1.2) — empty state screen exists
- Sleep tracks (V1.2) — empty state screen exists
- Future Learn lessons (V1.3) — locked cards exist

---

## 11. The constraints you must respect

1. **Performance:** All SVGs render fast. Keep file sizes small (under 10KB for emotion variants, under 18KB for hero scenes). No heavy gradients or filter effects.

2. **Accessibility:** All interactive elements have minimum 44dp tap target. All text must pass contrast ratio 4.5:1 minimum.

3. **Both themes:** Every screen must look correct in both light and dark themes.

4. **Offline:** SOS flow must continue to work offline. Do not introduce network dependencies in SOS-related screens.

5. **No new dependencies:** Do not add new Flutter packages. Use what exists in pubspec.yaml.

6. **No commits without permission:** Never run `git commit` or `git push` unless explicitly told. Show the user what you changed and wait for confirmation.

---

## 12. How to work with the user

The user is a solo non-technical founder. They cannot read code. When you respond:

- Show what you did in plain language
- List the files you created or modified
- Explain visual changes in terms of what they will see, not what the code does
- If you need a design decision, ask one clear question — never multiple
- If something is ambiguous, ask before assuming

When you finish a task:
- Run `flutter analyze` and fix all warnings
- Confirm both themes work
- Tell the user "ready to test" and wait

---

## 13. The deliverable bar

The reference quality benchmark is the **Rootd app** — but Anshin must NOT copy Rootd's visual identity. Anshin is its own product with its own art direction. The standard to match is:

- Every screen has visual identity (no plain backgrounds)
- The mascot is consistently illustrated and clearly visible
- Cards have depth, color, illustration — not flat clip-art
- Typography is hierarchical and confident
- Animations are subtle but present (breathing pulses, smooth transitions)
- Nothing looks like a prototype

**Read this primer before every task. The user will provide specific UI/UX prompts and mascot prompts. Each prompt assumes you have read this primer.**

---

**End of primer.**
