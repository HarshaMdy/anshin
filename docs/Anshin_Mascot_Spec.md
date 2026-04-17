# Anshin — Mascot Spec: The Pebble

> **Purpose:** Define the mascot's personality, visual form, and 12 core expressions so Claude Code can generate consistent SVG illustrations across all screens.
> **Status:** Draft for your review
> **Companion to:** Anshin Voice Guide (locked), Anshin PRD v1

---

## 1. The character concept

**Name:** The pebble has no name. Users will naturally call it "the pebble" or "the Anshin pebble" or just "Anshin." Not naming it is deliberate — it keeps the character universal and avoids the cutesy-mascot trap (Finch's "bird," Wysa's "penguin").

**What it is:** A small, round, smooth river stone with a simple face. Think of a pebble you'd pick up from a riverbed and keep in your pocket because it felt good in your hand. Warm, tactile, grounding — literally and metaphorically.

**Why a pebble:**
- **Grounding:** Pebbles are from the earth. Grounding exercises ask you to feel physical objects. The mascot IS a grounding object.
- **Durability:** Pebbles survive everything. Rivers, storms, time. They don't break. This mirrors the message: "You've survived every panic attack so far."
- **Simplicity:** A pebble has no pretension. It doesn't try to be more than it is. This matches the voice guide: honest, not performative.
- **Warmth:** Smooth river stones feel warm in your hand. The mascot should feel warm on screen.
- **Stillness:** Pebbles don't bounce or dance or wave. They sit. They're present. This is the opposite of the manic energy most app mascots bring.

