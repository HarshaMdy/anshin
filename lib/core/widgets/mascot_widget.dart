// MascotWidget — renders the Anshin kawaii mascot SVG with optional
// breathing animation (scale 1.0 → 1.04, 3 s, ease-in-out, repeat-reverse).
//
// Hero / scene variants (breatheHero, groundHero, journalHero, learnHero,
// visualizeHero, sleepHero, postSession, journalPeeking, checkin1–5) are
// always static — the breathe flag is ignored for them.
//
// Usage:
//   MascotWidget(emotion: MascotEmotion.calm)               // static
//   MascotWidget(emotion: MascotEmotion.calm, breathe: true) // animated
//   MascotWidget(emotion: MascotEmotion.proud, size: 120)
//   MascotWidget(emotion: MascotEmotion.breatheHero, size: 200)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Emotion enum
// ─────────────────────────────────────────────────────────────────────────────

enum MascotEmotion {
  // 12 base emotions (match StringsMascot.allLabels order)
  calm,
  anxious,
  panicked,
  sad,
  tired,
  overwhelmed,
  hopeful,
  relieved,
  grateful,
  frustrated,
  numb,
  proud,

  // 6 contextual variants
  holdingPen,
  readingBook,
  sleeping,
  breathing,
  grounded,
  eyesClosed,

  // 6 hero / scene variants (400×300, always static)
  breatheHero,
  groundHero,
  journalHero,
  learnHero,
  visualizeHero,
  sleepHero,

  // Special-purpose variants
  postSession,
  journalPeeking,

  // Daily check-in mood scale (optimised for 52 dp)
  checkin1,
  checkin2,
  checkin3,
  checkin4,
  checkin5,
}

extension MascotEmotionAsset on MascotEmotion {
  /// True for hero/scene variants that should never animate.
  bool get isHeroScene {
    switch (this) {
      case MascotEmotion.breatheHero:
      case MascotEmotion.groundHero:
      case MascotEmotion.journalHero:
      case MascotEmotion.learnHero:
      case MascotEmotion.visualizeHero:
      case MascotEmotion.sleepHero:
        return true;
      default:
        return false;
    }
  }

  /// Human-readable label used as the TalkBack semantics description.
  String get semanticsLabel {
    switch (this) {
      case MascotEmotion.calm:          return 'Anshin mascot — calm';
      case MascotEmotion.anxious:       return 'Anshin mascot — anxious';
      case MascotEmotion.panicked:      return 'Anshin mascot — panicked';
      case MascotEmotion.sad:           return 'Anshin mascot — sad';
      case MascotEmotion.tired:         return 'Anshin mascot — tired';
      case MascotEmotion.overwhelmed:   return 'Anshin mascot — overwhelmed';
      case MascotEmotion.hopeful:       return 'Anshin mascot — hopeful';
      case MascotEmotion.relieved:      return 'Anshin mascot — relieved';
      case MascotEmotion.grateful:      return 'Anshin mascot — grateful';
      case MascotEmotion.frustrated:    return 'Anshin mascot — frustrated';
      case MascotEmotion.numb:          return 'Anshin mascot — numb';
      case MascotEmotion.proud:         return 'Anshin mascot — proud';
      case MascotEmotion.holdingPen:    return 'Anshin mascot holding a pen';
      case MascotEmotion.readingBook:   return 'Anshin mascot reading a book';
      case MascotEmotion.sleeping:      return 'Anshin mascot sleeping';
      case MascotEmotion.breathing:     return 'Anshin mascot breathing';
      case MascotEmotion.grounded:      return 'Anshin mascot grounded';
      case MascotEmotion.eyesClosed:    return 'Anshin mascot with eyes closed';
      case MascotEmotion.breatheHero:   return 'Breathing exercise illustration';
      case MascotEmotion.groundHero:    return 'Grounding exercise illustration';
      case MascotEmotion.journalHero:   return 'Journaling illustration';
      case MascotEmotion.learnHero:     return 'Learn illustration';
      case MascotEmotion.visualizeHero: return 'Visualisation illustration';
      case MascotEmotion.sleepHero:     return 'Sleep illustration';
      case MascotEmotion.postSession:   return 'Anshin mascot — session complete';
      case MascotEmotion.journalPeeking:return 'Anshin mascot peeking';
      case MascotEmotion.checkin1:      return 'Mood — very low';
      case MascotEmotion.checkin2:      return 'Mood — low';
      case MascotEmotion.checkin3:      return 'Mood — neutral';
      case MascotEmotion.checkin4:      return 'Mood — good';
      case MascotEmotion.checkin5:      return 'Mood — great';
    }
  }

