# Steady — Product Requirements Document (v1)

> **Working name:** Steady · **Alternatives to consider before launch:** Anchor, Ground, Stillpoint
> **Document type:** Execution-ready PRD for solo non-technical founder using Claude Code / Codex
> **Last updated:** April 2026
> **Owner:** Harsha
> **Companion doc:** Market research v1 (already complete — referenced throughout, not repeated)

---

## 0. How to read this document

This PRD is structured so you can build the app **one feature at a time without ever reaching a state where the app is broken.** Every section answers a different question:

- Sections 1–2: What we're building and why
- Section 3: What each feature actually does (your spec when prompting Codex)
- Section 4: Every screen, in order, with what to show and what to hide
- Section 5: How the app should feel
- Sections 6–7: How the app is built (architecture + data model)
- Sections 8–9: How money works + how YOU test everything for free
- Sections 10–11: Targets and the actual day-by-day build plan
- Sections 12–14: Risks, summary, and why this can win

**Critical reading order for build:** Read sections 6, 7, 9, 11 BEFORE writing a single line of code. Those four sections prevent 90% of the structural mistakes that kill solo-founder apps.

---

## 1. Product Definition

### 1.1 Working name
**Steady.** It captures both moments the app serves: *steadying yourself* during a panic attack, and *becoming steady* over time. Short, brandable, memorable. Final naming should be confirmed against Play Store + trademark searches before public launch.

### 1.2 One-line positioning
**The panic attack app that actually works mid-attack — and teaches you to need it less over time.**

### 1.3 Core value proposition
Steady is the only mental health app that reliably stops a panic attack within 90 seconds *and* progressively trains your nervous system to have fewer of them. Where Calm and Headspace sell content libraries and Rootd sells a panic button, Steady combines instant crisis relief with an AI companion that learns your specific anxiety patterns and reduces the frequency of episodes over months.

### 1.4 Target users

**Primary user (build the entire app for this person):**
- Female, age 22–35
- Living in US, UK, Canada, or Australia
- English-speaking, urban or suburban
- Experiencing panic attacks for the first time, or escalating in frequency over the past 6 months
- Already subscribes to 2–4 other apps (Spotify, Netflix, possibly a fitness app)
- Has either avoided therapy or is on a waitlist
- Searches the App Store late at night or during a panic attack itself
- Cares about privacy and is suspicious of mental health apps that "feel like data harvesting"

**Secondary user (build for them in V1.2+, not before):**
- Male, age 25–40
- Has unnamed anxiety, would never describe himself as "anxious"
- Uses fitness/productivity apps freely
- Opens to "mental fitness" framing, closed to "mental health" framing
- Will be served by a future repositioning track inside the same app, not a separate product

### 1.5 Problem statement
A 27-year-old woman in Toronto has her first panic attack at 11:47 PM. She believes she is having a heart attack. She searches "panic attack help" on the Play Store with shaking hands. She downloads the top result, taps it, and is greeted by an account creation screen, then a 6-screen onboarding, then a paywall, then a meditation library. By the time she would reach a useful feature, the panic attack has either passed or escalated into the ER. She uninstalls the app within 48 hours. **Every existing major mental health app fails this user.** Steady is built so that the same woman, in the same situation, taps once and is in a guided breathing animation within 3 seconds — without an account, without a paywall, without a tutorial.

---

## 2. Feature Strategy

### 2.1 The three buckets

| Bucket | Definition | Discipline |
|---|---|---|
| **MVP (Weeks 1–2)** | The absolute minimum to launch a credible, useful app on Play Store | Cut hard. Ship. |
| **V1.1–V1.3 (Weeks 3–10)** | Differentiation features that earn premium pricing | Add one at a time. Test each. |
| **Avoid** | Features the research showed are saturated or value-destructive | Don't build, even if tempted |

### 2.2 MVP features (must build for launch)

| # | Feature | Why it exists (research link) | What competitors do | What we do differently |
|---|---|---|---|---|
| 1 | **Instant SOS / Panic Mode** | "30 seconds of patience" insight; Rootd's panic button is the most-praised UX in the entire category | Rootd has the best panic button. Calm/Headspace have nothing comparable. | One tap from app open OR home screen widget → guided experience starts in <3 sec. **Works fully offline.** Works without account. |
| 2 | **Guided breathing engine (4 patterns)** | Universal need; deterministic, reliable, no AI dependency | Most apps have one box-breathing pattern | Box, 4-7-8, physiological sigh, coherent breathing. Visual + haptic + optional voice. User picks favorite, app remembers. |
| 3 | **Grounding library (5–4–3–2–1 + variants)** | Validation insight — users need to know "this is survivable" | Most apps tuck this inside meditation libraries | Front-and-center as a standalone tool, not buried in content |
| 4 | **Daily check-in (15 sec)** | Builds the daily habit needed for subscription conversion (only daily users will pay >$20/mo) | Sanvello had this; now sunset. Headspace doesn't have a fast version. | Single screen, 3 taps max. Mood + intensity + optional one-line note. Drives all personalization downstream. |
| 5 | **Simple journal** | Reflection is therapeutic; data feeds future AI personalization | Most apps have basic note fields | Prompted entries with CBT-style prompts ("What's the worst that could happen? What's most likely?"). Searchable later. |
| 6 | **Episode log** | Lets user see "this is getting better" — the #1 retention driver | None of the major apps do this well | After every SOS use, optional 10-second log: trigger, intensity, what helped. Becomes personal pattern data. |
| 7 | **Account & auth** | Required for sync, premium, future personalization | Standard | Anonymous account by default. Email/Google sign-in only when user wants sync or premium. Never blocks SOS. |
| 8 | **Subscription + paywall** | Revenue. Annual plan is 60.6% of H&F subscription revenue. | Most use hard paywalls and aggressive trials | Soft paywall. Crisis features permanently free. Paywall only on growth/learning content. |

### 2.3 V1.1–V1.3 features (post-launch, in this order)

| Version | Feature | Why later not now | Trigger to build |
|---|---|---|---|
| **V1.1 (Week 4–6)** | AI Companion (LLM chat) | Highest risk feature: needs guardrails, costs money per message, can hallucinate. Launch without it, prove core works. | After 500+ active users, you have data on what they actually need help with |
| **V1.2 (Week 7–8)** | Sleep & nighttime anxiety pack | Sleep is the #1 conversion driver but requires high-quality audio production | After AI companion is stable; can use AI-generated narration as v1 |
| **V1.3 (Week 9–10)** | Structured CBT lesson tracks (anxiety 101, panic 101, health anxiety, social anxiety) | Content production is slow; needs to feel curated not generated | After you understand which anxiety subtypes your users actually have |
| **V2.0 (Month 4+)** | iOS launch | Don't dilute focus until Android is stable and revenue is real | $5K MRR or 10K active users, whichever comes first |
| **V2.1 (Month 5+)** | "Mental Fitness" alt-positioning for male users | Secondary segment; needs separate marketing not a separate app | After V1 product-market fit is proven |

### 2.4 Avoid list (do not build, even if tempted)

| Feature | Why to avoid |
|---|---|
| Large meditation library | Calm has 800+, Insight Timer has 120K. You will not win on volume. Generic meditation is not what panic users need. |
| Therapist marketplace / chat with humans | Operationally impossible for a solo founder. BetterHelp owns this space. |
| Heavy gamification (virtual pet, etc.) | Finch owns this. Tone-deaf during panic. |
| Community / social feed | Moderation cost is fatal for a solo founder; mental health communities require constant safety oversight |
| Wearable integration (Apple Watch, etc.) | iOS is on V2 anyway; Android Wear has small share. Don't waste cycles. |
| DiGA certification (Germany prescription pathway) | Requires medical device cert, ~$1M, multi-year. Unrealistic. |
| Lifetime deals | Sacrifices LTV and attracts the worst-quality users |
| Crystals, astrology, chakras, "energy" content | Erodes clinical credibility — your trust moat |

---

## 3. Detailed Feature Breakdown