**What it is NOT:**
- Not a cartoon character with arms and legs (no limbs)
- Not a human face on a rock (uncanny valley)
- Not a gemstone or crystal (no pseudoscience associations)
- Not a pet (users don't "feed" it or "care for" it — that's Finch's territory)
- Not animated constantly (it moves gently, like breathing, but doesn't bounce or spin)

---

## 2. Visual form — the geometry

### Shape
- **Body:** Slightly oval, wider than tall, with a subtle asymmetry (not a perfect circle — perfect circles feel digital, imperfect ones feel natural)
- **Proportions:** Roughly 1:0.85 width-to-height ratio
- **Edges:** Completely smooth, no sharp corners. Subtle organic curves like a real river stone.
- **Size on screen:** Variable by context. In journal mood picker: ~48dp. In post-session hero: ~120dp. In notification: ~24dp. In splash screen: ~200dp.

### Surface
- **Base color:** Warm stone — a soft beige-brown with a hint of warmth. Not gray (too cold), not tan (too sandy). Think `#C4B5A0` as the base, with a subtle gradient from slightly lighter top-left to slightly darker bottom-right (simulates natural light on a 3D stone).
- **Texture:** Smooth. No visible grain or speckle in SVG (too complex for vector). The gradient alone gives it dimensionality.
- **Shadow:** Soft, subtle drop shadow below and slightly right. Makes it feel like it's sitting on the screen surface, not flat.

### Face
- **Eyes:** Two small, slightly oval dots. Positioned in the upper-middle of the body. Slightly closer together than you'd expect (creates a gentle, focused look). Color: warm dark brown `#3D3229`.
- **Mouth:** A single curved line. Position and curve change with expression. Default resting state: very slight upward curve — not smiling, just... present. Color: same warm dark brown.
- **No other features.** No eyebrows (expressions come from eye shape + mouth curve + body posture). No nose. No ears. No blush marks. Simplicity is the entire point.
- **Eye-to-body ratio:** Eyes are small relative to body — roughly 8% of body width each. This avoids the "big anime eyes" look and keeps it feeling like a real stone with minimal features.

### Animation (idle state)
- **Breathing motion:** The pebble gently, almost imperceptibly, scales up 2% and back down on a 4-second cycle. Like it's breathing. This is the ONLY idle animation. It never stops — it's always breathing.
- **No bouncing.** No spinning. No waving. No particle effects.
- **Transition animations:** When moving between expressions (e.g., user picks "anxious" in journal), the face morphs smoothly over 300ms. The body doesn't change shape — only the face changes.

---

## 3. The 12 core expressions

These are the 12 emotional states the pebble can express. Each is used in the Journal mood picker AND throughout the app in contextual moments. Described in terms of **eyes + mouth + body** so Claude Code can generate SVGs.

### Expression 1 — CALM (default / resting state)
- **Eyes:** Normal ovals, centered, looking slightly forward
- **Mouth:** Very slight upward curve. Not a smile — just contentment.
- **Body:** Normal, centered, breathing animation active
- **Used in:** Home screen companion, Settings, default state
- **Feeling it represents:** "I'm okay right now"

### Expression 2 — ANXIOUS
- **Eyes:** Slightly wider than normal, positioned slightly higher (looking up/around)
- **Mouth:** Flat line, no curve. Possibly very slight downward tension at corners.
- **Body:** Normal but breathing animation speeds up subtly (3-second cycle instead of 4)
- **Used in:** Journal mood picker, pre-SOS moments
- **Feeling:** "Something feels wrong but I can't name it"

### Expression 3 — PANICKED
- **Eyes:** Wide, maximum size (but still small relative to body — never cartoonishly big). Positioned slightly apart.
- **Mouth:** Small open circle (the "oh" of fear)
- **Body:** Breathing animation fast (2-second cycle). Slight vibration/shake (1px random offset)
- **Used in:** Journal mood picker. **Never shown during actual SOS mode** (SOS is mascot-free).
- **Feeling:** "I'm terrified"

### Expression 4 — SAD
- **Eyes:** Normal size, positioned slightly lower than usual (looking down)
- **Mouth:** Gentle downward curve
- **Body:** Normal, breathing slightly slower (5-second cycle). Body position shifted slightly lower on screen (as if heavy).
- **Used in:** Journal mood picker, bad-week progress screen
- **Feeling:** "I'm hurting"

### Expression 5 — TIRED
- **Eyes:** Half-closed (top eyelid line visible, cutting across the top of each eye oval). Droopy.
- **Mouth:** Neutral flat line
- **Body:** Slight lean to one side (2-degree tilt). Breathing very slow (6-second cycle).
- **Used in:** Journal mood picker, late-night sessions, sleep section
- **Feeling:** "I'm exhausted"

### Expression 6 — OVERWHELMED
- **Eyes:** Normal size but with tiny curved lines above each eye (the only time we add marks beyond eyes+mouth — these suggest furrowed brow)
- **Mouth:** Wavy line (not straight, not curved — slightly trembling)
- **Body:** Normal
- **Used in:** Journal mood picker
- **Feeling:** "There's too much"

### Expression 7 — HOPEFUL
- **Eyes:** Normal size, positioned slightly higher (looking up gently)
- **Mouth:** Slight upward curve — more than calm, less than happy
- **Body:** Normal, breathing gentle. Positioned slightly higher on screen (as if lighter).
- **Used in:** Journal mood picker, after completing a lesson, streak milestones
- **Feeling:** "Maybe things are getting better"

### Expression 8 — RELIEVED
- **Eyes:** Slightly closed (bottom of eye ovals slightly raised, as if exhaling with relief). Almost like a soft blink.
- **Mouth:** Gentle smile — widest curve in the set
- **Body:** Normal. A single slow "exhale" animation: scales up 4% then back to normal over 2 seconds (one cycle, not repeating).
- **Used in:** Post-SOS session "You did it" screen, journal completion
- **Feeling:** "It passed. I'm okay."

### Expression 9 — GRATEFUL
- **Eyes:** Normal, warm, centered. Slightly smaller than default (a gentle squint of warmth).
- **Mouth:** Soft upward curve
- **Body:** Normal, a very subtle warm glow behind the pebble (soft radial gradient of gold `#D4B48033` at 20% opacity)
- **Used in:** Journal "What are you grateful for" screen, gratitude-themed content
- **Feeling:** "I appreciate this moment"

### Expression 10 — FRUSTRATED
- **Eyes:** Slightly narrowed (top and bottom of eye ovals both slightly compressed). Looking straight ahead.
- **Mouth:** Flat, pressed line — slightly thicker than other expressions
- **Body:** Normal. No special animation.
- **Used in:** Journal mood picker
- **Feeling:** "Nothing is working"

### Expression 11 — NUMB
- **Eyes:** Normal size but with reduced opacity (70% instead of 100%) — the face is fading slightly
- **Mouth:** Perfectly straight flat line. No emotion at all.
- **Body:** Breathing animation nearly imperceptible (8-second cycle, only 1% scale change)
- **Used in:** Journal mood picker
- **Feeling:** "I don't feel anything"

### Expression 12 — PROUD
- **Eyes:** Normal, centered, slight upward gaze
- **Mouth:** Slight smile, slightly wider than calm
- **Body:** Positioned slightly higher on screen. Single subtle bounce: 3% up, settle back, done. Not repeating.
- **Used in:** Streak achievements, lesson completion, bravery points earned, journal completion celebration
- **Feeling:** "I did something meaningful today"

---

## 4. Mascot placement map (updated from earlier discussion)

### Always present (with expression)
| Screen | Expression | Size | Position |
|---|---|---|---|
| Splash screen | Calm | 200dp | Center, with "Anshin" text below |
| Home screen | Calm (or context-aware based on recent activity) | 48dp | Top greeting bar, left of "Good evening" |
| Journal mood picker | All 12 as selectable grid | 48dp each | 4×3 grid with emotion label below each |
| Journal completion | Proud | 120dp | Center hero |
| Post-SOS session | Relieved | 120dp | Center hero |
| Onboarding (3 screens) | Calm → Hopeful → Grateful | 80dp | Top of each screen |
| Streak milestone | Proud | 80dp | Above streak number |
| Shareable journal card | User's selected mood expression | 64dp | Center of card |
| Empty states (Learn, Visualize, Sleep "coming soon") | Hopeful | 80dp | Above "Coming soon" text |
| Error screens | Overwhelmed (not panicked — errors are mild) | 64dp | Above error text |
| Notification icon | Calm (simplified for small size — just the silhouette) | 24dp | Android notification tray |
| App icon (Play Store + home screen) | Calm | 512dp master, scaled | Launcher icon |

### Never present
| Screen | Why |
|---|---|
| SOS active (breathing) | Crisis mode is minimal. Mascot is a distraction. Only the breathing circle exists. |
| Paywall | Commercial moments stay clean and professional. Mascot presence would feel manipulative ("buy premium for me!"). |
| Settings detail pages | Functional screens don't need personality. |
| Privacy Policy / Terms | Legal content stays serious. |

---

## 5. The app icon (= the mascot)

The app icon is the pebble in its Calm expression, centered on the brand background.

### Icon design spec:
- **Background:** Warm cream (`#F8F5F0`) for light-feel (stands out in Play Store grid, which is predominantly blue/dark/gradient)
- **Pebble:** Centered, occupying ~65% of the icon area
- **Face:** Calm expression (gentle eyes, slight smile)
- **Shape:** Rounded square (Android adaptive icon format — the OS applies the mask)
- **No text in the icon.** The pebble IS the brand. No "A" or "Anshin" text — it's too small to read at launcher size.

### Splash screen spec:
- **Background:** Same warm cream
- **Pebble:** Center, 200dp, Calm expression, breathing animation active
- **Text below pebble:** "Anshin" in the app's primary typeface, regular weight, muted brown color
- **Duration:** Max 800ms, then route to home or first-launch gate
- **No tagline on splash.** Clean.

---

## 6. The shareable journal card

When a user completes a journal entry, they can optionally share an image card. This card is what shows up on WhatsApp, Instagram Stories, etc.

### Card spec:
- **Size:** 1080×1920 (Instagram Story format) or 1080×1080 (square, WhatsApp-friendly)
- **Background:** Warm cream with very subtle texture
- **Top:** Pebble in the expression the user selected for their mood, 120dp
- **Middle:** Text: "I just journaled with Anshin" (customizable? V1.1 feature)
- **Bottom:** Small "anshin.app" text + subtle Play Store badge
- **What is NOT on the card:** No personal content from the journal. No mood label. No streak number. Privacy-first — the card says "I journaled" not "I was anxious."

---

## 7. SVG production approach (how Claude Code builds these)

Each expression is a single SVG file. The SVG contains:
- A `<ellipse>` for the body with gradient fill
- A `<filter>` for the drop shadow
- Two `<ellipse>` elements for eyes (shape/position vary by expression)
- A `<path>` for the mouth (curve varies by expression)
- Optional: extra marks (overwhelmed brow lines), glow (grateful)

Total: ~12 SVG files, each under 2KB. Claude Code generates these from the specs above. If any expression looks wrong on screen, you describe the fix ("eyes too big," "mouth too sad") and Claude Code iterates the SVG.

For animated expressions (breathing, shake, bounce), Flutter's `AnimatedContainer` or `TweenAnimationBuilder` handles the motion — the SVG is static, the animation is in Dart code wrapping it.

---

## 8. Your decision

- **"Approved as-is"** → I move to the MVP content bible (the big one).
- **"Approved with changes: [list]"** → I revise, then move.
- **"I want to see an actual SVG first"** → I generate one expression (Calm) as a real SVG so you can see the visual before locking 12.

Recommended: approve the spec now, and when Claude Code generates the first SVG during the build, you'll see it on your phone and can request adjustments then. Words-to-SVG always needs 1-2 iteration rounds on screen.
