# Anshin V1.2 — Visualization & Sleep: Full Feature Specification

> **Document authority:** This document defines the complete specification for the Visualization and Sleep features. Claude Code must read this document alongside the Build Runbook before implementing any V1.2 work.
> **UI/UX standard:** All screens must follow Prompt 1 design system (nature themes, illustrated backgrounds, typography, spacing, color system).
> **Mascot standard:** All mascot usage must follow Prompt 2 specifications.
> **Version:** V1.2 — Sprint 3 (Weeks 5–6 post-MVP launch)
> **Audio source:** All audio files sourced from freesound.org, pixabay.com/music, or mixkit.co (CC0 / free commercial use only). Never YouTube.

---

## PART A — VISUALIZATION

---

## A1. Feature Overview

The Visualization feature offers guided mental imagery sessions to help users calm anxiety, reduce stress, and develop a felt sense of safety. Sessions are text-guided with optional TTS audio playback and optional ambient sound loops.

**Positioning:** "Step away from the noise. Let your mind go somewhere quieter."

**Access:** Premium only (3–4 sessions free, remaining locked)

**V1.2 launch:** 10 sessions
**Future roadmap:** 40–50 sessions

---

## A2. Navigation Placement

Visualization is accessed from the home screen via the Visualize card (already exists as a "coming soon" card). In V1.2, tapping the card routes to the Visualization home screen instead of the empty state.

Route: `/visualize_home` → already exists, needs content.

---

## A3. Visualization Home Screen Design

### Layout

**Hero section (top ~280dp):**
- `visualize_hero.svg` as full-width background (per Prompt 2)
- Mascot in visualize pose (eyes closed, floating, waterfall mist background)
- Screen title "Visualize" overlaid in white, weight 600, 24sp, bottom of hero
- Subtitle: "Guided sessions for a calmer mind" — 14sp, white, 80% opacity

**Filter row (below hero):**
Horizontal scrollable pill filters — All / Short (under 5 min) / Deep (10–15 min) / Sleep / Focus / Body

**Session cards grid:**
- 2-column grid, scrollable
- Each card: 160dp tall, illustrated background, title, duration badge, free/premium tag
- See Section A5 for all 10 session specs

**Free sessions label:**
Above the grid: "3 sessions free to try • Premium unlocks all"

---

## A4. Session Player Screen Design

When user taps a session card, the session player opens as a full-screen experience.

### Layout

**Background:**
Full-screen nature-themed illustrated background matching the session theme. Soft animated elements (very subtle — e.g., slow-drifting particles for forest, slow ripple for water). Uses the same nature scene approach as Prompt 1 home cards but full-screen.

**Top bar:**
- X button (top left) — closes session
- Session title (center) — white, 18sp, weight 600
- Speaker toggle (top right) — enables/disables TTS reading

**Mascot:**
- Centered, 120dp, appropriate expression for the session theme
- Gentle breathing animation (Prompt 2 standard)

**Progress bar:**
- Thin (4dp), white at 40% opacity, below mascot
- Shows progression through the session text
- "Step X of Y" label below progress bar, white, 12sp

**Text content area:**
- Current session text displayed in large, readable text — centered, white, 22sp, weight 400, line height 1.6
- Text fades in smoothly (300ms fade) as each step progresses
- User taps anywhere on screen to advance to next step
- OR: if TTS is on, auto-advances after TTS finishes reading the current step

**Ambient sound:**
- Small ambient sound toggle at bottom: sound wave icon + current sound name
- Tapping it opens a small bottom sheet: list of 4–5 ambient options relevant to this session's theme + "No sound" option
- Default: no sound (user must opt in)

**Navigation:**
- "Next" tap area: anywhere on content area
- "Previous": swipe right OR small back arrow bottom left
- "Finish": appears on last step — coral button "Complete session"

**Completion screen:**
- Mascot in relieved/grateful expression, 140dp
- "Session complete" heading
- "+10 mindfulness points" in muted gold
- Two options: "Back to Visualize" / "Share this moment" (system share)

---

## A5. The 10 Visualization Sessions (V1.2)

All 10 sessions are stored as structured content in Firestore `content/visualize/{sessionId}` collection. Format: array of step objects, each with `text` (string) and `duration_seconds` (int, for TTS timing).

---