> Each feature below is written as a spec you can paste into Claude Code. Build them **in this order** during your 2-week MVP. Do not start feature N+1 until feature N works end-to-end on a real device.

### 3.1 Feature: Instant SOS / Panic Mode

**User problem solved:** "I'm having a panic attack RIGHT NOW. Help me in under 5 seconds."

**Trigger:** User opens app during a panic attack OR taps home screen widget OR taps SOS button on home screen of the app.

**Step-by-step behavior:**
1. App launches → if first launch ever, show one-screen welcome with single button "I need help now" + small text "or tap below to set up first time"
2. Tapping "I need help now" → enters SOS mode in <1 second
3. SOS mode shows full-screen, dark background, single large breathing circle
4. Auto-starts box breathing (4-4-4-4) with visual circle and optional voice ("Breathe in… hold… breathe out… hold…")
5. After 60 seconds, soft prompt at bottom: "Want to try a grounding exercise?" (Yes / Keep breathing)
6. After 90 seconds, second soft prompt: "How are you feeling?" with three buttons: "Better" / "Same" / "Worse"
7. If "Better" or "Same" → transition to post-session screen (3.10)
8. If "Worse" → switch to grounding (5-4-3-2-1) automatically
9. At any point, user can tap a tiny "X" in top right to exit (no confirmation modal — never trap a panicking user)

**Inputs:** None required. Optionally: user's saved breathing preference (from previous use).

**Outputs:** Episode log entry (timestamped, type: SOS, duration, exit reason). Stored locally first, synced when online.

**Edge cases to handle:**
- No internet connection → must work fully offline (all assets bundled)
- App killed mid-session → on next open, ask "You exited an SOS session 3 minutes ago — how are you doing?"
- User taps SOS multiple times in 1 minute → don't restart, just continue
- Volume at 0% → show visual cue that audio is muted
- Background audio playing (Spotify) → pause it gracefully, restore on exit
- Phone in low-power mode → animations must remain smooth (use simple CSS-style animations, not heavy 3D)
- Screen reader on (accessibility) → all instructions must be readable by TalkBack

**Dependencies:** None. This is the foundation. Build this first.

**Critical constraint:** SOS MUST WORK WITHOUT INTERNET. All audio, all animations, all text must be bundled in the app. If your app has a "Connecting…" spinner during a panic attack, you have failed.

---

### 3.2 Feature: Guided Breathing Engine

**User problem solved:** "I need a reliable, non-thinking way to regulate my nervous system on demand."

**Trigger:** Inside SOS mode (auto-launched), OR from home screen → "Breathing exercises" tile, OR scheduled in daily flow.

**Step-by-step behavior:**
1. User picks pattern (or app picks based on their preference): Box (4-4-4-4), 4-7-8, Physiological Sigh, Coherent (5-5)
2. Brief 1-line explanation appears below pattern name on selection screen ("Box breathing slows your heart rate within 60 seconds")
3. Tap "Start" → full-screen breathing visualization
4. Circle expands and contracts in sync with the pattern
5. Optional voice cues (toggle in settings, default ON for SOS mode, default OFF for daily use)
6. Optional haptic pulse at each phase change (default ON)
7. Optional ambient sound (rain, ocean, brown noise, silence — default silence)
8. Session length: user picks 1, 3, 5, or 10 minutes. Default 3 min.
9. End of session → "Nice work" + optional micro-journal: "What's one word for how you feel?"

**Inputs:** Pattern, duration, voice on/off, haptic on/off, sound choice.

**Outputs:** Session record (pattern, duration, completed Y/N, time of day).

**Edge cases:**
- User exits early → still log as partial session
- Phone call comes in → pause gracefully, resume on call end
- App backgrounded → continue if user returns within 30 sec, otherwise end session

**Dependencies:** Audio assets (4 voice files for cues, 4 ambient sound files). Episode logging system.

---

### 3.3 Feature: Grounding Library

**User problem solved:** "Breathing alone isn't bringing me back. I need to feel anchored to physical reality."

**Trigger:** From SOS mode (auto-suggested at 60-sec mark), OR from home screen, OR from daily flow.

**Step-by-step behavior:**
1. User chooses technique: 5-4-3-2-1 (senses), Body scan (60 sec), Cold water cue, Movement reset
2. Each technique presents one prompt at a time, full screen, no clutter
3. For 5-4-3-2-1: "Look around. Name 5 things you can see." → tap to continue → "Name 4 things you can touch." etc.
4. User can advance at their own pace (no timer)
5. End → "How are you feeling now?" three-button check
6. If still distressed → suggest a different technique or breathing

**Inputs:** None required.

**Outputs:** Session record (technique used, completed Y/N).

**Edge cases:**
- User taps through too fast → no penalty; the act of reading is therapeutic even if shallow
- User exits mid-way → log as partial

**Dependencies:** Static text content (write 4–6 prompts per technique). No audio required for V1; voiceover comes in V1.3.

---

### 3.4 Feature: AI Companion (V1.1, NOT in MVP)

**User problem solved:** "I want to talk to something that understands what I'm feeling, in the moment, without judgment."

**Trigger:** From home screen → "Talk it out" tile. From post-session screen ("Want to talk about it?"). From journal entry detail page.

