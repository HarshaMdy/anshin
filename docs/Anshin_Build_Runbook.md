# Anshin — Final Build Runbook (v2)

> **This is the SINGLE SOURCE OF TRUTH for building Anshin.**
> Claude Code: read this document FIRST, before any other document. Section 1 below contains explicit overrides that supersede conflicting information in the PRD, mascot spec, and other companion documents.
> **Last updated:** April 2026
> **App name:** Anshin
> **Builder:** Solo non-technical founder using Claude Code on Windows

---

## 0. Documents Claude Code must read (in this order)

These 5 files live in the `/docs` folder of the project. Read them in this exact order:

| Order | File | What it defines | Authority level |
|---|---|---|---|
| **1 (READ FIRST)** | `Anshin_Build_Runbook.md` (THIS FILE) | Overrides, collaboration rules, task sequence, manual checkpoints | **HIGHEST — overrides everything else** |
| 2 | `Anshin_PRD_v1.md` | Features, data model, architecture, screens, pricing | High — but Section 1 of this runbook overrides specific parts |
| 3 | `Anshin_Voice_Guide.md` | How the app talks to users, tone, word rules | High — no overrides needed |
| 4 | `Anshin_Mascot_Spec.md` | Mascot personality, 12 emotions, placement | Medium — Section 1 of this runbook overrides the visual design |
| 5 | `Anshin_Content_Bible.md` | Every user-facing string, lessons, legal docs | High — no overrides needed |

---

## 1. OVERRIDES — What changed after the original documents were written

> **CLAUDE CODE: This section is the most important section in all 5 documents. If ANYTHING in the PRD, mascot spec, or any other doc conflicts with what's written here, THIS section wins. Always. No exceptions.**

### OVERRIDE 1 — App name changed from "Steady" to "Anshin"

**Old (in PRD):** The app was called "Steady" throughout.
**New (FINAL):** The app is called **Anshin**.

**What this changes:**
- Every user-facing string that says "Steady" → replace with "Anshin"
- Package name: `com.anshin.app` (NOT com.steady.app)
- Firebase projects: `anshin-dev` and `anshin-prod` (NOT steady-dev/steady-prod)
- RevenueCat project: `anshin`
- GitHub repo: `anshin`
- Play Store title: `Anshin: Anxiety & Panic Relief`
- Tagline: `Peace of mind, one breath at a time`
- All Dart class names, file names, and references use "anshin" or "Anshin" as appropriate
- The flutter project is created with `--project-name anshin --org com.anshin`
- All folder references in PRD §6.2 that say "steady" → "anshin"

**Do not use the word "Steady" anywhere in the codebase or user-facing content.**

---

### OVERRIDE 2 — Default theme changed from dark to light