### SESSION 1 — Balanced Body Scan
**Free:** Yes
**Duration:** ~5 minutes (8 steps)
**Theme:** Forest morning
**Background:** Soft green forest mist
**Mascot:** calm expression
**Ambient:** Forest birds (default suggestion)
**Description card copy:** "A gentle scan from head to toe. Release what your body is holding."

**Steps:**
1. "Find a comfortable position. You can sit or lie down. Close your eyes if that feels okay."
2. "Take one slow breath in through your nose. Let it out through your mouth. There's nowhere you need to be right now."
3. "Bring your attention to the top of your head. Notice any tension there. You don't need to fix it — just notice it."
4. "Let your awareness move slowly down to your face. Your jaw, your eyes, your forehead. Let them soften just a little."
5. "Now your shoulders and neck. This is where many of us carry stress. Breathe into this area. Let your shoulders drop."
6. "Your chest and belly. Notice the rise and fall of your breath. You are breathing. That is enough."
7. "Your arms, your hands, your fingertips. Let any tension flow down through your fingers and away."
8. "Your legs, your feet, the soles of your feet. You are here. You are supported. Take one more slow breath. When you're ready, gently open your eyes."

---

### SESSION 2 — ASMR Garden Walk
**Free:** Yes
**Duration:** ~7 minutes (10 steps)
**Theme:** Garden path
**Background:** Soft green garden, warm sunlight
**Mascot:** hopeful expression
**Ambient:** Soft rain (default suggestion)
**Description card copy:** "Walk through a quiet garden. No rush. Just the path ahead."

**Steps:**
1. "You are standing at the entrance of a garden. The air is cool and clean. Take a breath and step inside."
2. "The path ahead is made of smooth flat stones. Notice the sound of your footsteps — soft, steady, unhurried."
3. "To your left, tall green hedges. To your right, flowers you recognize but couldn't name. Their colors are gentle — soft yellows, pale blues."
4. "You notice the sound of water somewhere ahead. Not a rush — a quiet trickle, like a small stream finding its way."
5. "The path curves gently. You follow it without thinking. There is nothing to figure out here. Just the path."
6. "You find a wooden bench beneath a tree. The light filters through the leaves in small shifting patches. Sit here for a moment."
7. "Feel the weight of your body on the bench. Feel the solidity beneath you. You are held."
8. "The stream is nearby. You can hear it clearly now — a constant, gentle sound that asks nothing of you."
9. "You stay as long as you like. The garden has no closing time. No one is waiting for you."
10. "When you are ready, take a slow breath. Bring the feeling of this garden back with you. Gently open your eyes."

---

### SESSION 3 — ASMR Beach Walk
**Free:** Yes
**Duration:** ~8 minutes (10 steps)
**Theme:** Ocean beach, dawn
**Background:** Pale blue ocean, soft sand, early light
**Mascot:** relieved expression
**Ambient:** Ocean waves (default suggestion)
**Description card copy:** "Sand beneath your feet. Ocean ahead. Nothing to carry here."

**Steps:**
1. "You are standing at the edge of a beach. The sand is pale and cool beneath your feet. The ocean stretches out in front of you."
2. "It is early — that hour when the light is soft and the world is still. No one else is here. This space is entirely yours."
3. "Take a slow breath. The air tastes of salt and cool water. Let it fill your lungs completely."
4. "Begin to walk slowly toward the water. Each step sinks slightly into the sand. Feel the texture beneath you — uneven, real, grounding."
5. "The sound of the waves grows clearer. They come and go in their own rhythm — not hurried, not lazy. Just constant."
6. "You stop at the water's edge. A small wave reaches your feet. It is cold for just a moment. Then it pulls back."
7. "Watch the ocean breathe in and out. Waves arriving. Waves leaving. Like your own breath, but larger. Much larger than any worry you carried here."
8. "Pick up a small stone from the sand. Feel its weight. Its smoothness. It has been here long before your anxiety, and it will be here long after."
9. "Set the stone down at the water's edge. Watch the next wave take it gently. Whatever you needed to release — you can let the ocean carry it."
10. "Stand here as long as you need. Then take a full breath of sea air. Carry this quiet back with you as you open your eyes."

---

### SESSION 4 — Waterfall Reset
**Free:** No (Premium)
**Duration:** ~6 minutes (8 steps)
**Theme:** Forest waterfall
**Background:** Soft purple-blue waterfall mist
**Mascot:** visualize_hero pose
**Ambient:** Flowing water/waterfall (default)
**Description card copy:** "Let the waterfall wash through you. Come out cleaner."