  String get assetPath {
    switch (this) {
      case MascotEmotion.calm:          return 'assets/mascot/emotion_calm.svg';
      case MascotEmotion.anxious:       return 'assets/mascot/emotion_anxious.svg';
      case MascotEmotion.panicked:      return 'assets/mascot/emotion_panicked.svg';
      case MascotEmotion.sad:           return 'assets/mascot/emotion_sad.svg';
      case MascotEmotion.tired:         return 'assets/mascot/emotion_tired.svg';
      case MascotEmotion.overwhelmed:   return 'assets/mascot/emotion_overwhelmed.svg';
      case MascotEmotion.hopeful:       return 'assets/mascot/emotion_hopeful.svg';
      case MascotEmotion.relieved:      return 'assets/mascot/emotion_relieved.svg';
      case MascotEmotion.grateful:      return 'assets/mascot/emotion_grateful.svg';
      case MascotEmotion.frustrated:    return 'assets/mascot/emotion_frustrated.svg';
      case MascotEmotion.numb:          return 'assets/mascot/emotion_numb.svg';
      case MascotEmotion.proud:         return 'assets/mascot/emotion_proud.svg';
      case MascotEmotion.holdingPen:    return 'assets/mascot/context_holding_pen.svg';
      case MascotEmotion.readingBook:   return 'assets/mascot/context_reading_book.svg';
      case MascotEmotion.sleeping:      return 'assets/mascot/context_sleeping.svg';
      case MascotEmotion.breathing:     return 'assets/mascot/context_breathing.svg';
      case MascotEmotion.grounded:      return 'assets/mascot/context_grounded.svg';
      case MascotEmotion.eyesClosed:    return 'assets/mascot/context_eyes_closed.svg';
      case MascotEmotion.breatheHero:   return 'assets/mascot/breathe_hero.svg';
      case MascotEmotion.groundHero:    return 'assets/mascot/ground_hero.svg';
      case MascotEmotion.journalHero:   return 'assets/mascot/journal_hero.svg';
      case MascotEmotion.learnHero:     return 'assets/mascot/learn_hero.svg';
      case MascotEmotion.visualizeHero: return 'assets/mascot/visualize_hero.svg';
      case MascotEmotion.sleepHero:     return 'assets/mascot/sleep_hero.svg';
      case MascotEmotion.postSession:   return 'assets/mascot/post_session.svg';
      case MascotEmotion.journalPeeking:return 'assets/mascot/journal_peeking.svg';
      case MascotEmotion.checkin1:      return 'assets/mascot/checkin_1.svg';
      case MascotEmotion.checkin2:      return 'assets/mascot/checkin_2.svg';
      case MascotEmotion.checkin3:      return 'assets/mascot/checkin_3.svg';
      case MascotEmotion.checkin4:      return 'assets/mascot/checkin_4.svg';
      case MascotEmotion.checkin5:      return 'assets/mascot/checkin_5.svg';
    }
  }

  /// Maps the 12 journal-picker labels (from StringsMascot.allLabels) to an
  /// emotion enum.  Returns [calm] for unrecognised strings.
  static MascotEmotion fromLabel(String label) {
    switch (label) {
      case 'Calm':        return MascotEmotion.calm;
      case 'Anxious':     return MascotEmotion.anxious;
      case 'Panicked':    return MascotEmotion.panicked;
      case 'Sad':         return MascotEmotion.sad;
      case 'Tired':       return MascotEmotion.tired;
      case 'Overwhelmed': return MascotEmotion.overwhelmed;
      case 'Hopeful':     return MascotEmotion.hopeful;
      case 'Relieved':    return MascotEmotion.relieved;
      case 'Grateful':    return MascotEmotion.grateful;
      case 'Frustrated':  return MascotEmotion.frustrated;
      case 'Numb':        return MascotEmotion.numb;
      case 'Proud':       return MascotEmotion.proud;
      default:            return MascotEmotion.calm;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

class MascotWidget extends StatefulWidget {
  final MascotEmotion emotion;

  /// Width / height of the rendered SVG (it is always square).
  final double size;

  /// When true the widget owns its own AnimationController and breathes
  /// continuously.  Ignored for hero/scene variants (they are always static).
  final bool breathe;

  const MascotWidget({
    super.key,
    required this.emotion,
    this.size = 100,
    this.breathe = false,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;
  Animation<double>? _anim;

  @override
  void initState() {
    super.initState();
    // Hero/scene variants are never animated.
    if (widget.breathe && !widget.emotion.isHeroScene) {
      _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3000),
      )..repeat(reverse: true);
      _anim = Tween<double>(begin: 1.0, end: 1.04).animate(
        CurvedAnimation(parent: _ctrl!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      widget.emotion.assetPath,
      width: widget.size,
      height: widget.size,
      semanticsLabel: widget.emotion.semanticsLabel,
    );

    if (_anim == null) return svg;

    return AnimatedBuilder(
      animation: _anim!,
      builder: (context, child) => Transform.scale(
        scale: _anim!.value,
        child: child,
      ),
      child: svg,
    );
  }
}