**Old (in PRD §5.1):** Dark navy (#1A1F2E) was the primary background everywhere. Dark theme was the default.
**New (FINAL):** Light theme is the default. Dark theme is an option. System default is a third option.

**Updated color system:**

**Light theme (DEFAULT):**
| Element | Color |
|---|---|
| Background | Warm cream `#F8F5F0` |
| Surface / cards | White `#FFFFFF` |
| Primary text | Warm dark `#2D2A26` |
| Secondary text | Muted brown `#7A7267` |
| Accent (SOS / breathe) | Warm coral `#E8907A` |
| Calm accent | Soft teal `#7BA8B0` |
| Warm accent (progress/gold) | Muted gold `#D4B480` |
| Card borders | Light warm gray `#E8E2D9` |

**Dark theme (OPTION):**
| Element | Color |
|---|---|
| Background | Deep navy `#1A1F2E` |
| Surface / cards | Charcoal `#252B3D` |
| Primary text | Off-white `#E8E8EC` |
| Secondary text | Silver `#9CA3B5` |
| Accent (SOS / breathe) | Same warm coral `#E8907A` |
| Calm accent | Same soft teal `#7BA8B0` |
| Warm accent | Same muted gold `#D4B480` |
| Card borders | Dim gray `#353B4D` |

**EXCEPTION — SOS active screen is ALWAYS dark regardless of theme.** During a panic attack at 2 AM, a bright white screen is painful. SOS mode forces dark background (#1A1F2E) even if the user's theme is Light.

**Settings location:** Settings → Appearance → Theme → Light (default) / Dark / System default

**Implementation:** Use Flutter's `ThemeMode.light` as default. Store preference in SharedPreferences (`theme_mode`: 'light' | 'dark' | 'system'). The theme system in `lib/core/theme/app_theme.dart` must define BOTH light and dark ThemeData objects. Every screen must look correct in both themes — test both.

**When PRD §5.1 says "Primary background: #1A1F2E"** → that is now the DARK theme background, not the default. Replace all references accordingly.

---

### OVERRIDE 3 — Mascot visual design changed from minimal SVG to full kawaii character

**Old (in mascot spec):** A simple stone shape with two dot eyes and a curved line mouth. No limbs. No accessories. Expressions only through eye shape and mouth curve.

**New (FINAL):** A full kawaii-style character with the following properties:

| Property | Old spec | New spec (FINAL) |
|---|---|---|
| Body shape | Simple oval/ellipse | Round spherical body, warm stone tones |
| Limbs | None — explicitly "no arms, no legs" | **Has small cute arms/hands and small legs/feet** |
| Eyes | Two small dots | **Kawaii-style expressive eyes with highlight/sparkle marks** |
| Mouth | Single curved line | Expressive mouth, varied by emotion |
| Interaction | Cannot hold objects | **Can hold objects** (pen for journal, book for learn, pillow for sleep, etc.) |
| Style | Minimal SVG, 2KB per file | **Polished illustration-quality, kawaii aesthetic** |
| Feel | "A stone with a face" | **"A living character that happens to be pebble-shaped"** |

**Reference style:** See the uploaded reference image in the conversation (round blue character with arms, legs, holding laptop/heart/gift). Use that STYLE but with Anshin's warm stone color palette (#C4B5A0 base with #D4C4AE highlights), not the blue color from the reference.

**What stays the same from the mascot spec:**
- 12 emotion expressions (Calm, Anxious, Panicked, Sad, Tired, Overwhelmed, Hopeful, Relieved, Grateful, Frustrated, Numb, Proud) — all 12 labels and descriptions are unchanged
- Placement map (where mascot appears and doesn't appear) — unchanged
- Breathing animation behavior — unchanged
- The mascot has no spoken words — unchanged (expressions only, per voice guide)
- Never appears on SOS active screen or paywall — unchanged

**What changes in placement (because the mascot now has arms):**

| Screen | Old behavior | New behavior |
|---|---|---|
| Home cards | Mascot next to greeting text | Mascot interacts with each card contextually (holding pen for Journal, reading book for Learn, eyes closed for Visualize, sleeping for Sleep, breathing for Breathe, sitting firmly for Ground) |
| Journal completion | Just face expression | Full body in proud pose, possibly arms up |
| Post-SOS | Just face expression | Full body in relieved pose, hands relaxed |
| Empty states | Just face with text | Full body, possibly pointing at or looking toward "Coming soon" text |
| Error screens | Just face | Full body with apologetic posture (hands together, slight bow) |
| Shareable card | Face only | Full body in selected mood expression |

**SVG production:** Claude Code generates these as SVG files. Each emotion × each context = potentially many files. For MVP, generate the 12 emotion base poses first (full body, no objects). Context-specific poses (holding pen, reading book, etc.) can use the base pose with minor modifications. Keep file size manageable — under 10KB per SVG.

**MASCOT = APP ICON = SPLASH = NOTIFICATION ICON:**
- The app icon is the mascot in Calm expression (full body, warm cream background)
- The splash screen is the mascot in Calm expression (centered, breathing animation, "Anshin" text below)
- The notification icon is a simplified silhouette of the mascot (for Android notification tray, 24dp)
- There is NO separate logo. The mascot IS the brand.

---

### OVERRIDE 4 — Home screen structure updated to six sections

**Old (in PRD §4 Screen 5):** Home screen had SOS button + "Today" card + 3 quick action tiles + streak + bottom nav.

**New (FINAL):** Home screen has SOS button + greeting + 6 section cards + streak + bottom nav.

**Updated home screen layout (top to bottom):**

1. **Greeting bar:** Time-based greeting (per Content Bible §4) + small mascot (calm expression) on the left
2. **SOS button:** Large, prominent, always visible, warm coral color. Label: "SOS"
3. **Today card:** Context-aware recommendation (per Content Bible §4)
4. **Six section cards (2×3 grid or scrollable):**
   - Breathe — "Find your rhythm" (mascot breathing)
   - Ground — "Come back to here" (mascot sitting)
   - Journal — "Get it out of your head" (mascot holding pen)
   - Learn — "Understand what's happening" (mascot reading)
   - Visualize — "See a calmer place" (mascot eyes closed) — shows "Coming soon" on tap
   - Sleep — "Rest your mind" (mascot sleeping) — shows "Coming soon" on tap
5. **Streak indicator:** Subtle, below cards
6. **Bottom nav:** Home / Tools / Progress / Profile

**The PRD's 3-tile quick action layout is replaced by this 6-card layout.** The 6 cards match Rootd's structure but with Anshin's design language.

---

### OVERRIDE 5 — Journal flow expanded from simple to full flow

**Old (in PRD §3.8):** Journal was a simple "free write or prompted" feature with list view.

**New (FINAL):** Journal is a full 5-screen flow (per Content Bible §9):
1. Mood picker (12 mascot expressions in 4×3 grid)
2. Accomplishments ("Three things you accomplished today")
3. Release ("Is something weighing on you?")
4. Gratitude ("What are you grateful for today?")
5. Additional notes
6. Completion screen (mascot proud, +5 mindfulness points, share option)

Plus: calendar view (monthly, swipeable), past entry detail view, progress bar at top of flow, shareable journal card.

**This replaces PRD §3.8 entirely.** Use Content Bible §9 as the authoritative spec for the journal feature.

---

### OVERRIDE 6 — Share and Rate buttons added

**Old (in PRD):** Not mentioned.

**New (FINAL):** Settings screen includes:
- "Rate Anshin" → opens Play Store listing (only shown after 7+ days of use)
- "Share Anshin" → triggers system share sheet with text from Content Bible §15

---

### OVERRIDE 7 — Transitions and animations feel light and premium

**Old (in PRD §5.2):** Described as "slow, 300–600ms transitions."

**New (FINAL, more specific):**
- Page transitions: smooth cross-fade, 250ms, ease-in-out. No slide-from-bottom. No bouncy springs.
- Card taps: subtle scale-down to 0.97 on press, 0.98 on release, 100ms. Feels tactile but not aggressive.
- SOS entry: 200ms fade-to-dark. No intermediate screens.
- Breathing circle: 60fps always. Smooth ease-in-out, synced to pattern timing.
- Mascot expression changes: 300ms morph (eyes and mouth transition smoothly, body posture shifts gently).
- Screen loads: content appears progressively top-to-bottom, not all-at-once pop. 150ms stagger between sections.
- Overall feel: light, airy, unhurried. Like exhaling. NOT sluggish — just smooth.

---

### OVERRIDE 8 — Points system is quiet, not gamified

**Old (in PRD):** PRD banned gamification language.

**New (clarified):** Points exist but are subtle:
- Journal completion: "+5 mindfulness points" (small text, not flashy, no animation burst)
- Lesson completion: "+10 mindfulness points"
- The word "points" is used, not "bravery points" or "XP" or "coins"
- Running total visible in journal completion screen only
- No leaderboard. No levels. No badges in MVP.
- The number exists for users who want progress feedback. It's never shouted.

---

### OVERRIDE 9 — PRD pricing section confirmed with no changes

The pricing from PRD §8 is confirmed as-is:
- Monthly: $7.99 USD
- Annual: $49.99 USD (Save 48%)
- 7-day free trial, payment method required
- No lifetime plan

No override needed — just confirming so Claude Code doesn't second-guess.

---

### OVERRIDE 10 — Free vs Premium confirmed with one addition

The free/premium matrix from PRD §8.2 is confirmed with this update:

| Feature | Free | Premium |
|---|---|---|
| SOS mode | ✅ Unlimited, forever | ✅ |
| Box breathing | ✅ | ✅ |
| Other 3 breathing patterns | ❌ | ✅ |
| 5-4-3-2-1 grounding | ✅ | ✅ |
| Other 3 grounding techniques | ❌ | ✅ |
| Daily check-in | ✅ | ✅ |
| Journal (full flow) | ✅ Up to 30 entries | ✅ Unlimited |
| Episode log | ✅ | ✅ |
| Progress (7-day) | ✅ | ✅ |
| Progress (30-day + insights) | ❌ | ✅ |
| Learn (2 free lessons) | ✅ | ✅ |
| Learn (all future lessons) | ❌ | ✅ |
| Visualize (V1.2) | ❌ | ✅ |
| Sleep (V1.2) | ❌ | ✅ |
| AI companion (V1.1) | ❌ | ✅ |
| Cross-device sync | ✅ (with account) | ✅ |
| Share journal card | ✅ | ✅ |
| Points tracking | ✅ | ✅ |

**NEVER behind paywall:** SOS, box breathing, 5-4-3-2-1 grounding, crisis hotlines, account creation, data export, account deletion.

---

## 2. Collaboration rules (Claude Code must follow these)

1. **The app name is Anshin.** Package name: `com.anshin.app`. Every Dart class, Firebase reference, and user-facing string uses "Anshin." Never "Steady."

2. **One task at a time.** Complete the task, commit, push to GitHub, and WAIT for the founder's next instruction. Do not start the next task without being told "go ahead."

3. **Do not add features outside the 5 documents.** If you think something is missing, ASK — don't add it silently. If it's not in the PRD, voice guide, mascot spec, content bible, or this runbook, it doesn't exist yet.

4. **Do not build V1.1, V1.2, or V1.3 features.** AI companion, sleep content, visualization sessions, and full lesson tracks are NOT in the MVP. Create empty placeholder sections with "Coming soon" UI (per Content Bible §16), but do not implement the features.

5. **When a task requires manual action (Firebase console, Play Console, RevenueCat dashboard, keystore generation),** PAUSE and give exact step-by-step instructions. Wait for the founder to say "done" before continuing.

6. **After every successful task,** commit with a meaningful message and push to GitHub. Never commit: `google-services.json`, keystore files, `key.properties`, `.env` files, or `secrets.dart`. Update `.gitignore` when introducing new secret files.

7. **If something breaks,** do not guess. Ask for the exact error output from the terminal.

8. **Use the Content Bible for ALL user-facing strings.** Do not invent copy. Every heading, button label, error message, notification, and prompt is already written in `Anshin_Content_Bible.md`. Read the relevant section and use those exact strings.

9. **Use the Voice Guide for any string NOT in the Content Bible.** If you need to write a string that isn't covered (edge case, new UI element), follow the voice guide's rules: honest over comforting, short over thorough, specific over abstract, present over performative.

10. **Theme must work in both light and dark.** Test every screen in both themes. Use the color system from Override 2.

11. **SOS must work offline.** After any SOS-related change, verify the entire SOS flow works in airplane mode. Audio, animations, prompts, episode logging — all offline.

12. **Content that users consume (lessons, grounding prompts, journal prompts) comes from the Content Bible.** Claude Code reads the file and generates Dart constant files. The founder does NOT manually copy-paste content into code.

---

## 3. Tech stack (confirmed, no changes from PRD §6)

| Layer | Choice |
|---|---|
| Frontend | Flutter (Dart) |
| State management | Riverpod (classic StateNotifier) |
| Routing | GoRouter |
| Backend | Firebase (Auth + Firestore + Cloud Functions + FCM + Analytics + Crashlytics + Remote Config) |
| Local DB (offline) | Drift (SQLite) |
| Subscriptions | RevenueCat SDK + Google Play Billing |
| Voice cues | Google TTS (flutter_tts — free, built into Android, no API key) |
| AI (V1.1, NOT MVP) | Anthropic Claude API |
| Crash reporting | Firebase Crashlytics |
| Analytics | Firebase Analytics |
| Feature flags | Firebase Remote Config |

---

## 4. Project folder structure (confirmed from PRD §6.2, with name change)

```
anshin/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── config/
│   │   │   ├── env.dart
│   │   │   ├── feature_flags.dart
│   │   │   └── secrets.dart              ← gitignored
│   │   ├── theme/
│   │   │   ├── app_colors.dart           ← Override 2 colors
│   │   │   ├── app_typography.dart
│   │   │   └── app_theme.dart            ← light + dark ThemeData
│   │   ├── constants/
│   │   │   ├── strings_home.dart         ← from Content Bible §4
│   │   │   ├── strings_sos.dart          ← from Content Bible §5
│   │   │   ├── strings_breathing.dart    ← from Content Bible §6
│   │   │   ├── strings_grounding.dart    ← from Content Bible §7
│   │   │   ├── strings_journal.dart      ← from Content Bible §9
│   │   │   ├── strings_checkin.dart      ← from Content Bible §10
│   │   │   ├── strings_progress.dart     ← from Content Bible §11
│   │   │   ├── strings_learn.dart        ← from Content Bible §12
│   │   │   ├── strings_paywall.dart      ← from Content Bible §13
│   │   │   ├── strings_notifications.dart← from Content Bible §14
│   │   │   ├── strings_settings.dart     ← from Content Bible §15
│   │   │   ├── strings_errors.dart       ← from Content Bible §17
│   │   │   ├── strings_crisis.dart       ← from Content Bible §18
│   │   │   └── strings_share.dart        ← from Content Bible §19
│   │   ├── services/
│   │   ├── models/
│   │   ├── utils/
│   │   └── widgets/
│   ├── features/
│   │   ├── auth/
│   │   ├── sos/
│   │   ├── breathing/
│   │   ├── grounding/
│   │   ├── daily/
│   │   ├── journal/
│   │   ├── progress/
│   │   ├── learn/
│   │   ├── ai_companion/                ← V1.1, empty for now
│   │   ├── visualize/                   ← V1.2, "coming soon" UI only
│   │   ├── sleep/                       ← V1.2, "coming soon" UI only
│   │   ├── subscription/
│   │   └── settings/
│   ├── mascot/
│   │   ├── assets/                      ← 12 emotion SVGs
│   │   ├── mascot_widget.dart           ← reusable mascot component
│   │   └── mascot_expressions.dart      ← enum + animation config
│   └── routing/
│       └── app_router.dart
├── assets/
│   ├── mascot/                          ← SVG files
│   ├── audio/                           ← ambient sounds (V1.2)
│   └── fonts/
├── docs/
│   ├── Anshin_PRD_v1.md
│   ├── Anshin_Voice_Guide.md
│   ├── Anshin_Mascot_Spec.md
│   ├── Anshin_Content_Bible.md
│   └── Anshin_Build_Runbook.md          ← THIS FILE
├── test/
├── android/
├── pubspec.yaml
└── firebase.json
```

---

## 5. Data model (confirmed from PRD §7, with name changes only)

No structural changes from PRD §7. Replace all "steady" references with "anshin". The Firestore collections and field names are identical. Key reminder:

```
users/{userId}
  - isLifetimePremium: boolean   ← founder/beta tester override
  - subscriptionStatus: 'free' | 'trialing' | 'premium' | 'expired'
  - (all other fields per PRD §7)

users/{userId}/checkins/{id}
users/{userId}/sessions/{id}
users/{userId}/episodes/{id}
users/{userId}/journal/{id}
```

Premium access check (used everywhere):
```dart
bool get hasPremiumAccess =>
    user.subscriptionStatus == 'premium' ||
    user.subscriptionStatus == 'trialing' ||
    user.isLifetimePremium == true;
```

---

## 6. The opening prompt for Claude Code

> **Founder: copy this ENTIRE block and paste it as your very first message to Claude Code. Do not modify it.**

```
I'm building a mobile app called "Anshin" — a panic attack and anxiety relief app for Android (Google Play Store), targeting women aged 22–35 in the US, UK, Canada, and Australia. I am a solo non-technical founder. You are my only developer.

FIRST — READ THESE 5 DOCUMENTS IN ORDER
All are in the /docs folder of this project:

1. Anshin_Build_Runbook.md — HIGHEST AUTHORITY. Contains overrides. Read this FIRST.
2. Anshin_PRD_v1.md — Features, architecture, data model, screens.
3. Anshin_Voice_Guide.md — How the app talks to users.
4. Anshin_Mascot_Spec.md — Mascot personality and 12 emotions.
5. Anshin_Content_Bible.md — Every user-facing string, lessons, legal docs.

CRITICAL: The Runbook (doc 1) contains 10 OVERRIDES in Section 1 that supersede the PRD and mascot spec. These include:
- App name is "Anshin" (NOT "Steady" as the PRD says)
- Package name is com.anshin.app
- Default theme is LIGHT (NOT dark as the PRD says)
- Mascot has arms, legs, kawaii-style eyes (NOT the minimal dot-eyes described in mascot spec)
- Home screen has 6 section cards (NOT the 3-tile layout in the PRD)
- Journal is a full 5-screen flow (NOT the simple free-write in the PRD)
- All other overrides are in Runbook Section 1

You MUST read all 10 overrides before writing any code.

COLLABORATION RULES (from Runbook Section 2):
- One task at a time. Complete, commit, push, wait for my go-ahead.
- Do not add features not in the documents. Ask me first.
- Do not build V1.1/V1.2/V1.3 features. Only MVP.
- When manual action is needed (Firebase console, Play Console), pause and instruct me.
- Use Content Bible strings for ALL user-facing text. Do not invent copy.
- After every task, commit with a meaningful message and push.
- Never commit: google-services.json, keystore, key.properties, .env, secrets.dart

CONFIRM UNDERSTANDING
After reading all 5 docs, answer these questions:
1. What is the app's one-line positioning?
2. What are the 6 home screen sections?
3. What is the default theme and what exception exists for SOS mode?
4. How does the mascot differ from the mascot spec document?
5. What is the hasPremiumAccess check logic?
6. Name 3 things that are NEVER behind the paywall.
7. What is the journal flow (list all screens)?
8. Where does the mascot NOT appear?

Wait for me to verify your answers before starting any work.

FIRST TASK (after I verify your answers):
When I say "go ahead with task 1":
1. Run `flutter create --project-name anshin --org com.anshin .` in this folder
2. Set up the complete folder structure from Runbook Section 4
3. Add all dependencies to pubspec.yaml (flutter_riverpod, go_router, firebase_core, firebase_auth, cloud_firestore, firebase_messaging, firebase_analytics, firebase_crashlytics, firebase_remote_config, flutter_tts, drift, sqflite, path_provider, shared_preferences, flutter_local_notifications, fl_chart, purchases_flutter, encrypt)
4. Read Content Bible and generate ALL strings_*.dart files in lib/core/constants/
5. Initialize git, create .gitignore with proper entries
6. Commit with message "chore: project scaffold with content strings"
7. Stop and report back
```

---

## 7. Sprint 0 — Setup before Day 1

### What you already have (skip)
✅ Flutter installed on Windows
✅ VS Code installed
✅ Claude Code installed (Windows app)
✅ GitHub account
✅ Firebase account (no projects yet)
✅ Google Play Console (paid)

### What you need to do (all manual, ~4 hours total)

#### M0.1 — Install Android Studio (for the SDK only)

**Why:** Flutter needs the Android SDK to compile. Android Studio is the easiest way to install it. You will never open Android Studio again after this.

**Steps:**
1. Download from `https://developer.android.com/studio`
2. Run installer → all defaults → Install
3. First launch → "Standard" → let it download SDK (~2 GB) → close Android Studio
4. Command Prompt → `flutter doctor` → Android toolchain should show ✓
5. If it asks for licenses: `flutter doctor --android-licenses` → press `y` to each

#### M0.2 — Start Play Console identity verification

**Why:** Takes 1–14 days. Start now or you're blocked on Day 14.

**Steps:**
1. `https://play.google.com/console`
2. If banner says "Verify identity" → click → upload government ID + selfie + address proof
3. Submit and wait

#### M0.3 — Create two Firebase projects

**Do this for EACH of `anshin-dev` and `anshin-prod`:**

1. `https://console.firebase.google.com/` → Create project → name it
2. Enable Google Analytics → Default Account → Create
3. Left sidebar → Build → Authentication → Get started
4. Sign-in method → Anonymous → Enable → Save
5. Add provider → Google → Enable → set support email → Save
6. Left sidebar → Build → Firestore Database → Create database
7. Location: `nam5` → Start in **production mode** → Enable
8. Firestore → Rules tab → delete all, paste:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
         match /{document=**} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
   }
   ```
   → Publish
9. Left sidebar → Engage → Messaging → Get started
10. Left sidebar → Release & Monitor → Crashlytics → Enable

**Do ALL 10 steps in BOTH projects.**

#### M0.4 — Create RevenueCat account

1. `https://www.revenuecat.com/` → Get started free
2. Create project → name: `anshin`

#### M0.5 — Create working folder + place documents

1. Create folder: `C:\Users\YourName\anshin\`
2. Inside it, create subfolder: `C:\Users\YourName\anshin\docs\`
3. Download all 5 documents (PRD, Voice Guide, Mascot Spec, Content Bible, this Runbook) and place them in the `docs` folder as `.md` files
4. Verify all 5 files are there

#### M0.6 — Open Claude Code

1. Open Claude Code Windows app
2. Navigate to / open the `C:\Users\YourName\anshin\` folder
3. Paste the opening prompt from Section 6 above
4. Wait for Claude Code to read all 5 docs and answer the 8 comprehension questions
5. Verify its answers are correct. If any answer is wrong, tell it to re-read. Do NOT proceed until all 8 are correct.

### ✅ Sprint 0 checklist

- [ ] `flutter doctor` shows ✓ for Android toolchain
- [ ] Play Console identity verification submitted
- [ ] `anshin-dev` Firebase project fully set up (Auth + Firestore + Messaging + Crashlytics)
- [ ] `anshin-prod` Firebase project fully set up
- [ ] RevenueCat `anshin` project exists
- [ ] `C:\Users\YourName\anshin\docs\` contains all 5 markdown files
- [ ] Claude Code opened in the anshin folder
- [ ] Opening prompt pasted, Claude Code answered all 8 questions correctly

---

## 8. Day-by-day task sequence

### DAYS 1–3 — Foundation

| Task | Tell Claude Code | Your manual checkpoint |
|---|---|---|
| **T1** | "Go ahead with task 1 from the opening prompt" | Verify GitHub repo `anshin` exists with correct folder structure + all strings_*.dart files generated from Content Bible |
| **T2** | "Task 2: Implement the theme system per Runbook Override 2. Create app_colors.dart with BOTH light and dark color palettes. Create app_typography.dart. Create app_theme.dart with light ThemeData (default) and dark ThemeData. Add theme switching support (light/dark/system) stored in SharedPreferences. Wire into app.dart. Commit and push." | Verify app compiles and runs on phone. Toggle theme in code to see both light and dark. |
| **T3** | "Task 3: Connect to Firebase dev environment. Walk me through the manual steps to register an Android app in the anshin-dev Firebase project (package name: com.anshin.app), download google-services.json, and where to place it. After I confirm, use flutterfire configure. Initialize Firebase in main.dart. Do NOT configure prod. Commit and push." | **Do manual step M1.1** (download google-services.json — Claude Code will instruct you) |
| **T4** | "Task 4: Implement anonymous Firebase Auth on first launch per PRD §3.11. Create auth_provider with Riverpod. On anonymous sign-in, create user document at users/{userId} in Firestore with fields from PRD §7 (use 'anshin' not 'steady' for any references). Include isLifetimePremium: false. Show brief loading splash (max 800ms) with mascot placeholder. Commit and push." | Run app → verify user document appears in Firebase Console → Firestore |
| **T5** | "Task 5: Set up GoRouter with routes for all screens. Create stub screens (Scaffold with screen name centered) for: splash, first_launch_gate, sos_active, onboarding_a/b/c, home, post_session, daily_checkin, journal_home, journal_entry_flow, breathing_picker, grounding_picker, learn_home, lesson_detail, visualize_home, sleep_home, paywall, settings, progress. Add 4-item bottom nav (Home, Tools, Progress, Profile). Commit and push." | Navigate between all stub screens on phone |

**Manual M1.1 — Download google-services.json:**
1. Firebase Console → `anshin-dev` → gear icon → Project settings
2. "Your apps" → Android icon
3. Package name: `com.anshin.app` → Register app
4. Download `google-services.json` → place at `anshin/android/app/google-services.json`
5. Tell Claude Code: "Done"

---

### DAYS 4–7 — Crisis spine

| Task | Tell Claude Code | Your manual checkpoint |
|---|---|---|
| **T6** | "Task 6: Build SOS active screen per PRD §3.1 and Runbook Override 2 (SOS is ALWAYS dark regardless of user theme). Full-screen dark bg #1A1F2E. Breathing circle animation (box 4-4-4-4). Synced text from Content Bible §5. Tiny X top right. No audio yet. 60fps smooth. Commit and push." | SOS reaches active state in <3 seconds from home |
| **T7** | "Task 7: Build breathing patterns model with all 4 patterns from Content Bible §6. Pattern picker screen. Box is free, other 3 gated behind hasPremiumAccess. Store user preference in Firestore. Commit and push." | Verify premium gate works — lock icon shows on non-box patterns |
| **T8** | "Task 8: Integrate flutter_tts for voice cues synced to breathing. Settings toggle voice on/off (default ON in SOS). Add haptic feedback at phase changes. Test offline. Commit and push." | Voice plays on phone. Turn on airplane mode — voice still works. |
| **T9** | "Task 9: Add 60-sec and 90-sec prompts per Content Bible §5. Build post-session screen per Content Bible §8 with rotating messages. If 'Worse' → route to grounding. Commit and push." | Complete full SOS flow end-to-end |
| **T10** | "Task 10: Build ALL 4 grounding techniques using EXACT prompts from Content Bible §7. One prompt per screen, full screen. 5-4-3-2-1 is free, other 3 are premium. Feeling check at end. All text from local constants, zero network. Commit and push." | Verify all 4 techniques work. Verify premium gate. |
| **T11** | "Task 11: Build episode + session logging. Drift/SQLite for local (source of truth). Background sync to Firestore. Must work offline. Commit and push." | **Do manual M2.1 — airplane mode test** |

**Manual M2.1 — Airplane mode test (CRITICAL):**
1. Phone → airplane mode ON
2. Force-close Anshin
3. Open Anshin → tap SOS → complete breathing → grounding → post-session → log episode
4. Everything must work. Voice must play. Log must save locally.
5. Turn off airplane mode → check Firebase Console → session should appear within 30 seconds
6. **If anything fails: STOP. Fix before Day 8.**

---

### DAYS 8–10 — Daily loop + journal

| Task | Tell Claude Code | Your manual checkpoint |
|---|---|---|
| **T12** | "Task 12: Build daily check-in per Content Bible §10. Mood 5-mascot scale, anxiety 1-10 slider, optional tags, save to Firestore with local cache. Show '✓ Checked in' on home. Commit and push." | Do a real check-in. Verify data in Firebase Console. |
| **T13** | "Task 13: Build the FULL journal flow per Content Bible §9 — all 6 screens: mood picker (12 mascot expressions in 4×3 grid with labels from Content Bible §1), accomplishments, release, gratitude, additional notes, completion (mascot proud, +5 points, share button). Build calendar view (monthly, swipeable). Build past entry detail view. Encrypt entries client-side with AES-256. Free users: 30 entry cap. Commit and push." | Complete a full journal entry. Verify it appears in calendar view. Verify encryption (entry content in Firestore should be unreadable). |
| **T14** | "Task 14: Build Progress tab per Content Bible §11. 7-day charts (mood line, anxiety bar) using fl_chart. Stats row. Streak display. Free users: 7 days. Premium: 30 days + rule-based insights (templates from Content Bible §11). Commit and push." | Verify charts render with your real data |

---

### DAYS 11–14 — Monetization + mascot + polish + ship

| Task | Tell Claude Code | Your manual checkpoint |
|---|---|---|
| **T15** | "Task 15: Build first-launch decision gate per Content Bible §2 and 3-screen onboarding per Content Bible §3. 'I need help right now' routes to SOS. 'I have a moment to set up' routes to onboarding. Store answers in user doc. SharedPreferences marks first-launch-complete. Commit and push." | Uninstall → reinstall → verify gate shows once only |
| **T16** | "Task 16: Generate the mascot SVGs for all 12 emotions. Follow Runbook Override 3: full kawaii character with arms, legs, expressive eyes with highlights, warm stone color palette (#C4B5A0 base). Reference style is the uploaded image (round character holding objects). Generate 12 base emotion SVGs + 6 contextual variants (holding pen, reading book, sleeping, breathing, sitting firmly, eyes closed) for the home screen cards. Place in assets/mascot/. Build MascotWidget as a reusable Flutter widget that takes an emotion enum and renders the correct SVG with breathing animation. Integrate mascot into: splash screen, home screen greeting, home cards, journal mood picker, journal completion, post-session, onboarding, empty states, error screens. App icon = mascot calm on cream background. Commit and push." | Verify mascot appears correctly on all specified screens. Verify it does NOT appear on SOS active or paywall. |
| **T17** | "Task 17: Integrate RevenueCat SDK. Pause and walk me through Play Console subscription product creation and RevenueCat linking. After I confirm, build paywall screen per Content Bible §13. Gate premium features with hasPremiumAccess. Commit and push." | **Do manual M3.1** (create subscription products + link RevenueCat) |
| **T18** | "Task 18: Build Learn section. Learn home screen with 3 shelves per Content Bible §12. Implement the 2 free lessons (What is a panic attack? / What is anxiety?) as scrollable text screens using EXACT content from Content Bible §12. Locked lesson cards show lock icon + 'Coming soon'. Build Visualize and Sleep home screens as 'Coming soon' empty states per Content Bible §16. Commit and push." | Read both lessons on phone end-to-end. Verify locked cards show properly. |
| **T19** | "Task 19: Build notifications per Content Bible §14. Local scheduled daily reminder at user's chosen time. Post-SOS follow-up 4h after session. Re-engagement after 7 days inactive. Build Settings screen per Content Bible §15 including theme toggle, share, rate, account management. Commit and push." | Set reminder for 2 min from now → verify it fires |
| **T20** | "Task 20: Build shareable journal card per Content Bible §19. Generate card image (1080×1920 and 1080×1080) with mascot in user's selected emotion, 'I journaled today with Anshin' text, anshin.app branding. Trigger via share button on journal completion screen. Use system share sheet. Commit and push." | Share a journal card to WhatsApp or save to gallery → verify it looks clean |
| **T21** | "Task 21: Prepare signed release. Pause and walk me through keystore generation. After I confirm keystore is generated and backed up, configure build.gradle for release, build .aab. Commit and push (excluding keystore and key.properties)." | **Do manual M3.2** (generate keystore, back it up in 3 places) |
| **T22** | "Task 22: Final polish. Run flutter analyze, fix all warnings. Verify all Content Bible strings are used (no TODO or placeholder text remaining). Test every screen in both light and dark themes. Test accessibility with TalkBack. Fix issues. Commit and push." | Test on phone: every screen, both themes, all flows |
| Submit | You submit manually | **Do manual M3.3–M3.6** (upload to Play Console, fill listing, create graphics, invite testers) |

---

## 9. Manual steps reference (Days 11–14)

### M3.1 — Create subscription products + link RevenueCat

**When:** T17 pauses for this.

**Step 1 — Create app in Play Console (if not done):**
1. Play Console → Create app
2. Name: `Anshin: Anxiety & Panic Relief`
3. Language: English (US) → App → Free → Accept → Create

**Step 2 — Upload first .aab (must happen before subscriptions):**
After T21 produces the .aab → Play Console → Release → Testing → Internal testing → Create release → Upload .aab → Save

**Step 3 — Create subscription products (after upload):**
1. Monetize → Products → Subscriptions → Create subscription
2. Product ID: `anshin_premium_monthly` (EXACT — cannot change)
3. Add base plan: ID `monthly`, period 1 month, price $7.99 USD, 7-day free trial
4. Activate
5. Repeat: `anshin_premium_annual`, period 1 year, $49.99 USD, 7-day free trial

**Step 4 — Link RevenueCat:**
1. RevenueCat → anshin project → Apps → Add app → Google Play
2. Package: `com.anshin.app`
3. Create service account in Google Cloud Console (RevenueCat guides you)
4. Upload service account JSON to RevenueCat
5. Products → attach both subscription IDs
6. Entitlements → create `premium` → attach both products
7. Copy RevenueCat public SDK key → tell Claude Code

### M3.2 — Generate and back up keystore

**When:** T21 pauses for this.

1. Command Prompt → `cd C:\Users\YourName\anshin\android`
2. `keytool -genkey -v -keystore anshin-release.keystore -alias anshin -keyalg RSA -keysize 2048 -validity 10000`
3. Set strong password → save in password manager + written down + encrypted note
4. **BACK UP the keystore file to: Google Drive + email to yourself + USB drive**
5. Create `android/key.properties`:
   ```
   storePassword=your_password
   keyPassword=your_password
   keyAlias=anshin
   storeFile=../anshin-release.keystore
   ```
6. Verify both files are in `.gitignore`
7. Tell Claude Code: "Keystore generated and backed up in 3 places"

### M3.3–M3.6 — Play Store submission

Follow the same steps as the previous runbook version for: uploading .aab, filling Play Console details (using Content Bible §20 for listing copy), creating graphics in Canva (free), generating privacy policy URL via GitHub Pages, and inviting 12 beta testers.

Key references:
- Play Store title: Content Bible §20
- Short description: Content Bible §20
- Full description: Content Bible §20
- Privacy Policy URL: host Content Bible §21 on GitHub Pages
- Terms URL: host Content Bible §22 on GitHub Pages

### M3.7 — Set your lifetime premium override

1. Install Anshin on your phone from internal testing
2. Open → complete onboarding → creates your user doc
3. Firebase Console → `anshin-prod` → Firestore → `users` → find your document
4. Set `isLifetimePremium` to `true`
5. Reopen app → all premium features unlocked

---

## 10. After launch — ongoing work

**Daily (10 min):** Check Play Console reviews, Crashlytics, RevenueCat dashboard.

**Weekly (30 min):** Batch user feedback into Claude Code fix sessions. Post one honest progress update on LinkedIn/Twitter.

**Monthly:** Review metrics vs targets from PRD §10. Decide next sprint.

**Sprint 2 (V1.1):** AI Companion — Claude Code writes system prompt with safety guardrails, builds chat UI, integrates Anthropic API.

**Sprint 3 (V1.2):** Sleep + Visualize content — you and Claude write scripts together, Claude Code integrates audio/text into the existing empty shelves.

**Sprint 4 (V1.3):** Full Learn section — Understanding + Short-term + Long-term lesson tracks.

---

## 11. When things break

1. Screenshot the error → paste to Claude Code: "Here's the error: [paste]"
2. If first fix fails: "That didn't work. Terminal now shows: [paste]"
3. If three attempts fail: revert with `git log` → find last working commit → `git reset --hard <hash>` → try different approach
4. If you're stuck on something not code-related (Firebase UI changed, Play Console confusion): screenshot and send to me (Claude chat), not Claude Code

---

## 12. The 3 rules that matter most

1. **One task at a time. Commit after each.** This is the discipline that prevents the "everything broke and I can't debug" failure.

2. **SOS works offline. Always. Test after every SOS change.** This is the feature. Everything else is secondary.

3. **Content Bible strings, not invented copy.** Every word the user sees is already written. Claude Code reads the file and uses those words. No improvising.

---

**End of Runbook.**

**You now have 5 documents. Place all 5 in the /docs folder. Paste the opening prompt. Build Anshin.**