**Steps:**
1. "You are standing before a waterfall. It is tall and gentle — the water falls in soft sheets, not violent cascades."
2. "The mist from the waterfall touches your face. It is cool and light. With each breath, you inhale clean, water-cooled air."
3. "The sound fills the space completely — a constant rushing that leaves no room for thought. Just sound. Just water."
4. "Imagine stepping into the edge of the waterfall. The water is cool but not cold. It falls over your shoulders, your back, your arms."
5. "Notice where you are carrying tension. Let the water find those places. It moves through them gently, taking nothing by force."
6. "The water clears your head. The noise of the day — the thoughts, the worries — they soften here, washed away or quieted."
7. "Stand in this water as long as you need. There is no hurry. The waterfall has been here for centuries and will continue long after you leave."
8. "Step slowly out of the water. You are lighter. Something has been rinsed from you. Take a slow breath of the mist-cooled air and open your eyes."

---

### SESSION 5 — 5 Senses Grounding Visualization
**Free:** No (Premium)
**Duration:** ~5 minutes (7 steps)
**Theme:** Open meadow
**Background:** Soft meadow, warm light
**Mascot:** grounded/calm expression
**Ambient:** Light wind/grass sounds
**Description card copy:** "Ground yourself through what's real. Five senses, one breath at a time."

**Steps:**
1. "Find stillness. Wherever you are, let your body settle. Breathe in once, slowly. Breathe out fully."
2. "Look around — or imagine looking around. Name 5 things you can see. Say them quietly in your mind. Don't rush."
3. "Now 4 things you can feel physically. The weight of your body. The temperature of the air. The texture of what you're sitting or standing on."
4. "3 things you can hear. Not just obvious sounds — reach for quieter ones. The hum of something distant. Your own breath."
5. "2 things you can smell. If nothing comes immediately, that's fine. Notice the absence of smell — the neutral, clean air."
6. "1 thing you can taste. It might be faint — the lingering trace of something. Or just the neutral presence of your own mouth."
7. "You are here. All five senses confirm it. You are present, not in the past or future. Take one more slow breath and let that be enough."

---

### SESSION 6 — Beautiful Body Scan
**Free:** No (Premium)
**Duration:** ~12 minutes (14 steps)
**Theme:** Warm indoor light, gentle rain outside
**Background:** Warm amber indoor tones, rain on window
**Mascot:** tired/restful expression
**Ambient:** Soft rain
**Description card copy:** "A longer, deeper scan. For when you have time to really arrive."

**Steps:**
1. "Find a comfortable position — lying down if possible. Let your body be fully supported. You don't need to hold yourself up right now."
2. "Take three slow breaths. Breathe in for four counts. Hold for two. Out for six. Repeat this three times."
3. "Starting at the crown of your head. Just notice. Is there tension? Pressure? Warmth? Don't try to change it — just observe."
4. "Your forehead. The space between your eyebrows. Let these muscles go soft. There's nothing to figure out right now."
5. "Your eyes, closed. Behind them, notice any racing or flickering. Just observe. Let the muscles around your eyes release."
6. "Your jaw. This is one of the great holders of stress. Let your teeth part slightly. Let your tongue rest gently."
7. "Your neck and throat. Swallow once, gently. Notice the action. Then let your throat be still and soft."
8. "Your shoulders. Take a slow breath into your chest and let your shoulders rise, then fall completely. Let them be heavy."
9. "Your arms. From the tops of your shoulders to your elbows to your forearms to your wrists to your fingers. One long release."
10. "Your chest. The steady rising and falling of your ribs. You have breathed through everything in your life so far. You are still breathing."
11. "Your belly. Let it be soft. Let it expand fully on each inhale. No holding in. Just the natural movement of your body breathing."
12. "Your hips and lower back. Areas that carry stress quietly, without announcing it. Breathe into this space and let it soften."
13. "Your legs, your knees, your calves, your ankles, your feet, your toes. One long release all the way to the tips of your toes."
14. "Your whole body, now. A complete, supported shape at rest. Stay here as long as you like. When you're ready, take a gentle breath and return."

---

### SESSION 7 — Panic Attack Recovery
**Free:** No (Premium)
**Duration:** ~4 minutes (6 steps)
**Theme:** Sunrise, warmth after difficulty
**Background:** Warm coral-gold sunrise
**Mascot:** relieved expression, post_session.svg pose
**Ambient:** None by default (user just had a panic attack — no audio surprises)
**Description card copy:** "You came through it. This session is for the aftermath."

