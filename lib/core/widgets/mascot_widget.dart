// MascotWidget — renders the Anshin kawaii mascot SVG with optional
// breathing animation (scale 1.0 → 1.04, 3 s, ease-in-out, repeat-reverse).
//
// Usage:
//   MascotWidget(emotion: MascotEmotion.calm)          // static
//   MascotWidget(emotion: MascotEmotion.calm, breathe: true) // animated
//   MascotWidget(emotion: MascotEmotion.proud, size: 120)
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
}

extension MascotEmotionAsset on MascotEmotion {
  String get assetPath {
    switch (this) {
      case MascotEmotion.calm:        return 'assets/mascot/emotion_calm.svg';
      case MascotEmotion.anxious:     return 'assets/mascot/emotion_anxious.svg';
      case MascotEmotion.panicked:    return 'assets/mascot/emotion_panicked.svg';
      case MascotEmotion.sad:         return 'assets/mascot/emotion_sad.svg';
      case MascotEmotion.tired:       return 'assets/mascot/emotion_tired.svg';
      case MascotEmotion.overwhelmed: return 'assets/mascot/emotion_overwhelmed.svg';
      case MascotEmotion.hopeful:     return 'assets/mascot/emotion_hopeful.svg';
      case MascotEmotion.relieved:    return 'assets/mascot/emotion_relieved.svg';
      case MascotEmotion.grateful:    return 'assets/mascot/emotion_grateful.svg';
      case MascotEmotion.frustrated:  return 'assets/mascot/emotion_frustrated.svg';
      case MascotEmotion.numb:        return 'assets/mascot/emotion_numb.svg';
      case MascotEmotion.proud:       return 'assets/mascot/emotion_proud.svg';
      case MascotEmotion.holdingPen:  return 'assets/mascot/context_holding_pen.svg';
      case MascotEmotion.readingBook: return 'assets/mascot/context_reading_book.svg';
      case MascotEmotion.sleeping:    return 'assets/mascot/context_sleeping.svg';
      case MascotEmotion.breathing:   return 'assets/mascot/context_breathing.svg';
      case MascotEmotion.grounded:    return 'assets/mascot/context_grounded.svg';
      case MascotEmotion.eyesClosed:  return 'assets/mascot/context_eyes_closed.svg';
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
  /// continuously.  When false (default) the SVG is static.
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
    if (widget.breathe) {
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
    );

    if (_anim == null) return svg;

    return AnimatedBuilder(
      animation: _anim!,
      builder: (_, child) => Transform.scale(
        scale: _anim!.value,
        child: child,
      ),
      child: svg,
    );
  }
}