**Step-by-step behavior:**
1. Chat interface opens (looks like iMessage, not like Wysa's old GIF-heavy interface)
2. AI greets contextually based on time of day and recent activity ("Hey — saw you used SOS this morning. How are you doing now?")
3. User types or voice-dictates message
4. AI responds with CBT-informed, warm, non-clinical reply within 2–3 seconds
5. AI can suggest specific in-app actions ("Want to try a breathing exercise together?") with tappable buttons that launch those features
6. Conversation history persists across sessions (the AI remembers your last 5–10 conversations and your patterns)
7. Hard safety guardrails:
   - If user mentions suicide, self-harm, or harming others → AI responds with concern, surfaces crisis hotline (988 in US, equivalents per region), offers in-app crisis resources, and does NOT attempt therapy
   - Never give medical advice
   - Never give medication advice
   - Never claim to be a therapist
   - Refuse to engage in role-play or relationship simulation

**Inputs:** User message, conversation history (last 10 messages), user profile context (anxiety patterns, recent episodes).

**Outputs:** AI message, optional suggested action button.

**Edge cases:**
- Network failure → "I can't connect right now, but here's what you can do offline" + buttons to SOS/breathing/grounding
- API rate limit → graceful fallback message
- User typing for >2 minutes without sending → no nag
- User sending hostile/abusive messages → AI maintains warmth, doesn't escalate, doesn't moralize
- User in another language → V1.1 is English-only; politely note this

**Dependencies:** LLM API (Claude or GPT-4o), user profile data, episode history. **Premium feature** — not free.

**Cost control:** Hard cap of 50 messages per day per user. After that, gentle "Let's continue tomorrow — meanwhile, try journaling about it."

---

### 3.5 Feature: Daily Personalized Flow

**User problem solved:** "Between panic attacks, what should I actually do every day to get better?"

**Trigger:** Push notification at user-selected time (default 8 PM). Home screen "Today" tile. Streak reminder.

**Step-by-step behavior:**
1. Daily check-in (15 sec): mood (1–5 emoji scale), anxiety level (1–10 slider), optional one-tap tags ("work", "sleep", "relationship", "health", "nothing specific")
2. Based on inputs, one recommended activity is surfaced:
   - High anxiety → breathing or grounding
   - Low anxiety, calm → CBT lesson (V1.3) or AI reflection (V1.1)
   - Pre-bedtime + sleep tag → sleep content (V1.2)
   - Recent SOS use → "How's it been since this morning?"
3. Activity is a single tile, not a list. One choice. One action.
4. After completion → quick "Done" celebration (subtle, not gamified loud) + streak update
5. User can override and pick something else from a small menu

**Inputs:** Mood, anxiety level, tags, time of day, recent activity history.

**Outputs:** Check-in record, activity completion, streak update.

**Edge cases:**
- User skips many days → no shame messaging; "Welcome back, no streak shame here"
- User completes activity in <10 sec (probably tapped through) → still credit it
- User does multiple activities in one day → all credited

**Dependencies:** Check-in data model, activity recommendation logic (rule-based for V1, AI-driven later).

---

### 3.6 Feature: Sleep & Night Anxiety Support (V1.2, NOT in MVP)

**User problem solved:** "I can't fall asleep because my mind won't stop racing." (Sleep is the #1 driver of subscription conversion in the entire category.)

**Trigger:** Bedtime reminder (user sets their target sleep time). Home screen → "Wind down" tile. Daily flow at evening times.

**Step-by-step behavior:**
1. Wind-down sequence offered: 5-min breathing → 10-min body scan → 20-min sleep story OR ambient sound
2. Auto-dim screen, switch to red-tinted UI
3. Sleep story or ambient sound auto-stops after preset duration
4. If user uses SOS at night → after session, gentle option "Want help getting back to sleep?"

**Inputs:** Target sleep time, sound preference, story preference.

**Outputs:** Sleep session record.

**Edge cases:**
- User falls asleep mid-session → audio fades out, app silences notifications until morning
- User wakes at 3 AM → "Middle-of-night mode" with shorter, gentler content

**Dependencies:** Sleep audio content (5–10 stories, 5+ ambient tracks). **Premium feature.**

---

### 3.7 Feature: Progress Tracking

**User problem solved:** "Am I actually getting better, or am I wasting my time?"

**Trigger:** Home screen tab "Progress". Auto-shown after every Sunday check-in.

**Step-by-step behavior:**
1. Weekly view: anxiety trend line (avg of daily check-ins), SOS uses count, sessions completed
2. Patterns surfaced: "You used SOS 3x this week — all on weekday mornings. Want to set a morning grounding habit?"
3. Monthly view: longer trend line, milestones ("First week with no SOS use!")
4. Honest framing: never declare "you're cured" or "you've leveled up"

**Inputs:** All historical check-ins, sessions, episodes.

**Outputs:** Visual charts, pattern insights.

**Edge cases:**
- Insufficient data (< 7 days) → show "Keep going, your patterns will appear after a week"
- User on bad week → no shame; "This week was harder. Most months have a hard week. Here's what helped you in past hard weeks."

**Dependencies:** Check-in + session + episode data. Charting library.

---

### 3.8 Feature: Journaling

**User problem solved:** "I need to get this out of my head before I can move on."

**Trigger:** From home screen → "Journal". From post-session prompt. From daily flow.

**Step-by-step behavior:**
1. Two modes: Free write (blank page) or Prompted (CBT-style prompts)
2. Prompts rotate based on context: panic attack just happened → "What were you doing right before? What thought came first?"; calm evening → "What's one thing that went well today?"
3. Entries are private, encrypted at rest, never sent to AI without explicit user toggle
4. Searchable by date, tag, mood at time of writing
5. Word count visible (subtle), no minimum required

**Inputs:** User text, optional tags, optional mood at time of writing.

**Outputs:** Stored entry.

**Edge cases:**
- User writes very long entry → no limit
- User abandons entry mid-way → auto-save as draft after 30 sec
- User wants to delete → permanent delete, no recovery, no "are you sure" beyond a single confirmation

**Dependencies:** Encrypted storage. **Free feature** (basic). Prompts library (premium).

---

### 3.9 Feature: Notification System

**User problem solved:** "Help me build a habit without nagging me."

**Trigger:** Scheduled by user, OR triggered by inactivity, OR triggered by patterns.

**Step-by-step behavior:**
1. Onboarding asks: "When would you like a daily check-in reminder?" (defaults to 8 PM, user can pick or decline)
2. Notification copy is warm and specific, not generic ("How's today going?" not "Don't forget to use Steady")
3. Maximum 1 notification per day unless user is in active SOS recovery
4. Smart suppression: if user has already opened the app today, no notification
5. After 7 days of inactivity → one re-engagement message ("It's okay to take a break. We're here when you need us.") then silence for 21 days
6. Never sends notifications between 10 PM and 7 AM unless user has set that window themselves

**Inputs:** User preference, activity history.

**Outputs:** FCM-delivered notifications.

**Edge cases:**
- User on Do Not Disturb → respect it
- User in flight mode → queue, deliver when online
- User has notifications disabled at OS level → don't try to override; show in-app gentle reminder instead

**Dependencies:** Firebase Cloud Messaging. User notification preferences.

---

### 3.10 Feature: Post-Session Screen

**User problem solved:** "I just had a panic attack — what now?"

**Trigger:** After every SOS session ends (whether completed or exited).

**Step-by-step behavior:**
1. Soft, warm screen: "You did it. You're here."
2. Three optional actions, no forced flow:
   - "Log this episode" (10 sec form: trigger, intensity, what helped)
   - "Talk it out" (opens AI companion in V1.1+)
   - "I just want to rest" (returns to home or closes app gracefully)
3. No paywall, no upsell, no rating prompt, no "share with a friend"

**Inputs:** SOS session data.

**Outputs:** Optional episode log.

**Edge cases:**
- User taps "I just want to rest" → close to home screen with no further interruption for at least 30 minutes (no notifications, no popups)

**Dependencies:** Episode logging system.

---

### 3.11 Feature: Authentication & Profile

**User problem solved:** "I need my data on my new phone, but I don't want to give my email just to use a panic button."

**Trigger:** Required only when user wants sync, premium, or AI features. Never blocks SOS or breathing.

**Step-by-step behavior:**
1. App generates anonymous Firebase Auth ID on first launch (silent, no UI)
2. All data is tied to this anonymous ID — full functionality available
3. When user wants to sync to another device, OR upgrade to premium, OR use AI → prompt to "create account" via:
   - Sign in with Google (one tap)
   - Sign in with Email + magic link
4. Anonymous data is migrated to the authenticated account seamlessly
5. Profile screen shows: display name (optional), subscription status, data export option, delete account option

**Inputs:** Auth credentials.

**Outputs:** Authenticated user record.

**Edge cases:**
- User signs in on second device → data syncs from cloud
- User deletes app and reinstalls → anonymous data is lost unless they signed in (warn them about this on first launch in fine print)
- User deletes account → 30-day soft delete, then hard delete (GDPR)

**Dependencies:** Firebase Auth.

---

### 3.12 Feature: Subscription & Paywall

**User problem solved:** Sustainable revenue without compromising the crisis-help mission.

**Trigger:** User taps any premium-only feature OR user taps "Upgrade" in settings.

**Step-by-step behavior:**
1. Paywall is a single beautiful screen, not a modal stack
2. Shows: 3 most compelling premium benefits (max), price, "Start 7-day free trial" CTA
3. Annual plan highlighted as default with "Save 48%" badge
4. Monthly plan available below as secondary option
5. Restore Purchase link in small text
6. Terms / Privacy links at bottom
7. Single "X" to close, no dark patterns
8. Free trial requires payment method but is clearly labeled "Free for 7 days, then $X/year. Cancel anytime in Play Store."

**Inputs:** None to view. Payment method to subscribe.

**Outputs:** Subscription record (via RevenueCat).

**Edge cases:**
- User in country with different currency → RevenueCat handles
- User cancels mid-trial → access continues until trial end, then graceful downgrade
- User's payment fails → grace period of 7 days, then downgrade
- Restoring purchase on new device → RevenueCat handles via auth ID

**Dependencies:** RevenueCat SDK, Google Play Billing.

---

## 4. Screen-by-Screen UX Flow

> Every screen below is described with: purpose, what user sees, emotional state, primary CTA, secondary actions, what NOT to show, and UX notes.

### Screen 1 — App Launch / Splash

- **Purpose:** Get user from tap to usable in <1 second.
- **What user sees:** Brand mark for max 800ms, then routes to either first-launch screen OR home screen depending on prior usage.
- **Emotional state:** Could be anything from calm to mid-panic — assume worst case.
- **Primary CTA:** None — this is a passthrough.
- **Secondary actions:** None.
- **Must NOT show:** Loading spinners. Promotional content. Permission prompts.
- **UX notes:** No animation longer than 800ms. No "Welcome!" copy. Get out of the way.

---

### Screen 2 — First-Launch Decision Gate (only on absolute first open ever)

- **Purpose:** Honor both user types: "I need help now" and "I want to set this up properly."
- **What user sees:**
  - App name at top (small, reassuring)
  - Two large buttons:
    - **"I need help right now"** (primary, warm tone, large)
    - **"Set up first, I have time"** (secondary, smaller)
  - Single line of microcopy below: "No account needed for help."
- **Emotional state:** Either crisis or curious. Both are equal here.
- **Primary CTA:** "I need help right now"
- **Secondary actions:** "Set up first"
- **Must NOT show:** Sign-in prompt. Email field. Permission requests. Onboarding tour. Logo splash. Marketing copy.
- **UX notes:** This screen MUST resolve in <2 seconds from cold app open. Test on a 3-year-old Android device.

---

### Screen 3 — SOS / Panic Mode (Active)

- **Purpose:** Stop the panic attack within 90 seconds.
- **What user sees:**
  - Full-screen dark background (deep navy or charcoal — not pure black, not white)
  - Single breathing circle in center, slowly expanding/contracting
  - Below circle: tiny text instruction synced to breath ("Breathe in… hold… breathe out… hold…")
  - At top right: tiny X (close) — easy to miss but available
  - At bottom: nothing for first 60 seconds, then soft prompt
- **Emotional state:** Acute distress, possibly hyperventilating, possibly dissociating.
- **Primary CTA:** None — the breathing IS the CTA.
- **Secondary actions:** Tap circle to start over, tap X to exit.
- **Must NOT show:** Anything that requires reading more than 4 words. Bright colors. Notifications. Ads. Paywall. Account prompts. Other navigation. Settings. Achievements.
- **UX notes:** Animation must be smooth at 60fps even on low-end Android. Pre-load audio. Use system haptics for breath cue. Screen brightness should auto-dim if at max.

---

### Screen 4 — Onboarding (3 screens, only for "Set up first" path)

- **Purpose:** Personalize the daily experience and capture key consent. NEVER block SOS access.
- **Screen 4a — What brings you here?** (one-tap choice: Panic attacks / General anxiety / Sleep issues / Stress / Just exploring)
- **Screen 4b — How often does this happen?** (Daily / A few times a week / Weekly / Rarely / This is new)
- **Screen 4c — Notification preference?** ("When should we check in with you?" — time picker, default 8 PM, with "Not now" escape)
- **Emotional state:** Calm-curious, maybe slightly anxious about commitment.
- **Primary CTA per screen:** "Continue" (only enabled after a choice).
- **Secondary actions:** "Skip" (visible but secondary) — skipping uses defaults.
- **Must NOT show:** Account creation. Email field. Paywall. Long explanations. More than 3 onboarding screens. Multi-select with 10 options.
- **UX notes:** Each screen single-question, large touch targets, big readable type, easy "back" arrow. No progress bar that says "1 of 6" — it discourages people. Use dots instead.

---

### Screen 5 — Home Screen (the daily landing)

- **Purpose:** Make the next useful action obvious. Always make SOS reachable in 1 tap.
- **What user sees (top to bottom):**
  - Greeting bar: "Good evening, [name or 'friend']" (subtle, not loud)
  - Large persistent **SOS button** at top — always visible, always 1 tap away
  - "Today" card: today's recommended activity (changes based on time + mood + history)
  - Quick action tiles (3): Breathing, Grounding, Journal
  - Streak indicator (subtle, below quick actions, dismissible)
  - Bottom nav (4 items): Home, Tools, Progress, Profile
- **Emotional state:** Generally calm-curious. Could be returning after an episode.
- **Primary CTA:** Today's recommended activity OR SOS (depending on user's state).
- **Secondary actions:** Quick action tiles, bottom nav.
- **Must NOT show:** Pop-up ads. Aggressive upsell. "Rate the app" prompt before 7 days of use. Modal overlays of any kind on first home view.
- **UX notes:** SOS button must be visually distinct (warm color like coral or muted red — calming-but-noticeable). It should be reachable by thumb on any screen size.

---

### Screen 6 — SOS Entry from Home

- **Purpose:** Quick confirmation that SOS is launching, then immediate entry.
- **What user sees:** From home, tap SOS button → 200ms transition → directly into SOS active screen (Screen 3).
- **Emotional state:** Distress — tapping SOS is a deliberate act.
- **Primary CTA:** Implicit (the breathing starts).
- **Must NOT show:** Confirmation modal ("Are you sure you want to start SOS?"). Loading spinner. Tutorial overlay.
- **UX notes:** Zero friction. The button is the confirmation.

---

### Screen 7 — Post-Session Screen

- **Purpose:** Acknowledge the user, offer optional next steps, never demand anything.
- **What user sees:**
  - Soft, warm transition (not bright)
  - Top: "You did it. You're here." (large, gentle type)
  - Three optional cards:
    - "Log this episode" (10-second form)
    - "Talk it out" (V1.1: AI; V1.0: opens journal)
    - "I just want to rest" (closes flow)
  - Subtle illustration (optional) — abstract calming shape, not a face
- **Emotional state:** Coming down from peak distress, fragile, possibly tearful.
- **Primary CTA:** None — all three are equal weight.
- **Secondary actions:** Same three.
- **Must NOT show:** Rating prompt. Subscription prompt. Share buttons. Achievement unlocked banner. Streak celebration.
- **UX notes:** Generous whitespace. No animations. Allow user to sit on this screen indefinitely.

---

### Screen 8 — Daily Check-in

- **Purpose:** Capture mood + anxiety in <15 seconds, drive personalization.
- **What user sees:**
  - "How are you today?" (large)
  - 5 emoji mood scale (not numbers — emojis are faster)
  - Anxiety level slider (1-10, large thumb target)
  - Optional tag chips: Work / Sleep / Relationship / Health / Nothing specific
  - "Save" button
- **Emotional state:** Reflective, neutral.
- **Primary CTA:** "Save"
- **Secondary actions:** "Add a note" (optional journal entry)
- **Must NOT show:** Required fields beyond mood. Long questionnaires. Validation errors.
- **UX notes:** Should be fully completable in <15 seconds. No multi-step.

---

### Screen 9 — AI Companion Chat (V1.1)

- **Purpose:** Conversational support for daily reflection and between-crisis processing.
- **What user sees:** Standard chat interface (iMessage-like). Bottom: text input + voice button. Top: "Steady" name with small status indicator. Background: soft warm color.
- **Emotional state:** Reflective, possibly seeking validation.
- **Primary CTA:** Type / send.
- **Secondary actions:** Voice input, suggested action buttons within AI replies.
- **Must NOT show:** Aggressive AI personality. Emojis from AI. Disclaimers in every message. Animated mascot characters. Read receipts.
- **UX notes:** AI response time target: <3 seconds. If slower, show typing indicator. AI never sends multiple messages back-to-back without user reply.

---

### Screen 10 — Paywall

- **Purpose:** Convert the user who has experienced value, without dark patterns.
- **What user sees:**
  - Header: "Unlock Steady Premium"
  - 3 benefit lines (max), each with icon:
    - "AI companion that knows your patterns"
    - "Sleep stories + nighttime anxiety pack"
    - "Full CBT lesson library"
  - Pricing card: Annual highlighted ($49.99/year — Save 48%) with monthly below ($7.99/month)
  - CTA: "Start 7-day free trial"
  - Below CTA: "Cancel anytime in Play Store"
  - Bottom: tiny "Restore Purchase" link, Terms, Privacy
  - Top right: clear X to close
- **Emotional state:** Considering, possibly skeptical.
- **Primary CTA:** "Start 7-day free trial"
- **Secondary actions:** Switch monthly/annual, restore purchase, close.
- **Must NOT show:** Countdown timers. "Limited time offer" if untrue. Pre-checked add-ons. Confusing pricing tiers (more than 2). "Trick" close buttons. Fake reviews. Stock photos of smiling people.
- **UX notes:** This is the screen that determines whether the app is sustainable. Iterate it relentlessly post-launch using RevenueCat experiments. Never show this screen during or immediately after SOS use.

---

### Screen 11 — Return Loop (the daily re-engagement)

- **Purpose:** Make returning to the app feel rewarding, not nagging.
- **What user sees on return:**
  - Home screen as normal (Screen 5)
  - If first open of the day → small "Today" card highlights and gently pulses once
  - If they had an SOS episode in last 24h → "Yesterday was tough. How are you today?" appears at top of home
  - Streak indicator updates only if they completed a meaningful action
- **Emotional state:** Variable — could be any mood.
- **Primary CTA:** Today's recommended activity.
- **Secondary actions:** Standard nav.
- **Must NOT show:** Modal popups. "You haven't been here in X days" guilt messages. Forced rating prompts. Subscription nags more than once per week.
- **UX notes:** The "loop" is not loud. It's the feeling that returning is welcome and useful.

---

## 5. UX & Emotional Design System

### 5.1 Color philosophy

The app uses **dark, muted, warm-cool tones** because:
- Bright whites cause eye strain during anxiety
- Saturated colors increase arousal (the opposite of what we want)
- Dark backgrounds reduce blue-light impact during nighttime SOS sessions
- Warm undertones (vs. cold blue-grays) feel safer and more human

**Recommended palette:**
- Primary background: `#1A1F2E` (deep navy, warmer than black)
- Secondary surface: `#252B3D`
- Primary text: `#E8E8EC` (off-white, never pure white)
- Secondary text: `#9CA3B5`
- Accent / SOS button: `#E8907A` (muted coral — warm, noticeable, not alarming red)
- Calm accent: `#7BA8B0` (soft teal — for breathing, grounding)
- Warm accent: `#D4B480` (muted gold — for progress, completion)
- Error/danger: `#C26B6B` (muted brick — never alarming red)

Light mode: invert with care. Use cream (`#F5F1EA`) as background, never pure white. Default to system preference but allow override.

### 5.2 Motion & animation

- **Default speed:** Slow. 300–600ms transitions. Anxious users perceive fast motion as urgency.
- **Breathing animation:** 60fps, smooth ease-in-out, never linear.
- **No "spring" or bouncy animations** — they feel playful. Wrong tone.
- **No parallax, no 3D transforms.**
- **Page transitions:** Cross-fade or slide-in, never modal-from-bottom (modals feel trapping).
- **During SOS:** Animations slow down further. The whole app should feel like a deep exhale.

### 5.3 Typography

- **Primary font:** A humanist sans-serif (Inter, Plus Jakarta Sans, or similar). Avoid geometric (too cold) and serif (too literary).
- **Sizes:**
  - SOS instructions: 32–40pt
  - Headers: 24–28pt
  - Body: 17pt (larger than typical 15pt — anxious eyes struggle with small text)
  - Captions: 13pt minimum
- **Weight:** Medium for headers, regular for body. Never thin (illegible).
- **Tone of voice:**
  - Always second person ("you," not "the user")
  - Never clinical jargon ("anxiety attack" not "panic disorder NOS")
  - Never patronizing ("you've got this" — okay; "great job, sweetie" — never)
  - Validating, not coaching ("That sounds really hard" not "Here's how to fix it")
  - Honest about limits ("I'm not a therapist, but I can sit with you")

### 5.4 Sound

- **Default:** Silent. Sound is opt-in.
- **Voice cues** (breathing): One voice, warm female-coded by default, with male-coded option in settings. Recorded human voice for V1, AI-cloned voice acceptable for scale.
- **Ambient sound:** 4 options for V1 — Rain, Ocean, Brown Noise, Forest. Loop seamlessly. No music.
- **No sound effects on UI interactions** ever. No "ding" when you complete something.

### 5.5 Mascot / character

**Recommendation: NO mascot for V1.** Mascots create emotional bonds (Wysa's penguin, Finch's bird) but also create design risk and add 2-3 weeks of work. If pursued in V2, the choice should be:
- Abstract (a glowing orb, a breathing circle that has personality)
- NOT a human face (always feels off)
- NOT a cartoon animal (clashes with the seriousness of crisis use)

### 5.6 Cognitive load reduction during panic

This is the discipline that separates Steady from every other app:

| Principle | Implementation |
|---|---|
| Maximum 4 words per screen during SOS | Strict copy review |
| One decision per screen, max | No "and also..." options |
| Buttons larger than 60×60dp during crisis flows | Shaky hands need big targets |
| No reading required to take next action | Visual cues + obvious flow |
| Always-visible exit | Tiny X but always there |
| No confirmations for safety actions | "Are you sure you want to exit?" is forbidden |
| Default to most-recently-used breathing pattern | Reduce decision fatigue |
| Auto-resume on app reopen if user exited mid-session | Don't lose them |

---

## 6. Tech Stack

### 6.1 Stack decisions (final)

| Layer | Choice | Why |
|---|---|---|
| **Frontend** | Flutter (Dart) | You already know it from NutriQ. Single codebase for Android (and iOS later). Excellent Firebase integration via FlutterFire. Performance is sufficient for animations. |
| **State management** | Riverpod (classic StateNotifier) | You already know it. Predictable. Testable. |
| **Routing** | GoRouter | You already know it. Type-safe. Deep link support. |
| **Backend (BaaS)** | Firebase | Auth + Firestore + Cloud Functions + FCM (push) + Analytics + Crashlytics + Remote Config + Storage all in ONE Google console. This satisfies your "one place" requirement. No need for Supabase + something else for push. |
| **Subscriptions** | RevenueCat SDK + Google Play Billing | Standard. Handles trials, restores, cross-platform later. Free tier covers up to $2.5K/month MTR. |
| **AI (V1.1)** | Anthropic Claude API (Sonnet 4.6 for chat, Haiku for cheap classification) | Best safety guardrails for mental health context. Lower hallucination rate than competitors on sensitive topics. Predictable pricing. |
| **Voice (V1.2 if needed)** | ElevenLabs API or Google TTS | Only if you need scale beyond pre-recorded files |
| **Crash reporting** | Firebase Crashlytics | Free, integrated |
| **Analytics** | Firebase Analytics + a lightweight event layer (PostHog optional later) | Free at this scale |
| **Feature flags** | Firebase Remote Config | Free, native Flutter support, instant rollback for any feature |

### 6.2 Project folder structure (set this up on Day 1)

```
steady/
├── lib/
│   ├── main.dart
│   ├── app.dart                          # MaterialApp + theme + router
│   ├── core/
│   │   ├── config/                       # env, feature flags, constants
│   │   ├── theme/                        # colors, typography, spacing
│   │   ├── services/                     # firebase, revenuecat, llm clients
│   │   ├── models/                       # shared data models
│   │   ├── utils/                        # helpers, formatters
│   │   └── widgets/                      # shared UI components
│   ├── features/
│   │   ├── auth/                         # signup, login, anon migration
│   │   ├── sos/                          # panic mode, breathing, grounding
│   │   ├── daily/                        # check-in, daily flow
│   │   ├── journal/                      # entries, prompts
│   │   ├── progress/                     # tracking, charts
│   │   ├── ai_companion/                 # V1.1 — folder exists, code in V1.1
│   │   ├── sleep/                        # V1.2
│   │   ├── subscription/                 # paywall, RevenueCat integration
│   │   └── settings/                     # profile, preferences, support
│   └── routing/
│       └── app_router.dart
├── assets/
│   ├── audio/                            # breathing voice cues, ambient
│   ├── images/                           # icons, illustrations
│   └── fonts/
├── test/
│   ├── unit/
│   └── widget/
├── android/
├── ios/                                  # leave alone until V2
├── pubspec.yaml
└── firebase.json
```

**Each `features/` folder follows the same internal structure:**
```
features/sos/
├── data/                                 # repos, data sources
├── domain/                               # entities, use cases
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/                        # riverpod providers
└── sos.dart                              # public exports
```

This structure is non-negotiable. **Do not put feature code in `core/`, do not put shared code in `features/`. The discipline of this folder structure is what prevents the code from becoming an unmaintainable mess by V1.2.**

### 6.3 Environment configuration

- Two Firebase projects: `steady-dev` and `steady-prod`
- Two RevenueCat environments: sandbox and production
- Use `--dart-define=ENV=dev` or `ENV=prod` at build time
- **Never** test against production Firebase from your local machine
- Use Firebase emulators for offline development: `firebase emulators:start`

### 6.4 Critical: offline-first design for SOS

The SOS feature, breathing engine, and grounding library MUST work without internet. This means:
- All audio files bundled in `assets/audio/`
- All breathing patterns defined in code, not fetched
- All grounding prompts in local strings
- Episode logs saved to local SQLite (using `drift` or `sqflite`) and synced to Firestore when online
- Auth must support anonymous mode by default

The first sync on user's first online moment is silent and background. Failure to sync does not affect the user experience.

---

## 7. Data Model (Firestore Collections)

```
users/{userId}
  - createdAt: timestamp
  - displayName: string?
  - email: string?
  - isAnonymous: boolean
  - isLifetimePremium: boolean   ← KEY: this is your founder override
  - subscriptionStatus: 'free' | 'trialing' | 'premium' | 'expired'
  - notificationPreferences: { dailyTime: '20:00', enabled: true }
  - onboarding: { completed: bool, anxietyType: string, frequency: string }
  - settings: { breathingPreference: 'box', voiceCues: true, hapticOn: true, theme: 'dark' }

users/{userId}/checkins/{checkinId}
  - timestamp: timestamp
  - mood: 1-5
  - anxietyLevel: 1-10
  - tags: ['work', 'sleep']
  - note: string?

users/{userId}/sessions/{sessionId}
  - timestamp: timestamp
  - type: 'sos' | 'breathing' | 'grounding' | 'sleep'
  - durationSec: int
  - completed: boolean
  - patternUsed: string?
  - exitReason: 'completed' | 'better' | 'same' | 'worse' | 'manual_exit'

users/{userId}/episodes/{episodeId}
  - timestamp: timestamp
  - intensity: 1-10
  - trigger: string?
  - whatHelped: string?
  - linkedSessionId: string?

users/{userId}/journal/{entryId}
  - timestamp: timestamp
  - content: string (encrypted client-side)
  - prompt: string?
  - moodAtWriting: 1-5
  - tags: array<string>

users/{userId}/aiConversations/{conversationId}
  - lastUpdated: timestamp
  - messages: array<{ role, content, timestamp }>
  - summary: string  ← compressed memory for AI context

content/                                  ← read-only, premium content metadata
  cbtLessons/{lessonId}
  sleepStories/{storyId}
  meditations/{meditationId}
```

**Indexes you will need (create in Firestore console):**
- `sessions`: composite on `(userId, timestamp DESC)`
- `episodes`: composite on `(userId, timestamp DESC)`
- `checkins`: composite on `(userId, timestamp DESC)`

**Security rules (high-level):**
- `users/{userId}/**` → only readable/writable by that user
- `content/**` → read-only for all authenticated users; admin-write
- All journal entries client-side encrypted before upload (use a key derived from user's auth token + a salt)

---

## 8. Monetization & Paywall Logic

### 8.1 Pricing (final)

- **Monthly:** $7.99 USD (or local equivalent via Google Play)
- **Annual:** $49.99 USD (Save 48%) — highlighted as default
- **No lifetime plan.**
- **No "founder pricing" promo at launch** — keep simple.
- Localized pricing via Google Play's auto-currency:
  - UK: £6.99 / £39.99
  - Canada: CAD 9.99 / 64.99
  - Australia: AUD 11.99 / 74.99
  - India: ₹199 / ₹999 (deep discount, secondary market)

### 8.2 Free vs Premium feature matrix

| Feature | Free | Premium |
|---|---|---|
| **SOS / Panic Mode** | ✅ Unlimited, forever | ✅ |
| **Box breathing** | ✅ | ✅ |
| **All 4 breathing patterns** | ❌ Only box | ✅ All 4 |
| **5-4-3-2-1 grounding** | ✅ | ✅ |
| **All grounding techniques** | ❌ Only 5-4-3-2-1 | ✅ All 4 |
| **Daily check-in** | ✅ | ✅ |
| **Basic journaling (free write)** | ✅ Up to 30 entries | ✅ Unlimited |
| **CBT-prompted journaling** | ❌ | ✅ |
| **Episode log** | ✅ | ✅ |
| **Basic progress (last 7 days)** | ✅ | ✅ |
| **Long-term progress + insights** | ❌ | ✅ |
| **AI companion (V1.1)** | ❌ 5 messages/month free | ✅ Unlimited (capped at 50/day) |
| **Sleep content (V1.2)** | ❌ One sample story | ✅ Full library |
| **CBT lesson tracks (V1.3)** | ❌ Anxiety 101 free | ✅ All tracks |
| **Notification scheduling** | ✅ | ✅ |
| **Cross-device sync** | ✅ (with account) | ✅ |

**The principle: every crisis tool is permanently free. Every growth tool is premium.** This is non-negotiable. It's both ethical and strategic.

### 8.3 Free trial

- **7-day free trial** with payment method required
- Trial starts when user taps "Start free trial" on paywall
- Day 5: gentle in-app reminder "Your trial ends in 2 days"
- Day 7: trial ends, charge happens automatically per Google Play billing
- Cancellation: user does this in Google Play Store, app respects it immediately

### 8.4 When the paywall appears

**Show paywall when:**
- User taps a premium-only feature for the first time
- User taps "Upgrade" in settings
- User completes 7 days of consistent use (gentle prompt: "Loving Steady? Try premium free for 7 days")

**NEVER show paywall when:**
- During SOS session
- Within 5 minutes after SOS session
- During first launch
- During onboarding
- After a 1-star feedback (if rating system exists)
- More than once per day

### 8.5 What is NEVER behind the paywall

This is the trust moat. Crystal clear list:
- The SOS button itself
- Box breathing
- 5-4-3-2-1 grounding
- Crisis hotline access (if user expresses suicidal ideation, immediate hotline display, no upsell ever)
- Account creation
- Data export
- Account deletion

---

## 9. Founder Testing Strategy (the lifetime override)

### 9.1 The mechanism (one Firestore field, five lines of code)

In every place where the app checks subscription status, the check is:

```dart
bool get hasPremiumAccess =>
    user.subscriptionStatus == 'premium' ||
    user.subscriptionStatus == 'trialing' ||
    user.isLifetimePremium == true;
```

That's it. The `isLifetimePremium` flag in your Firestore user document is the override.

### 9.2 How you grant yourself premium

1. Create your account in the app like a normal user
2. In Firebase Console → Firestore → `users/{yourUserId}` → set `isLifetimePremium: true`
3. Reopen app — all premium features unlocked
4. Test everything in production-like conditions

### 9.3 Beta testers

Same mechanism. Each beta tester signs up normally; you flip their flag in Firestore. Up to 20 beta testers free. Revoke by setting flag to `false`.

### 9.4 Why this beats a debug build flag

| Criterion | Debug build | Lifetime override (chosen) |
|---|---|---|
| Same code as production | ❌ | ✅ |
| Test paywall flow live | ❌ | ✅ (just create a 2nd account) |
| Test on real Play Store install | ❌ | ✅ |
| Easy to grant beta testers | ❌ | ✅ |
| Risk of accidentally shipping unlocked | High | None |
| Setup time | 1 hour | 5 minutes |
| Maintenance | Ongoing | Zero |

### 9.5 Critical guardrail

The `isLifetimePremium` flag must be **writable only by Firebase Admin SDK or your console**, never by the app itself. Firestore rule:

```
match /users/{userId} {
  allow update: if request.auth.uid == userId
    && !('isLifetimePremium' in request.resource.data.diff(resource.data).affectedKeys());
}
```

This ensures no exploited app version can grant itself premium.

---

## 10. Metrics & Success Criteria

### 10.1 Retention targets (90 days post-launch)

| Metric | Industry median | Your minimum target | Your stretch target |
|---|---|---|---|
| **D1 retention** | 20–27% | 30% | 40% |
| **D7 retention** | ~7% | 12% | 18% |
| **D30 retention** | ~3% | 8% | 12% |

The mid-panic positioning means people who download you have a real, urgent need — your D1 retention should outperform the industry median substantially.

### 10.2 Conversion targets (90 days post-launch)

| Metric | Industry median | Your minimum target |
|---|---|---|
| Download → Trial start | 6.2% | 10% |
| Trial → Paid | 35–40% | 45% |
| Download → Paid (overall) | 1.7% | 3% |
| Annual share of new subs | ~60% | 65% |

### 10.3 Engagement metrics

- Sessions per active user per week: target 4+ (this is the daily-habit threshold)
- SOS sessions per panicking user per week: track the trend (declining = success!)
- Journal entries per active user per week: target 1+
- AI conversations per premium user per week (V1.1): target 3+

### 10.4 What defines MVP success (90 days post-launch)

You can call the MVP a success if **two of the three are true**:

1. **Retention:** D7 retention ≥ 12%
2. **Conversion:** Download → Paid ≥ 2%
3. **Quality signal:** Play Store rating ≥ 4.4 stars with 50+ reviews and review themes that include "saved me during a panic attack" or equivalent

If zero or one is true at 90 days → reposition or pivot. Don't keep grinding on a product the market is rejecting.

---

## 11. Build Plan (the 2-week MVP, day-by-day)

> **Honest framing first:** A genuinely useful, polished, production-ready mental health app cannot be built in 2 weeks by a solo non-technical founder. What CAN be built in 2 weeks is a **launchable v1 alpha with the core panic-handling spine**, ready for closed beta testing. AI companion, sleep content, and full CBT tracks come in subsequent 2-week sprints.
>
> The plan below produces a real, testable, launchable MVP. AI and sleep are V1.1/V1.2.

### Sprint 0 — Setup (do this BEFORE Day 1)

Spend half a day on this. It saves you a week later.

- [ ] Create Firebase project: `steady-dev` and `steady-prod`
- [ ] Create RevenueCat account, link both Firebase projects
- [ ] Set up Anthropic API account (don't integrate yet)
- [ ] Create Google Play Console account, complete identity verification (takes 1–14 days, start NOW)
- [ ] Create Flutter project with the folder structure from Section 6.2
- [ ] Set up Git repo (GitHub private)
- [ ] Configure `--dart-define=ENV=dev` build pipeline
- [ ] Add Firebase + RevenueCat + Riverpod + GoRouter dependencies
- [ ] Configure FlutterFire CLI for both environments

### Days 1–3 — Foundation (no user-facing features yet, but the app shell is real)

**Goal:** Have a runnable app with theme, navigation, anonymous auth, and the home screen skeleton.

- Day 1: Theme system (colors, typography, spacing tokens), Material 3 setup with custom theme, splash screen, navigation skeleton (GoRouter with placeholder screens for all 11 screens)
- Day 2: Anonymous Firebase Auth on first launch, user document creation in Firestore, basic auth state Riverpod provider
- Day 3: Home screen layout (Screen 5) with placeholder content, bottom nav, settings screen scaffold, profile screen scaffold

**End of Day 3 deliverable:** App opens, creates anonymous account silently, shows home screen with empty SOS button. Navigation works between all stub screens.

### Days 4–7 — The Crisis Spine (the actual differentiator)

**Goal:** SOS works fully, end-to-end, offline.

- Day 4: SOS active screen (Screen 3) with breathing circle animation. No audio yet, just visual.
- Day 5: Box breathing engine with timing. Breathing pattern data model. Voice cue audio integration (record yourself or use Google TTS for V1).
- Day 6: Add the 60-second and 90-second prompts. Three-button feeling check ("Better/Same/Worse"). Transition to grounding if "Worse".
- Day 7: 5-4-3-2-1 grounding screen. Post-session screen (Screen 7). Episode log (local SQLite + Firestore sync).

**End of Day 7 deliverable:** A user can open the app, tap SOS, complete a guided breathing+grounding session offline, and have it logged. **This alone is more useful than 80% of mental health apps on the market.**

### Days 8–10 — Daily Loop (retention engine)

**Goal:** Build the daily habit features that turn one-time crisis users into recurring users.

- Day 8: Daily check-in screen (Screen 8). Mood + anxiety + tags. Save to Firestore.
- Day 9: Journal screen — free write only. Local SQLite + Firestore sync. Encryption layer for entries.
- Day 10: Basic progress tab — last 7 days mood chart, SOS count, sessions count. Use `fl_chart` package.

**End of Day 10 deliverable:** A user can do daily check-ins, journal, and see their last week visually.

### Days 11–14 — Monetization + Polish + Submit

**Goal:** Real subscription flow, paywall, and Play Store submission.

- Day 11: First-launch decision gate (Screen 2). Onboarding (Screens 4a/b/c). Onboarding writes to user doc.
- Day 12: RevenueCat integration. Paywall screen (Screen 10). Premium feature gating (use the `hasPremiumAccess` getter from Section 9). Restore purchase flow.
- Day 13: Notification system — FCM setup, daily check-in reminder. Settings to change time. Privacy Policy page (host on GitHub Pages — you already know how from VisiCare). Terms page.
- Day 14: Bug fixes from your own testing. Build signed release APK. Generate Play Store assets (screenshots, feature graphic). Submit to Play Console (internal testing track first).

**End of Day 14 deliverable:** App submitted to Play Console internal testing. You and 5–10 beta testers can install via Play Store link.

### What is mocked vs real in 2-week MVP

| System | Status |
|---|---|
| Auth | Real (anonymous + Google sign-in) |
| Database | Real (Firestore) |
| SOS / Breathing / Grounding | Real, fully functional |
| Daily check-in | Real |
| Journal (free write) | Real |
| Progress (basic) | Real |
| Subscription | Real (RevenueCat + Google Play) |
| Notifications | Real (FCM) |
| AI companion | NOT BUILT — UI placeholder shows "Coming soon" |
| Sleep content | NOT BUILT — paywall mentions it as future feature |
| CBT lesson tracks | NOT BUILT — paywall mentions it as future feature |
| Voice cues | Real but use Google TTS or your own recording |
| Premium content (other than future placeholders) | Minimal — premium unlocks 4 breathing patterns + advanced grounding + extended progress + unlimited journaling |

### The post-MVP roadmap (sprints after Day 14)

| Sprint | Dates | Focus | Risk level |
|---|---|---|---|
| **Sprint 2** | Day 15–28 | AI Companion (V1.1) | High — needs careful safety review |
| **Sprint 3** | Day 29–42 | Sleep content (V1.2) — record or generate 5 sleep stories + 4 ambient packs | Medium — content production effort |
| **Sprint 4** | Day 43–56 | CBT lesson tracks (V1.3) — write Anxiety 101, Panic 101 | Medium — writing effort |
| **Sprint 5** | Day 57–70 | iOS launch (V2.0) — port to TestFlight | Medium — Apple review |
| **Sprint 6** | Day 71–84 | Personalization engine v2 — AI-driven daily flow | High |
| **Sprint 7** | Day 85–98 | Marketing + ASO push | Variable |

---

## 12. Risks & Mitigation

### 12.1 AI risk

**Risk:** AI companion gives bad advice, misses suicidal ideation, hallucinates harmful content. Lawsuit material.

**Mitigation:**
- Suicide/self-harm classifier runs on EVERY user message before AI sees it (use Anthropic's content moderation or OpenAI's free moderation endpoint — runs in <100ms)
- If flagged → immediate crisis resource display, no AI response
- System prompt explicitly forbids therapy, medical advice, medication advice
- Hard rate limit: 50 messages/day per user
- Conversation log retained 90 days for safety audit
- Disclaimer at first AI use: "This is supportive AI, not a therapist. If you're in crisis, call 988 (US) or your local equivalent."
- AI is V1.1, not V1.0 — proves core works first, then layer this on with care

### 12.2 Retention risk

**Risk:** D30 retention crashes to industry median (~3%) and you have no business.

**Mitigation:**
- Daily check-in habit is the retention spine — make it a 15-second experience
- Notification timing is user-chosen, not algorithmic
- Don't shame users who skip days
- Ship sleep content (V1.2) early — it's the #1 daily-use driver
- Track cohort retention weekly; if D7 < 10% by week 6, redesign onboarding before scaling acquisition

### 12.3 Monetization risk

**Risk:** Conversion stays below 1%, MRR never reaches sustaining levels.

**Mitigation:**
- Use RevenueCat experiments to test 3+ paywall variants in parallel from week 4 onward
- Track which features drive conversion (instrument every premium-feature tap)
- If conversion is stuck, the issue is usually paywall placement or value perception — not price
- Have a free-trial-extended-by-7-days promo ready for users who hit cancel button
- Don't drop price below $5.99/month — it signals low value in this category

### 12.4 UX failure risk

**Risk:** Users say "doesn't help during actual panic" — the death sentence for this category.

**Mitigation:**
- Beta test SOS with 10+ real anxiety sufferers BEFORE submitting to Play Store
- Use UserTesting.com or recruit via Reddit (r/Anxiety, r/PanicAttack — be transparent about being a founder)
- Watch them use SOS during a calm moment AND ask them to imagine using it during panic
- Specific test: can they reach SOS active state in <5 seconds from cold app launch?
- If even one beta tester says "I would have given up before reaching the breathing" → redesign

### 12.5 Operational risk (solo founder specific)

**Risk:** You burn out, get sick, or get distracted; no one is reviewing crisis-related app feedback.

**Mitigation:**
- Set up automated daily Play Store review monitoring (use a tool like AppFollow's free tier)
- Auto-alerts for any review mentioning "suicide," "self-harm," "didn't help"
- Have a single response template ready for crisis-related reviews (acknowledge + crisis hotline + offer to help)
- Keep customer support to email-only at launch — phone support is impossible solo
- Document everything in a runbook so a temporary helper could cover for you

### 12.6 Privacy / compliance risk

**Risk:** Data breach in a mental health app = brand-killing event.

**Mitigation:**
- Client-side encryption for journal entries and AI conversations
- Firestore security rules audited (no `allow read, write: if true`)
- GDPR-compliant data export and delete from Day 1
- Privacy Policy hosted publicly (GitHub Pages)
- No analytics on sensitive screens (no event tracking inside SOS or journal content)
- Use Firebase App Check to prevent abuse of your backend
- Annual security audit budget: minimum $500/year for automated scanning

---

## 13. Final Product Summary

**Steady** is a mental health app for people who experience panic attacks. It is the first app that reliably stops a panic attack within 90 seconds AND helps the user have fewer of them over time.

The crisis features — SOS button, guided breathing, grounding exercises — are permanently free, work fully offline, and require no account. The paid tier unlocks AI companion conversations, sleep content, full CBT lesson library, and advanced personalization.

The app launches on Google Play in the US, UK, Canada, and Australia simultaneously, targeting women 22–35 who are experiencing panic attacks for the first time or escalating in frequency. iOS launch follows at month 4. Pricing is $7.99/month or $49.99/year with a 7-day free trial.

The technology stack is Flutter + Firebase + RevenueCat + Claude API. Built solo, by one person, with the help of Claude Code. The 2-week MVP delivers the crisis spine + daily habit loop + paywall. Subsequent sprints layer on AI, sleep, and CBT tracks.

Success means: 12% D7 retention, 3% download-to-paid conversion, 4.4-star Play Store rating with reviews mentioning real crisis usefulness within 90 days of launch.

---

## 14. Why Steady Can Win Despite Calm and Headspace

Calm and Headspace are not competitors. They are content libraries that get downloaded by anxious people and disappoint them. Their consumer subscriber numbers have been falling for two consecutive years. Both have pivoted to enterprise. Their app store reviews are dominated by complaints about subscription traps and content fatigue. They are slow-moving, profit-pressured, and structurally incapable of building what panic sufferers actually need — instant crisis intervention combined with genuine longitudinal care.

Rootd is the closest real competitor. It has the best panic button on the market and a loyal user base. Its weakness is depth: once the panic passes, there's not much to do. Steady ships the panic button as table stakes (matching Rootd) and adds everything Rootd lacks — a daily reflection loop, an AI companion that learns the user's specific patterns, sleep content, and structured CBT tracks. The combination doesn't currently exist in any single app.

DARE has unique content but is one person's methodology and feels like a book companion. Wysa was the AI-chatbot leader in 2019; the LLM revolution made it look outdated, and Wysa pivoted to enterprise. Sanvello was the best CBT-tools app and got acquired and shut down for consumers. Woebot was the most clinically validated and sunset its consumer product in June 2025. These shutdowns left thousands of orphaned users who specifically valued tools-and-AI experiences and are actively looking for alternatives.

A solo founder cannot beat Calm at meditation library scale, beat Talkspace at therapist network operations, or beat Wysa at enterprise sales. A solo founder CAN ship a focused, well-designed, technically modern app for one specific user (the woman in Toronto having her first panic attack at 11:47 PM) and serve her dramatically better than any current option. That is a winnable game. The math on retention and conversion suggests it can become a sustainable business at $30K–80K MRR within 18 months, supporting one person fully and funding the next product cycle.

The window is narrow but real. Calm and Headspace will not improve fast — they are enterprise-pivoted and culturally exhausted. Rootd is bootstrapped and small. The big tech companies (Apple, Google, Amazon) have circled mental health for years without committing. The opportunity is to ship something focused, ethical, and differentiated before either an incumbent rebuilds or a well-funded startup enters the space. Twelve to eighteen months from now is when this market gets crowded. The build window is now.

---

## Appendix A — Open questions to resolve before Day 1 of build

1. **Final name confirmation:** Steady vs alternatives. Run trademark search + Play Store search.
2. **Voice for breathing cues:** Record yourself, hire a voice actor (~$300 on Fiverr), or use Google TTS / ElevenLabs?
3. **First brand identity:** Logo + 5 core illustrations. Use Looka / Canva / hire on Fiverr (~$200)?
4. **Privacy Policy + Terms of Service:** Use Termly.io or RocketLawyer (~$30–50) — do not write these yourself.
5. **Crisis hotline list:** Compile US (988), UK (Samaritans 116 123), Canada (988), Australia (Lifeline 13 11 14) — bundle in app.
6. **Beta test recruiting:** Plan to recruit 10 beta testers BEFORE Day 14. Best sources: r/Anxiety, r/PanicAttack (be transparent about being a founder), close friends with anxiety, your existing network.
7. **Founder support setup:** Single email address for support (`hello@steadyapp.io` or similar). Helpdesk tool (Crisp.chat free tier or just Gmail).
8. **App icon design:** Critical for Play Store conversion. Hire a specialist on Fiverr (~$50–100).

---

## Appendix B — What this PRD is NOT

This PRD does not include:
- Marketing strategy (separate doc)
- ASO keyword research (separate exercise)
- Competitive deep dive (already done in market research v1)
- Detailed visual design (Figma file is a separate deliverable)
- Legal documents (use Termly)
- Backend implementation details (Firestore is enough; Cloud Functions only for Cloud Messaging triggers)
- Investor pitch (premature)

If this PRD is properly executed, the app launches on Google Play in 14 days with the crisis spine working, in 6 weeks with AI, in 8 weeks with sleep content, and on iOS at month 4. From there, growth depends on marketing, ASO, and real user feedback — which is its own discipline that this document does not attempt to cover.

---

**End of PRD.**

> **One thing to remember above everything else in this document:** The woman having her first panic attack at 11:47 PM in Toronto is the only user that matters. Every design decision, every line of code, every feature trade-off should be evaluated against one question: *Does this make her experience better, or worse, in that moment?*
>
> If the answer is "worse" or "no impact," cut it.