**Steps:**
1. "That was hard. Whatever just happened — you got through it. You are still here."
2. "Your body is slowly returning to its normal state. The adrenaline is fading. This takes time, and that is completely okay."
3. "Take one slow breath. Not a performance — just one natural, easy breath. Notice your chest rising. Notice it falling."
4. "Your heart may still be beating faster than usual. That is normal. It will slow. Your nervous system is doing exactly what it should be doing to recover."
5. "You did not create this. Panic attacks are not a character flaw. They are a misfiring of a safety system that was trying to protect you."
6. "Rest here for as long as you need. There is nothing you need to do right now. The only task is to let your body recover at its own pace. You are safe."

---

### SESSION 8 — Morning Anxiety Reset
**Free:** No (Premium)
**Duration:** ~5 minutes (7 steps)
**Theme:** Morning forest, mist clearing
**Background:** Soft green-gold morning forest
**Mascot:** hopeful expression
**Ambient:** Forest morning birds
**Description card copy:** "Before the day takes hold. A few minutes just for you."

**Steps:**
1. "It is morning. The day hasn't fully started yet. This moment — before everything else — belongs only to you."
2. "Notice how your body feels right now. Morning anxiety often settles in the chest or stomach. Just notice where yours lives today."
3. "Take a slow breath and imagine the morning light finding you — wherever you are. It asks nothing. It just arrives."
4. "Whatever is waiting today — the meetings, the decisions, the conversations — they are still in the future. They do not exist yet."
5. "Right now, you are here. Breathing. Present. That is the only thing that is real in this moment."
6. "Name one thing — just one — that you can do today that will feel like taking care of yourself. No matter how small."
7. "Carry that one thing with you today. And if the day gets hard, come back to this feeling. You started the day here. That matters. Open your eyes."

---

### SESSION 9 — Deep Calm (Longer Session)
**Free:** No (Premium)
**Duration:** ~15 minutes (18 steps)
**Theme:** Riverside, late afternoon
**Background:** Warm teal river, golden light
**Mascot:** calm expression, ground_hero pose
**Ambient:** River/flowing water
**Description card copy:** "When you have time to go deeper. A long, slow return to quiet."

*(Steps follow the same format — 18 steps of progressive relaxation leading from arriving at a river, sitting, observing, deep body scan, then gently returning. Full scripts generated when session is built.)*

---

### SESSION 10 — Sleep Preparation
**Free:** No (Premium)
**Duration:** ~10 minutes (12 steps)
**Theme:** Night forest, moonlight
**Background:** Deep blue-purple moonlit forest
**Mascot:** tired/sleep expression
**Ambient:** Night forest / soft crickets
**Description card copy:** "Let go of the day. Your body knows how to sleep — this helps remind it."

*(Steps guide user through releasing the day: acknowledging what happened, letting it be done, progressive muscle relaxation, breath slowing, imagining a safe quiet space, drifting toward sleep. Full scripts generated when session is built.)*

---

## A6. Firestore Content Structure

```
content/
  visualize/
    session_1/
      id: "session_1"
      title: "Balanced Body Scan"
      description: "A gentle scan from head to toe."
      duration_minutes: 5
      step_count: 8
      theme: "forest_morning"
      ambient_default: "forest_birds"
      is_free: true
      mascot_expression: "calm"
      background_key: "forest_morning"
      steps: [
        { step: 1, text: "Find a comfortable position...", duration_seconds: 8 },
        { step: 2, text: "Take one slow breath...", duration_seconds: 10 },
        ...
      ]
    session_2/
      ...
```

Claude Code seeds this content into Firestore during V1.2 setup. Content updates do not require app version releases.

---

## PART B — SLEEP

---

## B1. Feature Overview

The Sleep feature provides ambient sound loops to help users wind down, manage pre-sleep anxiety, and maintain sleep. Each audio track runs in a floating overlay-style player that appears above other content, similar in spirit to the SOS screen.

**Positioning:** "Sound to quiet a restless mind. Tonight, you don't have to fight for sleep."

**Access:** Premium only (2 tracks free)

**V1.2 launch:** 15 ambient sound tracks

---

## B2. Navigation Placement

Sleep is accessed from the home screen via the Sleep card (already exists as "coming soon"). In V1.2, tapping the card routes to the Sleep home screen.

