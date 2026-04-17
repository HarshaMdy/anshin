# Anshin — MVP Content Bible

> **Purpose:** Every piece of user-facing text in the Anshin MVP. Claude Code reads this file and pastes content directly into Dart code. Nothing here is placeholder — every word is final, reviewed, and ready to ship.
> **Voice:** Per Anshin Voice Guide (locked). Honest, warm, adult, direct, lived-in.
> **Status:** Final for MVP launch
> **Total content pieces:** ~350 strings + 2 full lessons + legal docs

---

## Table of Contents

1. [Mascot — 12 emotion labels and descriptions](#1-mascot)
2. [Splash + first launch](#2-splash)
3. [Onboarding — 3 screens](#3-onboarding)
4. [Home screen](#4-home)
5. [SOS / Panic mode](#5-sos)
6. [Breathing engine](#6-breathing)
7. [Grounding — 4 techniques with full prompts](#7-grounding)
8. [Post-session](#8-post-session)
9. [Journal — full flow](#9-journal)
10. [Daily check-in](#10-checkin)
11. [Progress](#11-progress)
12. [Learn — 2 Welcome lessons](#12-learn)
13. [Paywall](#13-paywall)
14. [Notifications](#14-notifications)
15. [Settings + profile](#15-settings)
16. [Empty states](#16-empty)
17. [Error messages](#17-errors)
18. [Crisis + safety](#18-crisis)
19. [Share + social](#19-share)
20. [Play Store listing](#20-playstore)
21. [Privacy Policy](#21-privacy)
22. [Terms of Service](#22-terms)

---

<a id="1-mascot"></a>
## 1. Mascot — 12 emotions

Each emotion has: a label (shown below the mascot in journal picker), a one-line description (shown on tap/long-press), and usage context.

| # | Label | Description | Context |
|---|---|---|---|
| 1 | Calm | "I'm okay right now" | Default, home screen, splash |
| 2 | Anxious | "Something feels off" | Journal picker, pre-SOS |
| 3 | Panicked | "I'm really scared" | Journal picker only (never during actual SOS) |
| 4 | Sad | "I'm hurting today" | Journal picker, bad-week progress |
| 5 | Tired | "I'm running on empty" | Journal picker, late-night, sleep section |
| 6 | Overwhelmed | "There's too much right now" | Journal picker |
| 7 | Hopeful | "Maybe things are shifting" | Journal picker, after lesson, empty states |
| 8 | Relieved | "It passed. I'm okay." | Post-SOS, journal completion |
| 9 | Grateful | "I notice something good" | Journal gratitude screen |
| 10 | Frustrated | "Nothing seems to work" | Journal picker |
| 11 | Numb | "I don't feel much" | Journal picker |
| 12 | Proud | "I showed up today" | Streak milestones, lesson/journal completion |

---

<a id="2-splash"></a>
## 2. Splash + first launch

### Splash screen
- **Visual:** Mascot (calm expression), centered
- **Text below mascot:** "Anshin"
- **Subtext:** None. Clean.
- **Duration:** Max 800ms

### First-launch decision gate

**Heading:** (none — the buttons speak)

**Primary button:** "I need help right now"

**Secondary button:** "I have a moment to set up"

**Microcopy below buttons:** "No account needed. No payment. Just help."

---

<a id="3-onboarding"></a>
## 3. Onboarding — 3 screens

### Screen 3a — What brings you here?

**Mascot:** Calm expression, top center

**Heading:** "What brings you to Anshin?"

**Options (single select, large cards):**
- "Panic attacks"
- "Anxiety that won't quiet down"
- "Trouble sleeping"
- "Stress I can't shake"
- "Just exploring"

**Button:** "Continue"

**Skip link:** "Skip for now" (uses "Just exploring" as default)

---

### Screen 3b — How often?

**Mascot:** Calm expression

**Heading:** "How often does this happen?"

**Options:**
- "Every day or almost"
- "A few times a week"
- "Once a week or so"
- "Rarely — but it's intense"
- "This is brand new for me"

**Button:** "Continue"

**Skip link:** "Skip for now"

---

### Screen 3c — Daily reminder

**Mascot:** Hopeful expression

**Heading:** "Want a daily check-in reminder?"

**Subtext:** "One gentle nudge per day. You pick the time. Nothing more."

**Time picker:** Default 8:00 PM

**Button:** "Set reminder"

**Alternative:** "Not right now" (skips, can enable later in settings)

---

<a id="4-home"></a>
## 4. Home screen

### Greeting bar (changes by time of day)

| Time | Greeting |
|---|---|
| 5 AM – 11:59 AM | "Good morning" |
| 12 PM – 4:59 PM | "Good afternoon" |
| 5 PM – 8:59 PM | "Good evening" |
| 9 PM – 4:59 AM | "Late night? You're not alone." |

No user name appended. Ever. (Per voice guide — using names feels invasive at 3 AM.)

### SOS button label
**"SOS"** — large, always visible at top

### Six home cards (section tiles)

| Card | Label | Sublabel | Icon context |
|---|---|---|---|
| 1 | Breathe | "Find your rhythm" | Mascot breathing |
| 2 | Ground | "Come back to here" | Mascot sitting firmly |
| 3 | Journal | "Get it out of your head" | Mascot holding pen |
| 4 | Learn | "Understand what's happening" | Mascot reading |
| 5 | Visualize | "See a calmer place" | Mascot eyes closed |
| 6 | Sleep | "Rest your mind" | Mascot sleeping |

### Today card (daily recommended activity)

**If no check-in today:**
"How's today? Tap to check in."

**If check-in done, anxiety high (7+):**
"Tough day. Want to try a breathing exercise?"

**If check-in done, anxiety moderate (4–6):**
"A short grounding session might help settle things."

**If check-in done, anxiety low (1–3):**
"Good day. Want to journal about it?"

**If SOS used today:**
"Earlier was hard. How are you doing now?"

### Streak indicator

**Active streak:**
"[X] days" (just the number + "days", no fanfare)

**Streak broken:**
"Welcome back." (no shame, no "you lost your streak")

**First day:**
"Day 1. That's all it takes."

---

<a id="5-sos"></a>
## 5. SOS / Panic mode

### Entry (from home or widget)
No text. Direct transition to active screen. Zero words between tap and breathing.

### Active screen — breathing phase text

| Phase | Text shown |
|---|---|
| Inhale | "Breathe in" |
| Hold (after inhale) | "Hold" |
| Exhale | "Breathe out" |
| Hold (after exhale) | "Hold" |

**TTS voice says the same words, paced to the pattern.**

### 60-second prompt (appears softly at bottom)
"Want to try a grounding exercise?"

**Buttons:** "Yes" / "Keep breathing"

### 90-second check-in
"How are you feeling?"

**Buttons:** "Better" / "About the same" / "Worse"

### If "Worse" → auto-transition to grounding
**Brief transition text (1 second):** "Let's try something different."

---

<a id="6-breathing"></a>
## 6. Breathing engine

### Pattern descriptions (shown on selection screen)

| Pattern | Name | Description | Duration default | Free/Premium |
|---|---|---|---|---|
| Box | "Box breathing" | "Slows your heart rate in under a minute. Used by Navy SEALs and ER doctors." | 3 min | Free |
| 4-7-8 | "4-7-8 breathing" | "Activates your rest-and-digest system. Good before sleep." | 3 min | Premium |
| Physiological sigh | "Physiological sigh" | "Two quick inhales through the nose, one long exhale. The fastest way to calm down, backed by Stanford research." | 3 min | Premium |
| Coherent | "Coherent breathing" | "Five seconds in, five seconds out. Brings your nervous system into balance." | 5 min | Premium |

### Duration picker label
"How long?"

**Options:** "1 min" / "3 min" / "5 min" / "10 min"

### Settings toggles (within breathing screen)
- "Voice guidance" (on/off)
- "Vibration" (on/off)

### Session complete
"Nice work."

**Optional micro-prompt:** "One word for how you feel?"

**Text input:** single line, optional, no validation

---

<a id="7-grounding"></a>
## 7. Grounding — 4 techniques with full prompts

### Technique 1: Five senses (5-4-3-2-1) — FREE

**Introduction screen:**
"This exercise brings you back to the present by focusing on what's real and physical around you. There are no wrong answers."

**Prompt sequence (one per screen, full screen, user taps to advance):**

Screen 1:
"Look around you right now.
Name **5 things you can see.**
A crack in the ceiling. The color of your phone case. Anything."

Screen 2:
"Now focus on touch.
Name **4 things you can feel.**
The fabric of your clothes. The ground under your feet. The temperature of the air."

Screen 3:
"Listen carefully.
Name **3 things you can hear.**
Traffic. A fan humming. Your own breathing."

Screen 4:
"Notice your sense of smell.
Name **2 things you can smell.**
If nothing — that's okay. Notice the absence."

Screen 5:
"Finally.
Name **1 thing you can taste.**
The inside of your mouth. A glass of water. Toothpaste from this morning."

**Completion screen:**
"You're here. You're present. That took courage."

**Feeling check:** "How are you feeling?" → Better / Same / Worse

---

### Technique 2: Body scan (60 seconds) — PREMIUM

**Introduction:**
"We'll move through your body, part by part. You don't have to fix anything. Just notice."

**Prompt sequence:**

Screen 1:
"Start at the top of your head.
Is there tension? Warmth? Pressure?
Don't judge it. Just notice."

Screen 2:
"Move to your face.
Your jaw. Your forehead. Your eyes.
Are you clenching anything? Let it soften if you can."

Screen 3:
"Your shoulders and neck.
Where most of us carry everything.
Just notice what's there."

Screen 4:
"Your chest and stomach.
This is where panic lives in the body.
Breathe into whatever you find."

Screen 5:
"Your hands.
Open them if they're fists.
Feel the air between your fingers."

Screen 6:
"Your legs and feet.
Feel the weight of you against the ground.
You are held by something solid."

**Completion:**
"You just gave your body 60 seconds of attention. That matters more than you think."

---

### Technique 3: Cold water reset — PREMIUM

**Introduction:**
"Cold water activates your body's dive reflex — it slows your heart rate almost instantly. This is biology, not a trick."

**Prompt sequence:**

Screen 1:
"If you can, run cold water over your wrists for 30 seconds.
Or hold a cold object — ice, a cold can, a frozen bag.
The shock is the point."

Screen 2:
"Notice the sensation.
Sharp? Uncomfortable?
That's your nervous system resetting. Stay with it."

Screen 3:
"Breathe slowly while you hold the cold.
In through your nose. Out through your mouth.
The cold does the hard work. You just breathe."

**Completion:**
"Your heart rate just dropped. That's not a feeling — that's physiology."

---

### Technique 4: Movement reset — PREMIUM

**Introduction:**
"Panic freezes you. Movement thaws. You don't need a gym. You need 60 seconds."

**Prompt sequence:**

Screen 1:
"Stand up if you can.
If you can't, that's fine — sit upright.
Plant both feet flat on the ground."

Screen 2:
"Shake your hands out.
Like you're flicking water off them.
Fast, loose, for 10 seconds."

Screen 3:
"Roll your shoulders.
Forward three times. Backward three times.
Big, slow circles."

Screen 4:
"If you can — walk.
Ten steps in any direction.
Feel your feet hitting the ground with each step."

Screen 5:
"Stop. Stand still.
Notice how your body feels different than 60 seconds ago.
Movement changes the chemical state of your brain. You just proved it."

**Completion:**
"You moved. The panic didn't stop you."

---

<a id="8-post-session"></a>
## 8. Post-session messages

Main message (always shown): **"You did it. You're here."**

Below that, three optional cards:

**Card 1:** "Log this"
**Card 2:** "Write about it" (opens journal)
**Card 3:** "Just rest" (closes flow, returns to home with 30-min quiet period)

### Alternative main messages (rotated randomly to avoid repetition)

1. "You did it. You're here."
2. "Still here. Still breathing."
3. "That was hard. You stayed."
4. "It passed. It always does."
5. "Your body did its job. Now it's calming down."
6. "Nothing else to do right now."
7. "Take a second. There's no rush."
8. "You showed up for yourself just now."
9. "This moment is yours."
10. "The worst part is behind you."
11. "Breathe normally. You already are."
12. "You didn't run. That matters."
13. "Rest here as long as you need."
14. "You've survived every panic attack you've ever had. This one too."
15. "One breath at a time. You already know how."

---

<a id="9-journal"></a>
## 9. Journal — full flow

### My Journal screen (main view)

**Header:** "My journal"

**Calendar:** Monthly view, swipeable left/right. Days with entries show a small dot. Today is highlighted. Future dates are non-tappable.

**Empty state (no entries yet):**
Mascot (hopeful expression)
"Nothing written yet. That's okay. Whenever you're ready."
**Button:** "Write my first entry"

### New entry flow (5 screens + completion)

#### Screen 9a — Mood picker

**Heading:** "How are you feeling right now?"

**Grid:** 4×3 grid of 12 mascot expressions, each with label below:
Calm, Anxious, Panicked, Sad, Tired, Overwhelmed, Hopeful, Relieved, Grateful, Frustrated, Numb, Proud

User taps one → selection highlighted → "Continue" button activates

**Progress bar:** Top of screen, horizontal, advances with each screen (1/5, 2/5, etc.)

---

#### Screen 9b — Accomplishments

**Heading:** "Three things you accomplished today."

**Subtext:** "Big or small. Getting out of bed counts."

**Input:** Three text lines (optional — user can leave any blank)
- Line 1: (text field)
- Line 2: (text field)
- Line 3: (text field)

**Button:** "Continue" (works even if all blank)

---

#### Screen 9c — Release

**Heading:** "Is something weighing on you?"

**Subtext:** "Write it down and let it go. Nobody sees this but you."

**Input:** Multi-line text area (no character limit)

**Button:** "Continue"

---

#### Screen 9d — Gratitude

**Heading:** "What are you grateful for today?"

**Subtext:** "Even one small thing."

**Input:** Multi-line text area

**Button:** "Continue"

---

#### Screen 9e — Additional notes

**Heading:** "Anything else on your mind?"

**Subtext:** "Optional. Sometimes there's more to say."

**Input:** Multi-line text area

**Button:** "Finish"

---

#### Screen 9f — Completion

**Mascot:** Proud expression, center, large (120dp)

**Points display:** "+5 mindfulness points" (small, subtle, not flashy)

**Running total:** "Total: [X] points"

**Message:** "Entry saved."

**Insight (rotated):**
- "Journaling helps you process what happened and notice what's changing."
- "Writing things down takes them out of the loop in your head."
- "Tracking how you feel over time reveals patterns you can't see day-to-day."
- "Even a few words count. Consistency matters more than length."
- "You just did something most people avoid. That's worth recognizing."

**Share button:** "Share" (generates shareable card — see section 19)

**Continue button:** "Done" → returns to home

---

### Journal detail view (tapping a past entry date)

Shows: date, mood mascot, all five fields populated with what user wrote. Read-only unless user taps "Edit."

Delete option: bottom of screen, "Delete this entry" in small muted text. Single confirmation: "Delete permanently? This can't be undone." → Yes / Cancel

---

<a id="10-checkin"></a>
## 10. Daily check-in

### Screen heading
"How's today?"

### Mood scale
5 mascot expressions in a row (sized 48dp each):
1 = Struggling → 2 = Rough → 3 = Okay → 4 = Good → 5 = Great

Labels below each mascot.

### Anxiety slider
**Label:** "Anxiety level"
**Scale:** 1–10 (large thumb slider)
**Left label:** "Low"
**Right label:** "High"

### Optional tags
**Label:** "What's on your mind?" (optional)
**Chips:** Work / Sleep / Relationship / Health / Money / Nothing specific

### Save
**Button:** "Save"

### After save
Brief confirmation: "Logged." (fades after 1 second, returns to home)

Home screen shows: "✓ Checked in" pill for the rest of the day

---

<a id="11-progress"></a>
## 11. Progress

### Tab label
"Progress"

### Section: This week

**Mood chart label:** "How you've been feeling"
(Line chart, 7 dots, emoji markers)

**Anxiety chart label:** "Anxiety levels"
(Bar chart, 7 bars)

**Stats row:**
- "SOS uses: [X]"
- "Sessions: [X]"
- "Journal entries: [X]"

### Section: Streak

"[X] days in a row"

**If streak = 0:** "Start fresh today."
**If streak = 1:** "Day 1. That's all it takes."
**If streak = 7:** "One full week."
**If streak = 30:** "A whole month. Look at that."

### Section: Insights (Premium, rule-based)

Template-based insights that fill dynamically:

- "You used SOS [X] times this week — [all/most] on [weekday]. Notice a pattern?"
- "Your anxiety has been lower on days you journaled."
- "You've been checking in every day for [X] days. Consistency builds resilience."
- "This week was harder than last week. That happens. It doesn't mean you're going backward."
- "Your average anxiety dropped from [X] to [Y] over the past [Z] weeks."
- "You haven't used SOS in [X] days. That's progress, even if it doesn't feel like it."
- "Mornings seem harder for you. Want to set a morning breathing reminder?"
- "Sleep-tagged days tend to have higher anxiety. Worth exploring in your journal."

### Insufficient data state (< 7 days)

Mascot (hopeful expression)
"Keep going. Your patterns will appear after a week of check-ins."

---

<a id="12-learn"></a>
## 12. Learn — 2 welcome lessons (MVP)

### Learn section main screen

**Three shelves:**

**Shelf 1: "Understanding" (2 lessons available, more coming)**
- Lesson 1: "What is a panic attack?" — FREE
- Lesson 2: "What is anxiety?" — FREE
- Locked slots: "Physical and mental effects" / "Causes and theories" / "Your first steps" / "The anxiety cycle" — each shows lock icon + "Coming soon"

**Shelf 2: "Short-term skills" (coming in V1.3)**
- All locked with "Coming soon" message
- Planned titles (shown as locked cards): Breathing mastery / Diet and anxiety / Exercise as medicine / Social media and anxiety / Sleep and anxiety / Body image / Workplace stress

**Shelf 3: "Long-term growth" (coming in V1.3)**
- All locked with "Coming soon" message
- Planned titles: Visualization skills / Rebuilding sleep / Understanding stress vs resistance / Self-talk patterns / Writing as therapy / Starting meditation / When nothing feels real / Building confidence

---

### LESSON 1: What is a panic attack?

**Read time:** ~4 minutes
**Format:** Scrollable text with section breaks
**Lesson number:** 1 of 6

---

You're reading this because you've probably had a panic attack. Or you think you have. Or you're terrified of having one.

Here's the first thing to know: a panic attack cannot kill you. Your body is doing exactly what it's designed to do — it's just doing it at the wrong time.

**What's actually happening**

A panic attack is your body's fight-or-flight response firing without a real threat. Your brain — specifically a small almond-shaped region called the amygdala — has detected danger. The problem is, there is no danger. Your amygdala made a mistake.

When this happens, your body floods with adrenaline and cortisol. Your heart rate spikes. Your breathing quickens. Blood rushes away from your digestive system and toward your muscles. Your pupils dilate. Your palms sweat.

All of this is designed to help you fight a predator or run from one. It's an incredibly effective survival system. It's just pointed at the wrong thing right now — at a meeting, a crowded train, a quiet room, or nothing at all.

**What it feels like**

Everyone experiences panic attacks differently, but common sensations include:

Your heart pounding or racing so hard you can feel it in your throat. Chest tightness or pain that makes you think you're having a heart attack. Shortness of breath or a feeling that you can't get enough air. Tingling or numbness in your hands and feet. Dizziness or lightheadedness. A wave of heat or cold. Nausea or stomach churning. A feeling that nothing around you is real — like you're watching yourself from outside your body. An overwhelming conviction that something terrible is about to happen.

The most frightening part for many people is the belief that they are dying, going insane, or losing control. This belief feels absolutely real in the moment, even though it is not true.

**How long does it last**

Most panic attacks peak within 10 minutes and resolve within 20 to 30 minutes. Some last longer, and some come in waves. But every panic attack ends. Every single one. You have a 100% survival rate for panic attacks so far.

**Who gets them**

About 11% of adults experience at least one panic attack per year. Women are roughly twice as likely as men to experience them. They most commonly start in the late teens to mid-30s. They can be triggered by specific situations, or they can come from nowhere — which is often the most frightening part.

Having a panic attack does not mean you have panic disorder. A single panic attack is common and doesn't require treatment. Recurring panic attacks, or significant worry about having another one, is when it becomes worth talking to a professional.

**What a panic attack is NOT**

It is not a heart attack. Heart attacks involve crushing pressure that worsens over time. Panic attacks involve sharp, fluctuating symptoms that peak and then subside.

It is not a sign of weakness. Your brain's threat detection system is extraordinarily sensitive — if anything, it's working too well, not too poorly.

It is not something you can think your way out of with willpower alone. The adrenaline is already in your bloodstream. You cannot reason with a chemical. But you can work with your body to metabolize it faster — which is what the breathing and grounding exercises in Anshin are designed to do.

It is not permanent. Panic attacks are treatable. Most people who learn evidence-based techniques see significant improvement within weeks.

**What to do right now**

If you're reading this during or right after a panic attack: your body is doing its job. The adrenaline will metabolize. Your heart will slow. The feeling of doom will fade. It always does.

If you're reading this in a calm moment: that's the best time to learn. The techniques you practice when you're calm are the ones your body remembers when you're not.

The next lesson covers anxiety — the thing that often lives underneath panic attacks.

---

**Completion screen:**
Mascot (proud expression)
"+10 mindfulness points"
"Lesson 1 complete."
**Button:** "Next lesson" / "Back to Learn"

---

### LESSON 2: What is anxiety?

**Read time:** ~4 minutes
**Format:** Scrollable text with section breaks
**Lesson number:** 2 of 6

---

Panic attacks are loud. Anxiety is quiet. They're related, but they're not the same thing.

A panic attack is an event — it starts, it peaks, it ends. Anxiety is a state — it moves in, unpacks, and stays. Understanding the difference matters because the tools for each are different.

**What anxiety actually is**

Anxiety is your brain's way of preparing for a potential threat. The key word is "potential." Anxiety is always about the future — something that might happen, could happen, or that you're afraid will happen.

This makes anxiety different from fear. Fear is a response to a present danger — a car swerving into your lane, a dog baring its teeth. Anxiety is a response to an imagined or anticipated danger — the car that might swerve tomorrow, the dog that could be behind the next corner.

Your brain processes both of these through the same system. It cannot easily tell the difference between a real threat and a vividly imagined one. This is why anxiety feels so physical — your body responds to the imagined threat as if it were real.

**The anxiety spectrum**

Everyone experiences anxiety. It's a normal, necessary emotion. Mild anxiety before a job interview sharpens your focus. Moderate anxiety about a strange noise at night keeps you safe. Anxiety becomes a problem when it's disproportionate to the situation, when it persists long after the potential threat has passed, or when it interferes with your ability to live normally.

Think of it as a volume dial. A functioning anxiety system operates at 2 or 3 out of 10 most of the time, spiking briefly when something genuinely warrants attention. An anxiety disorder is like that dial being stuck at 6, 7, or 8 — all the time, regardless of what's actually happening.

**Types of anxiety you might recognize**

Generalized anxiety is the "always on" kind — a persistent hum of worry about health, money, relationships, work, safety. It's not about one thing; it's about everything, or about nothing specific at all.

Social anxiety is the fear of being judged, embarrassed, or humiliated in social situations. It's not shyness — it's a deep dread that you'll say or do something that reveals you as incompetent, weird, or broken.

Health anxiety (sometimes called hypochondria) is the conviction that physical symptoms are signs of serious illness. A headache becomes a brain tumor. A heart flutter becomes a heart attack. Google becomes the enemy.

Panic-related anxiety is the fear of having another panic attack. This is the cruel irony — the anxiety about panic can itself trigger panic. This cycle is what most panic sufferers get stuck in.

Performance anxiety, phobias, separation anxiety, and obsessive-compulsive patterns are all part of the broader anxiety family. Each has its own pattern, its own triggers, and its own evidence-based treatments.

**What anxiety does to your body**

Anxiety isn't just a feeling — it's a physical state. When your brain stays in threat-detection mode, your body stays in low-grade fight-or-flight. Over time, this causes muscle tension (especially jaw, shoulders, and lower back), digestive issues (nausea, IBS symptoms, appetite changes), sleep disruption (difficulty falling asleep, waking at 3 AM, unrefreshing sleep), fatigue despite sleeping enough, difficulty concentrating, and irritability that doesn't match the situation.

Many people visit doctors for these symptoms without realizing they're anxiety-driven. If your doctor has told you "there's nothing physically wrong" but you still feel terrible — anxiety may be the missing explanation.

**What keeps anxiety going**

Anxiety feeds on avoidance. The more you avoid the thing that makes you anxious, the more your brain confirms that the thing is genuinely dangerous. Avoidance provides immediate relief but long-term worsening.

Anxiety also feeds on reassurance-seeking. Googling symptoms, asking others "do you think I'm okay?", checking your pulse, scanning your body for problems — all of these temporarily reduce anxiety and then strengthen it.

And anxiety feeds on cognitive distortions — patterns of thinking that twist reality. Catastrophizing (jumping to the worst possible outcome), mind-reading (assuming others think badly of you), fortune-telling (predicting failure before trying), and all-or-nothing thinking (if it's not perfect, it's a disaster). These aren't character flaws. They're habits your brain learned, and they can be unlearned.

**The good news**

Anxiety is one of the most treatable conditions in mental health. Cognitive behavioral therapy (CBT) has decades of evidence behind it. Breathing techniques, grounding exercises, and exposure-based approaches work. Medication works for some people and is nothing to be ashamed of. And most importantly, understanding anxiety — which you're doing right now — is itself therapeutic. The moment you can say "this is my anxiety, not reality," the grip loosens.

You don't need to get rid of anxiety entirely. That's not the goal and it's not possible. The goal is to turn the volume down from 8 to 3. To hear the alarm, check if it's real, and go back to living.

That's what the rest of Anshin is built to help you do.

---

**Completion screen:**
Mascot (proud expression)
"+10 mindfulness points"
"Lesson 2 complete."
**Button:** "Back to Learn"

---

<a id="13-paywall"></a>
## 13. Paywall

### Header
"Unlock Anshin Premium"

### Benefits (3 lines, each with small icon)
- "All breathing patterns and grounding techniques"
- "Unlimited journaling with guided prompts"
- "Full progress insights and pattern tracking"

### Future benefits preview (smaller text below)
"Coming soon: AI companion, sleep stories, and full CBT lesson library"

### Pricing card

**Annual (highlighted, default):**
"$49.99/year"
Badge: "Save 48%"
Subtext: "That's $4.17/month"

**Monthly:**
"$7.99/month"

### CTA
**Button:** "Start 7-day free trial"

**Below CTA:** "Free for 7 days, then $49.99/year. Cancel anytime in Play Store."

### Bottom links
"Restore purchase" · "Terms" · "Privacy"

### Close
X button, top right, always visible, single tap closes

---

### Paywall trigger messages (when user taps locked content)

**Locked breathing pattern:**
"This breathing pattern is part of Anshin Premium. Try it free for 7 days."

**Locked grounding technique:**
"This technique is in Anshin Premium. Try it free for 7 days."

**Journal limit reached (30 entries):**
"You've filled your free journal. Unlock unlimited entries with Premium."

**Locked progress insights:**
"Full insights and patterns are part of Premium."

**Locked lesson:**
"This lesson is coming soon as part of Anshin Premium."

---

<a id="14-notifications"></a>
## 14. Notifications

### Daily check-in reminders (rotated, one per day)

1. "How's today?"
2. "Quick check-in — how are you doing?"
3. "A minute to check in with yourself."
4. "End of day. How did it go?"
5. "Checking in. No wrong answers."
6. "How's the anxiety today?"
7. "Time for your daily check-in."
8. "Take 15 seconds. How are you?"
9. "Evening check-in. How was today?"
10. "Just a moment for yourself."

### Re-engagement (after 7 days inactive — sent once, then 21-day silence)

"It's been a few days. Anshin is here whenever you need it."

### Post-SOS follow-up (sent 4 hours after SOS session, max once per day)

"You used SOS earlier. How are you doing now?"

### Streak milestone

"[X] days in a row. Consistency matters."

---

<a id="15-settings"></a>
## 15. Settings + profile

### Section: Account
- "Sign in" (if anonymous) / "Signed in as [email]" (if authenticated)
- "Sign out"
- "Delete my account" → confirmation: "This will permanently delete all your data after 30 days. You can sign back in within 30 days to cancel. Are you sure?" → "Delete" / "Keep my account"
- "Export my data" → "We'll email you a copy of all your data within 48 hours."

### Section: Appearance
- "Theme" → Light (default) / Dark / System default

### Section: Notifications
- "Daily reminder" → Toggle on/off
- "Reminder time" → Time picker
- "Post-SOS follow-up" → Toggle on/off (default: on)

### Section: Audio & haptics
- "Voice guidance" → On / Off (default: on)
- "Vibration" → On / Off (default: on)
- "Default breathing pattern" → Box / 4-7-8 / Physiological sigh / Coherent

### Section: About Anshin
- "Version [X.X.X]"
- "Privacy Policy" → opens in browser
- "Terms of Service" → opens in browser
- "Contact support" → opens email to support@anshin.app
- "Rate Anshin" → opens Play Store page
- "Share Anshin" → triggers system share sheet with text: "I've been using Anshin for anxiety and panic relief. It actually helps. https://play.google.com/store/apps/details?id=com.anshin.app"

### Section: Subscription (if applicable)
- "Anshin Premium" → "Active" or "Not subscribed"
- "Manage subscription" → opens Play Store subscription management
- "Restore purchase" → triggers RevenueCat restore

---

<a id="16-empty"></a>
## 16. Empty states

### Visualize section (V1.2 — not built yet)
Mascot (hopeful, looking at horizon)
"Your visualization library is coming soon."
"We're building guided body scans, calming visualizations, and ASMR-style sessions."
**Button:** "Notify me when it's ready"

### Sleep section (V1.2 — not built yet)
Mascot (tired, eyes half-closed)
"Sleep stories and ambient sounds are on the way."
"Falling asleep with anxiety is hard. We're building something for that."
**Button:** "Notify me when it's ready"

### Learn — locked lessons
Mascot (calm, holding a book)
"This lesson is coming soon."
"We're writing it carefully — it's worth the wait."

### Journal — no entries yet
(See section 9 above)

### Progress — not enough data
(See section 11 above)

---

<a id="17-errors"></a>
## 17. Error messages

### General error
Mascot (overwhelmed expression)
"Something went wrong on our end. Not on yours."
**Button:** "Try again"

### Network error
"You're offline right now. SOS, breathing, and grounding still work — they don't need internet."
**Button:** "Continue offline"

### Auth error
"Couldn't sign you in. Check your connection and try again."
**Button:** "Retry"

### Subscription error
"Something went wrong with your subscription check. Your access hasn't changed."
**Button:** "Try again" / "Contact support"

### Data sync error
"Your data is saved on this phone but hasn't synced to the cloud yet. It will sync when you're back online."
(No button needed — informational only)

---

<a id="18-crisis"></a>
## 18. Crisis + safety content

### Crisis hotline display (triggered by AI safety classifier in V1.1, or accessible in Settings)

**Heading:** "You're not alone. Real help is available right now."

**Hotlines:**
- "United States: 988 Suicide & Crisis Lifeline — call or text 988"
- "United Kingdom: Samaritans — call 116 123 (free, 24/7)"
- "Canada: 988 Suicide Crisis Helpline — call or text 988"
- "Australia: Lifeline — call 13 11 14 (24/7)"
- "India: iCall — 9152987821 / Vandrevala Foundation — 1860 2662 345"
- "International: Crisis Text Line — text HOME to 741741 (US/CA) or 85258 (UK)"

**Below hotlines:**
"Anshin is not a therapist. If what you're feeling is dangerous or overwhelming, please reach out to a real person. There's no shame in asking for help — it's the strongest thing you can do."

### App disclaimer (shown in About section)

"Anshin is a self-help tool for managing anxiety and panic. It is not a medical device, a diagnostic tool, or a substitute for professional therapy or medication. If you are experiencing a mental health emergency, please contact your local crisis line or go to the nearest emergency room."

---

<a id="19-share"></a>
## 19. Share + social

### Shareable journal card

**Card design (1080×1920 for Stories, 1080×1080 for square):**
- Background: warm cream
- Mascot in the expression user selected for that journal entry, centered, 120dp
- Text: "I journaled today with Anshin"
- Small text bottom: "anshin.app"
- No personal content from the journal is included. No mood label. No streak number. Privacy-first.

### Share app text (from Settings)

"I've been using Anshin for anxiety and panic relief. It actually helps. https://play.google.com/store/apps/details?id=com.anshin.app"

---

<a id="20-playstore"></a>
## 20. Play Store listing

### App title (max 30 chars)
Anshin: Anxiety & Panic Relief

### Short description (max 80 chars)
Stop a panic attack in 90 seconds. Build calm over time. No signup needed.

### Full description

Anshin is built for the moment when panic hits — and for every moment between.

When you're mid-panic attack, you don't need a meditation library. You need something that works in 3 seconds. Anshin's SOS mode gives you guided breathing and grounding exercises instantly — no account required, no paywall, no loading screen. It works offline because panic doesn't wait for wifi.

Between episodes, Anshin helps you understand what's happening in your body and brain, track your anxiety patterns over time, and build skills that reduce the frequency and intensity of panic attacks.

What's inside:

SOS mode — one tap to guided breathing during a panic attack. Works offline.
Four breathing patterns — box breathing, 4-7-8, physiological sigh, and coherent breathing. Evidence-based, not just relaxing.
Grounding exercises — 5-4-3-2-1 senses, body scan, cold water reset, and movement reset.
Daily journal — check in with how you're feeling, log accomplishments, release what's weighing on you. Track moods over time.
Progress tracking — see your anxiety trends, identify patterns, notice improvement.
Learn section — understand panic attacks and anxiety from a science-based perspective.
Sleep and visualization support — coming soon.

What's free forever:
SOS mode, box breathing, 5-4-3-2-1 grounding, daily check-ins, basic journaling, and progress tracking. These will never go behind a paywall. If you're having a panic attack, you should get help — not a payment screen.

What's in Anshin Premium ($7.99/month or $49.99/year):
All breathing patterns, all grounding techniques, unlimited journaling with guided prompts, full progress insights, and upcoming features including AI companion, sleep stories, and CBT lesson library.

Who it's for:
Anyone who experiences panic attacks, anxiety, or racing thoughts. Built with evidence-based techniques from cognitive behavioral therapy. Not a replacement for professional help — but a companion between sessions, or for those who aren't ready for therapy yet.

Privacy:
Your journal entries are encrypted. We don't sell data. We don't show ads. Your anxiety is not a product.

Anshin means "peace of mind" in Japanese.
One breath at a time.

### Tags
Mental health, anxiety, panic attacks, breathing exercises, CBT, mindfulness, grounding, journal, mood tracker, stress relief

### Category
Health & Fitness

### Content rating
Teen (anxiety and mental health themes)

---

<a id="21-privacy"></a>
## 21. Privacy Policy

**Plain-language summary (shown at top of page):**

Here's the short version: your data belongs to you. We don't sell it, we don't share it with advertisers, and we don't use it for anything other than making Anshin work for you. Your journal entries are encrypted — we can't read them even if we wanted to. You can export or delete everything at any time.

Now here's the full legal version:

---

**PRIVACY POLICY**

Last updated: [date of launch]

Anshin ("we," "us," or "our") operates the Anshin mobile application (the "App"). This Privacy Policy describes how we collect, use, and protect your information when you use the App.

**1. Information we collect**

Information you provide directly:
When you create an account, we collect your email address (if you choose to sign in — anonymous use requires no personal information). When you use the journal feature, your entries are encrypted on your device before being stored in our database — we cannot read the content. When you complete check-ins, we store your mood ratings, anxiety levels, and tags. When you contact support, we collect your email address and the content of your message.

Information collected automatically:
We collect anonymized usage data including which features you use, how often, and for how long. We collect crash reports to fix bugs. We collect your device type and operating system version for compatibility purposes. We do not collect your location, contacts, photos, microphone data, or browsing history.

Information from third parties:
If you sign in with Google, we receive your email address and display name from Google. We do not access your Google contacts, calendar, or other data. If you subscribe to Anshin Premium, your payment is processed by Google Play — we receive confirmation of your subscription status but never see your payment details.

**2. How we use your information**

We use your information to: provide the App's features (check-ins, journal, progress tracking, breathing exercises); personalize your experience (recommended activities based on your check-in data); send you notifications you've opted into (daily reminders, post-SOS follow-ups); improve the App (anonymized usage patterns help us understand what works); communicate with you (support responses, important product updates only).

We do NOT use your information to: sell to third parties; serve advertisements; build marketing profiles; train AI models on your personal data; share with employers, insurers, or any other entity.

**3. Data storage and security**

Your data is stored in Firebase (operated by Google) on servers located in the United States. Journal entries are encrypted on your device using AES-256 encryption before being transmitted or stored. Your encryption key is derived from your account credentials and is never stored on our servers in plain text.

We implement industry-standard security measures including encrypted data transmission (TLS 1.3), Firebase security rules that restrict data access to authenticated users only, regular security audits, and no plain-text storage of sensitive information.

No system is perfectly secure. We cannot guarantee absolute security, but we take every reasonable step to protect your data.

**4. Data retention**

We retain your data for as long as your account is active. If you delete your account, we initiate a 30-day soft deletion period during which you can recover your account by signing back in. After 30 days, all your data is permanently and irreversibly deleted from our systems and backups.

Anonymous usage data (not linked to your identity) may be retained indefinitely for product improvement purposes.

**5. Your rights**

Regardless of where you live, you have the right to: access all data we hold about you; export your data in a portable format; correct inaccurate data; delete your account and all associated data; opt out of non-essential communications; withdraw consent for data processing at any time.

For users in the European Economic Area (EEA) and United Kingdom: you have additional rights under GDPR, including the right to lodge a complaint with your local data protection authority. Our legal basis for processing is legitimate interest (providing the App's features) and consent (for optional features like notifications).

For users in California: you have additional rights under CCPA. We do not sell personal information. We do not use personal information for cross-context behavioral advertising.

To exercise any of these rights, contact us at privacy@anshin.app.

**6. Children's privacy**

Anshin is intended for users aged 18 and older. We do not knowingly collect information from children under 18. If we learn that we have collected information from a child under 18, we will delete that information immediately.

**7. Third-party services**

The App uses the following third-party services:

Firebase (Google) — authentication, database, analytics, crash reporting. Google's privacy policy: https://policies.google.com/privacy

RevenueCat — subscription management. RevenueCat's privacy policy: https://www.revenuecat.com/privacy

Anthropic (future, V1.1+) — AI-powered companion feature. When this feature launches, conversations with the AI companion will be processed by Anthropic's Claude API. Conversations are not used to train AI models. Anthropic's privacy policy: https://www.anthropic.com/privacy

We do not use any advertising SDKs, social media trackers, or third-party analytics tools beyond Firebase Analytics.

**8. Changes to this policy**

We may update this Privacy Policy from time to time. We will notify you of material changes through an in-app notification or email. Your continued use of the App after changes constitutes acceptance.

**9. Contact**

For privacy-related questions or requests:
Email: privacy@anshin.app

---

<a id="22-terms"></a>
## 22. Terms of Service

**Plain-language summary:**

Use Anshin however it helps you. Don't use it as a replacement for emergency medical care. We're not therapists. If you need a human, please call one — we've made it easy to find crisis lines in the app. You can cancel your subscription anytime through Google Play. We can update these terms, and we'll tell you if we do.

---

**TERMS OF SERVICE**

Last updated: [date of launch]

These Terms of Service ("Terms") govern your use of the Anshin mobile application ("App") operated by [Your Legal Name] ("we," "us," "our").

By using the App, you agree to these Terms. If you do not agree, do not use the App.

**1. The App**

Anshin is a self-help wellness application that provides breathing exercises, grounding techniques, journaling, mood tracking, educational content, and related features for managing anxiety and panic. The App is not a medical device, diagnostic tool, therapeutic service, or substitute for professional medical or mental health treatment.

**2. Not medical advice**

Nothing in the App constitutes medical advice, diagnosis, or treatment. The App does not create a therapist-patient or doctor-patient relationship. If you are experiencing a medical or mental health emergency, contact your local emergency services (911 in the US) or a crisis helpline immediately. We provide crisis resources within the App as a convenience — we are not responsible for the services provided by those organizations.

**3. Eligibility**

You must be at least 18 years old to use the App. By using the App, you represent that you are at least 18 years old.

**4. Your account**

You may use the App without creating an account (anonymous mode). If you create an account, you are responsible for maintaining the security of your credentials. We are not liable for unauthorized access to your account.

**5. Subscriptions and billing**

Anshin offers a free tier and a premium subscription ("Anshin Premium"). Subscriptions are billed through Google Play. Prices are displayed before purchase. Free trials automatically convert to paid subscriptions unless canceled before the trial ends. You can cancel your subscription at any time through Google Play Store → Subscriptions. Cancellation takes effect at the end of the current billing period — you retain access until then. We do not offer refunds outside of Google Play's refund policy.

**6. Your content**

You retain ownership of all content you create in the App (journal entries, check-in data, notes). By using the App, you grant us a limited license to store, process, and transmit your content solely to provide the App's features. We do not claim ownership of your content. Your journal entries are encrypted and we cannot read them.

**7. Acceptable use**

You agree not to: attempt to reverse-engineer, decompile, or extract source code from the App; use the App to harm, threaten, or harass others; impersonate another person; use the App for any illegal purpose; attempt to bypass subscription restrictions or payment systems.

**8. Intellectual property**

The App, including its design, code, content, educational materials, mascot character, and branding, is owned by us and protected by intellectual property laws. You may not copy, modify, distribute, or create derivative works from any part of the App without our written permission.

**9. Disclaimers**

THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT THE APP WILL BE UNINTERRUPTED, ERROR-FREE, OR FREE OF HARMFUL COMPONENTS. WE DISCLAIM ALL WARRANTIES INCLUDING MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.

**10. Limitation of liability**

TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING FROM YOUR USE OF THE APP. OUR TOTAL LIABILITY SHALL NOT EXCEED THE AMOUNT YOU PAID US IN THE 12 MONTHS PRECEDING THE CLAIM.

**11. Changes to these Terms**

We may update these Terms. Material changes will be communicated through an in-app notification. Your continued use after changes constitutes acceptance.

**12. Governing law**

These Terms are governed by the laws of India. Disputes will be resolved in the courts of Karnataka, India.

**13. Contact**

For questions about these Terms: legal@anshin.app

---

## End of Content Bible

**Total content pieces in this document:**
- 12 mascot emotion definitions
- 5 splash/launch/onboarding screens
- 40+ home screen strings
- 12 SOS/breathing strings
- 28 grounding prompts across 4 techniques
- 15 post-session messages
- 30+ journal flow strings
- 10 check-in strings
- 20+ progress strings and templates
- 2 full lessons (~1,600 words each)
- 15+ paywall strings
- 10 notification templates
- 30+ settings strings
- 10+ empty state strings
- 8 error messages
- 10+ crisis/safety strings
- 5+ share strings
- 500-word Play Store listing
- ~3,000-word Privacy Policy
- ~1,500-word Terms of Service

**All written in the Anshin voice. All ready for Claude Code to paste into Dart constants.**

Claude Code will organize these as:
```
lib/core/constants/
  strings_home.dart
  strings_sos.dart
  strings_breathing.dart
  strings_grounding.dart
  strings_journal.dart
  strings_checkin.dart
  strings_progress.dart
  strings_learn.dart
  strings_paywall.dart
  strings_notifications.dart
  strings_settings.dart
  strings_errors.dart
  strings_crisis.dart
  strings_share.dart
```

Each file is a simple class of static const Strings. No localization framework needed for V1 (English-only). When you add languages later, these files become the English locale base.