Route: `/sleep_home` → already exists, needs content.

---

## B3. Sleep Home Screen Design

### Layout

**Hero section (~280dp):**
- `sleep_hero.svg` as full-width background
- Mascot sleeping on crescent moon, night sky, stars
- Title "Sleep" in white, weight 600, 24sp
- Subtitle: "Ambient sounds for a quieter night" — 14sp, white, 80% opacity

**Section label:**
"Ambient sounds" in 18sp, weight 600, dark text — below hero with 24dp padding

**Free tracks label:**
"2 tracks free • Premium unlocks all" — small, muted text

**Track cards grid:**
- 2-column grid, scrollable
- Each card: 160dp tall, illustrated background matching track theme, title, duration/type badge
- Free badge or lock icon (premium)

---

## B4. The 15 Ambient Sleep Tracks

All audio files sourced from freesound.org, pixabay.com/music, or mixkit.co. CC0 license only. Optimized to 128kbps AAC, seamless loop. Stored in Firebase Storage at `audio/sleep/{trackId}.aac`.

| # | Track name | Theme | Illustration | Free | Source hint |
|---|---|---|---|---|---|
| 1 | All Night Rain | Rain on window | Warm indoor, rain streaks | ✅ Free | freesound.org: "rain window loop" |
| 2 | Forest Night | Night forest ambient | Dark trees, moon | ✅ Free | freesound.org: "forest night crickets" |
| 3 | Ocean Waves | Beach at night | Deep blue ocean, stars | Premium | freesound.org: "ocean waves loop" |
| 4 | River Flow | Flowing river | Teal river, moonlight | Premium | freesound.org: "river stream loop" |
| 5 | Campfire | Crackling fire | Orange fire glow, dark | Premium | freesound.org: "campfire crackling loop" |
| 6 | All Night Fireplace | Indoor fireplace | Warm amber, fireplace | Premium | freesound.org: "fireplace loop" |
| 7 | Forest Birds | Dawn chorus | Green forest, early light | Premium | freesound.org: "birds forest morning" |
| 8 | Brown Noise | Neutral static | Abstract deep purple | Premium | pixabay.com: "brown noise" |
| 9 | Garden Rain | Rain in garden | Green garden, rain | Premium | freesound.org: "garden rain" |
| 10 | Deep Forest | Dense forest, wind | Deep green, fog | Premium | freesound.org: "forest wind ambience" |
| 11 | Mountain Stream | High altitude stream | Blue-grey mountain | Premium | freesound.org: "mountain stream" |
| 12 | Thunderstorm | Distant thunder + rain | Dark sky, lightning far | Premium | freesound.org: "distant thunderstorm" |
| 13 | Waterfall | Waterfall mist | Purple-blue mist | Premium | freesound.org: "waterfall ambient" |
| 14 | Night Wind | Gentle night wind | Stars, moving leaves | Premium | freesound.org: "wind night gentle" |
| 15 | Deep Sleep Tones | Low frequency tones | Abstract deep blue | Premium | pixabay.com: "deep sleep music" |

---

## B5. Sleep Player Screen Design

When a user taps a sleep track card, the player opens as a **full-screen overlay**, matching the SOS screen approach — it floats above everything.

### Layout

**Background:**
Full illustrated night scene matching the track theme. Dark, calming. Soft animated particle elements (stars slowly twinkling for night tracks, rain animation for rain tracks — very subtle, looping SVG animation).

**Top right:** X button — closes player and stops audio

**Center:**
- Mascot in sleeping/restful pose — 140dp
- ZZZ animation floating up from mascot (3 small z shapes, fade in and drift upward, loop)
- Track name below mascot — white, 20sp, weight 600
- "Playing" indicator — small pulsing dot, coral color

**Controls (bottom center):**
- Rewind 10s button (small, left)
- Play/Pause button (large, 64dp, coral, center)
- Timer button (small, right) — opens sleep timer bottom sheet

**Sleep timer (bottom sheet):**
Options: 15 min / 30 min / 45 min / 60 min / Off
When timer selected: small badge appears showing "Stops in X min"
Audio fades out over 30 seconds when timer ends — does not abruptly cut

**Volume:**
System volume controls. No in-app volume slider (keeps UI clean).

**Bottom of screen:**
Track cards for other tracks — horizontal scroll — labeled "More sounds"
User can switch tracks without closing the player.

### Audio behavior
- Audio streams from Firebase Storage — does NOT need to download fully before playing
- Loops seamlessly (audio file is a clean loop)
- Continues playing if user navigates to other parts of the app (background audio)
- Android notification shows "Anshin — [Track Name] playing" with pause button
- Stopping: user taps X, or sleep timer ends, or user taps pause and closes screen

---

## B6. Short Sleep Stories — Recommendation

You asked for suggestions on short sleep stories without a voice actor. Here is the approach I recommend for V1.3 (not V1.2):

**Text-to-speech sleep stories using Google TTS:**
- Write 5–8 short sleep story scripts (600–1,200 words each) — gentle, slow-paced narratives set in calming nature scenes
- Use flutter_tts (already in the app) to read them aloud
- Pair with matching ambient sound at lower volume underneath
- The TTS voice on Android (Google Neural TTS) is significantly more natural than old TTS — acceptable quality for a sleep story at slow speech rate
- Set speech rate to 0.7 (very slow), pitch to 0.9 (slightly lower than default) — this sounds noticeably more soothing

**For V1.2: skip sleep stories, deliver ambient sounds only.** Stories come in V1.3 alongside the full Learn content expansion. This keeps V1.2 scope achievable.

---

## B7. Firebase Storage Architecture

```
Firebase Storage (Spark free tier: 1GB):

audio/
  sleep/
    rain_window.aac        (~8MB for 10-min loop at 128kbps)
    forest_night.aac       (~8MB)
    ocean_waves.aac        (~8MB)
    river_flow.aac         (~8MB)
    campfire.aac           (~8MB)
    fireplace.aac          (~8MB)
    forest_birds.aac       (~8MB)
    brown_noise.aac        (~8MB)
    garden_rain.aac        (~8MB)
    deep_forest.aac        (~8MB)
    mountain_stream.aac    (~8MB)
    thunderstorm.aac       (~8MB)
    waterfall.aac          (~8MB)
    night_wind.aac         (~8MB)
    deep_sleep_tones.aac   (~8MB)

TOTAL: ~120MB for all 15 tracks
Remaining Firebase Storage: ~880MB for future content
```

Audio files are downloaded by the founder from CC0 sources, trimmed to 10-minute seamless loops using Audacity (free), exported as AAC at 128kbps, then uploaded to Firebase Storage manually.

Flutter package for audio streaming: `just_audio` — supports streaming from URL, background playback, Android notifications.

---

## B8. Firestore Content Structure for Sleep

```
content/
  sleep/
    track_1/
      id: "track_1"
      title: "All Night Rain"
      description: "Soft rain on a window. The sound of a world settling."
      theme: "rain_indoor"
      storage_path: "audio/sleep/rain_window.aac"
      duration_minutes: 10
      is_free: true
      mascot_expression: "tired"
      illustration_key: "rain_indoor"
    track_2/
      ...
```

---

## B9. Screens to Build for V1.2

| Screen | Route | Status |
|---|---|---|
| Visualization home | `/visualize_home` | Exists as empty state — replace with content |
| Visualization session player | `/visualize_session` | New screen |
| Session completion | (modal) | New screen |
| Sleep home | `/sleep_home` | Exists as empty state — replace with content |
| Sleep player overlay | `/sleep_player` | New screen (full-screen overlay) |

---

## B10. What NOT to build in V1.2

- No sleep stories (V1.3)
- No download/offline for audio (stream only)
- No custom voice recording
- No ASMR video content
- No social sharing of sleep sessions
- No sleep tracking or wake detection

---

## Summary: Document Set After V1.2

Your `/docs` folder now contains 7 documents:

| # | File | Covers |
|---|---|---|
| 1 | Anshin_Build_Runbook.md | All overrides, task sequence, collaboration rules |
| 2 | Anshin_PRD_v1.md | Core feature definitions, architecture |
| 3 | Anshin_Voice_Guide.md | Tone and copy standards |
| 4 | Anshin_Mascot_Spec.md | Mascot personality, 12 emotions |
| 5 | Anshin_Content_Bible.md | All user-facing strings, lessons, legal |
| 6 | Anshin_V1.1_ChatWithAnna_Spec.md | Anna feature, Claude API, safety, UI |
| 7 | Anshin_V1.2_VisualizeSleep_Spec.md | Visualization sessions, sleep tracks, audio architecture |

**End of V1.2 Specification.**
