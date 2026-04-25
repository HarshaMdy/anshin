// Scene background painters — illustrated nature scenes for section cards and
// hero headers.  All scenes are drawn with Canvas (no external assets), so
// they render crisply at any density and load instantly.
//
// Usage:
//   CustomPaint(painter: ForestScenePainter(), child: ...)
//
// Each painter has a corresponding gradient getter used as the BoxDecoration
// LinearGradient on the card container.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Breathe — soft forest mist ──────────────────────────────────────────────

const List<Color> breatheGradient = [
  Color(0xFF4A9468),
  Color(0xFF2E7050),
];

class ForestScenePainter extends CustomPainter {
  const ForestScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Back hill — lighter sage
    p.color = const Color(0xFF5CAE7C).withValues(alpha: 0.50);
    final back = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.28, h * 0.48, w * 0.58, h * 0.62)
      ..quadraticBezierTo(w * 0.80, h * 0.72, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(back, p);

    // Front hill — deeper green
    p.color = const Color(0xFF3D8A58).withValues(alpha: 0.60);
    final front = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.22, h * 0.64, w * 0.52, h * 0.76)
      ..quadraticBezierTo(w * 0.76, h * 0.86, w, h * 0.70)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(front, p);

    // Mist wisps
    p.color = Colors.white.withValues(alpha: 0.10);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.35, h * 0.80), width: w * 0.65, height: h * 0.16),
      p,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.72, h * 0.84), width: w * 0.48, height: h * 0.12),
      p,
    );

    // Tree silhouettes
    _tree(canvas, w * 0.14, h * 0.60, w * 0.07, h * 0.20);
    _tree(canvas, w * 0.82, h * 0.56, w * 0.06, h * 0.18);
    _tree(canvas, w * 0.52, h * 0.65, w * 0.05, h * 0.14);
  }

  void _tree(Canvas canvas, double cx, double tip, double tw, double th) {
    final p = Paint()
      ..color = const Color(0xFF1F5E35).withValues(alpha: 0.45)
      ..isAntiAlias = true;
    canvas.drawPath(
      Path()
        ..moveTo(cx, tip)
        ..lineTo(cx - tw / 2, tip + th)
        ..lineTo(cx + tw / 2, tip + th)
        ..close(),
      p,
    );
    // Second tier
    p.color = const Color(0xFF1F5E35).withValues(alpha: 0.35);
    canvas.drawPath(
      Path()
        ..moveTo(cx, tip + th * 0.3)
        ..lineTo(cx - tw * 0.65, tip + th * 1.0)
        ..lineTo(cx + tw * 0.65, tip + th * 1.0)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Ground — river stones ────────────────────────────────────────────────────

const List<Color> groundGradient = [
  Color(0xFF3D8FA0),
  Color(0xFF266070),
];

class RiverScenePainter extends CustomPainter {
  const RiverScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Water surface
    p.color = const Color(0xFF4DB8CC).withValues(alpha: 0.40);
    final water = Path()
      ..moveTo(0, h * 0.70)
      ..quadraticBezierTo(w * 0.50, h * 0.60, w, h * 0.68)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(water, p);

    // Water ripple arcs
    p.color = Colors.white.withValues(alpha: 0.15);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.2;
    for (var i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(w * (0.25 + i * 0.28), h * 0.82),
          width: w * 0.22,
          height: h * 0.06,
        ),
        0,
        math.pi,
        false,
        p,
      );
    }
    p.style = PaintingStyle.fill;

    // Stones
    _stone(canvas, w * 0.20, h * 0.76, w * 0.12, h * 0.08);
    _stone(canvas, w * 0.50, h * 0.78, w * 0.16, h * 0.09);
    _stone(canvas, w * 0.78, h * 0.74, w * 0.10, h * 0.07);
    _stone(canvas, w * 0.36, h * 0.85, w * 0.09, h * 0.06);
  }

  void _stone(Canvas canvas, double cx, double cy, double rw, double rh) {
    final p = Paint()
      ..color = const Color(0xFF8A7060).withValues(alpha: 0.65)
      ..isAntiAlias = true;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: rw, height: rh), p);
    // Stone highlight
    p.color = Colors.white.withValues(alpha: 0.18);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - rw * 0.15, cy - rh * 0.22), width: rw * 0.45, height: rh * 0.35),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Journal — rainy day ──────────────────────────────────────────────────────

const List<Color> journalGradient = [
  Color(0xFF5A6E8A),
  Color(0xFF3C4E68),
];

class RainScenePainter extends CustomPainter {
  const RainScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Warm indoor glow
    final glow = RadialGradient(
      colors: [
        const Color(0xFFE8C080).withValues(alpha: 0.22),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCenter(center: Offset(w * 0.50, h * 0.55), width: w * 0.85, height: h * 0.70));
    p.shader = glow;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), p);
    p.shader = null;

    // Ground / street
    p.color = const Color(0xFF3A4A5E).withValues(alpha: 0.55);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.80, w, h * 0.20), p);

    // Rain drops — diagonal thin lines
    p.color = Colors.white.withValues(alpha: 0.18);
    p.strokeWidth = 0.8;
    p.style = PaintingStyle.stroke;
    const rainRows = 5;
    const rainCols = 8;
    for (var r = 0; r < rainRows; r++) {
      for (var c = 0; c < rainCols; c++) {
        final x = w * (c / rainCols) + w * 0.06;
        final y = h * (0.15 + r * 0.14);
        canvas.drawLine(Offset(x, y), Offset(x - 3, y + 8), p);
      }
    }
    p.style = PaintingStyle.fill;

    // Puddle reflection
    p.color = Colors.white.withValues(alpha: 0.08);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.45, h * 0.88), width: w * 0.35, height: h * 0.04),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Learn — open meadow ─────────────────────────────────────────────────────

const List<Color> meadowGradient = [
  Color(0xFF7AAA48),
  Color(0xFF5A8A30),
];

class MeadowScenePainter extends CustomPainter {
  const MeadowScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Sky glow (warm top)
    final skyGlow = RadialGradient(
      center: const Alignment(0.3, -0.6),
      colors: [
        const Color(0xFFFFF0A0).withValues(alpha: 0.28),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    p.shader = skyGlow;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), p);
    p.shader = null;

    // Sun
    p.color = const Color(0xFFFFD060).withValues(alpha: 0.75);
    canvas.drawCircle(Offset(w * 0.80, h * 0.18), w * 0.10, p);
    // Sun glow ring
    p.color = const Color(0xFFFFD060).withValues(alpha: 0.18);
    canvas.drawCircle(Offset(w * 0.80, h * 0.18), w * 0.17, p);

    // Back hill
    p.color = const Color(0xFF8ABB50).withValues(alpha: 0.50);
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.65)
        ..quadraticBezierTo(w * 0.35, h * 0.44, w * 0.68, h * 0.58)
        ..quadraticBezierTo(w * 0.85, h * 0.66, w, h * 0.55)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      p,
    );

    // Front meadow
    p.color = const Color(0xFF6A9A38).withValues(alpha: 0.60);
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.78)
        ..quadraticBezierTo(w * 0.30, h * 0.64, w * 0.60, h * 0.74)
        ..quadraticBezierTo(w * 0.80, h * 0.82, w, h * 0.70)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      p,
    );

    // Wildflower dots
    final flowerColors = [
      Colors.white.withValues(alpha: 0.55),
      const Color(0xFFFFE080).withValues(alpha: 0.60),
      const Color(0xFFF8A0C0).withValues(alpha: 0.50),
    ];
    final rng = math.Random(42);
    for (var i = 0; i < 18; i++) {
      p.color = flowerColors[i % 3];
      canvas.drawCircle(
        Offset(rng.nextDouble() * w, h * 0.68 + rng.nextDouble() * h * 0.28),
        1.6 + rng.nextDouble() * 1.4,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Sleep — moonlit forest ──────────────────────────────────────────────────

const List<Color> sleepGradient = [
  Color(0xFF1A1A4E),
  Color(0xFF0E0E38),
];

class MoonForestScenePainter extends CustomPainter {
  const MoonForestScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Moon glow
    p.color = const Color(0xFFE8E0A0).withValues(alpha: 0.15);
    canvas.drawCircle(Offset(w * 0.75, h * 0.22), w * 0.28, p);

    // Crescent moon
    p.color = const Color(0xFFEEE080).withValues(alpha: 0.90);
    canvas.drawCircle(Offset(w * 0.75, h * 0.22), w * 0.11, p);
    // Bite out of moon for crescent
    p.color = const Color(0xFF18184A);
    canvas.drawCircle(Offset(w * 0.80, h * 0.19), w * 0.085, p);

    // Stars
    final rng = math.Random(7);
    p.color = Colors.white.withValues(alpha: 0.70);
    for (var i = 0; i < 22; i++) {
      final starX = rng.nextDouble() * w;
      final starY = rng.nextDouble() * h * 0.55;
      canvas.drawCircle(Offset(starX, starY), 0.8 + rng.nextDouble() * 0.9, p);
    }

    // Dark tree silhouettes
    p.color = const Color(0xFF0A0A28).withValues(alpha: 0.80);
    _pineTree(canvas, p, w * 0.10, h, w * 0.08, h * 0.45);
    _pineTree(canvas, p, w * 0.28, h, w * 0.07, h * 0.38);
    _pineTree(canvas, p, w * 0.70, h, w * 0.07, h * 0.42);
    _pineTree(canvas, p, w * 0.90, h, w * 0.09, h * 0.50);
    _pineTree(canvas, p, w * 0.50, h, w * 0.06, h * 0.30);
  }

  void _pineTree(Canvas canvas, Paint p, double cx, double base, double tw, double th) {
    canvas.drawPath(
      Path()
        ..moveTo(cx, base - th)
        ..lineTo(cx - tw / 2, base)
        ..lineTo(cx + tw / 2, base)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Visualize — waterfall mist ──────────────────────────────────────────────

const List<Color> visualizeGradient = [
  Color(0xFF6B5B95),
  Color(0xFF4A3A72),
];

class WaterfallScenePainter extends CustomPainter {
  const WaterfallScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Waterfall stream (flowing white curves)
    p.color = Colors.white.withValues(alpha: 0.22);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 6;
    p.strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.50, h * 0.0)
        ..cubicTo(w * 0.44, h * 0.25, w * 0.52, h * 0.50, w * 0.48, h * 0.72),
      p,
    );
    p.strokeWidth = 3;
    p.color = Colors.white.withValues(alpha: 0.14);
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.44, h * 0.0)
        ..cubicTo(w * 0.40, h * 0.28, w * 0.46, h * 0.52, w * 0.42, h * 0.72),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.56, h * 0.0)
        ..cubicTo(w * 0.58, h * 0.26, w * 0.54, h * 0.50, w * 0.56, h * 0.72),
      p,
    );
    p.style = PaintingStyle.fill;

    // Mist pool at base
    p.color = Colors.white.withValues(alpha: 0.14);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.82), width: w * 0.68, height: h * 0.18),
      p,
    );

    // Mist wisps
    p.color = Colors.white.withValues(alpha: 0.09);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.75), width: w * 0.38, height: h * 0.12),
      p,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.72, h * 0.78), width: w * 0.32, height: h * 0.10),
      p,
    );

    // Background cliff shapes
    p.color = const Color(0xFF3A2A5E).withValues(alpha: 0.45);
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.30)
        ..lineTo(w * 0.30, h * 0.0)
        ..lineTo(w * 0.38, h * 0.0)
        ..quadraticBezierTo(w * 0.35, h * 0.45, w * 0.0, h * 0.65)
        ..close(),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w, h * 0.30)
        ..lineTo(w * 0.70, h * 0.0)
        ..lineTo(w * 0.62, h * 0.0)
        ..quadraticBezierTo(w * 0.65, h * 0.45, w, h * 0.65)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Onboarding footer — calm morning forest floor ───────────────────────────

const List<Color> morningForestGradient = [
  Color(0xFFC8DDB0),
  Color(0xFFA0C080),
];

class ForestFloorPainter extends CustomPainter {
  const ForestFloorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..isAntiAlias = true;

    // Ground layer
    p.color = const Color(0xFF88B060).withValues(alpha: 0.55);
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.40)
        ..quadraticBezierTo(w * 0.25, h * 0.18, w * 0.55, h * 0.32)
        ..quadraticBezierTo(w * 0.80, h * 0.44, w, h * 0.28)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      p,
    );

    // Grass blades (simple lines)
    p.color = const Color(0xFF60A040).withValues(alpha: 0.60);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.5;
    p.strokeCap = StrokeCap.round;
    final rng = math.Random(13);
    for (var i = 0; i < 18; i++) {
      final x = rng.nextDouble() * w;
      final y = h * 0.25 + rng.nextDouble() * h * 0.45;
      final lean = (rng.nextDouble() - 0.5) * 8;
      final blade = 6 + rng.nextDouble() * 10;
      canvas.drawLine(Offset(x, y), Offset(x + lean, y - blade), p);
    }
    p.style = PaintingStyle.fill;

    // Small pebbles
    p.color = const Color(0xFF906A50).withValues(alpha: 0.40);
    final rng2 = math.Random(27);
    for (var i = 0; i < 8; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(rng2.nextDouble() * w, h * 0.60 + rng2.nextDouble() * h * 0.35),
          width: 5 + rng2.nextDouble() * 7,
          height: 3 + rng2.nextDouble() * 5,
        ),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Sunrise — post-session warm glow ────────────────────────────────────────

class SunriseGlowPainter extends CustomPainter {
  final Color glowColor;
  const SunriseGlowPainter({required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.55);
    final shader = RadialGradient(
      colors: [
        glowColor.withValues(alpha: 0.30),
        glowColor.withValues(alpha: 0.12),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromCenter(center: center, width: size.width * 1.4, height: size.height * 1.4));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant SunriseGlowPainter old) => old.glowColor != glowColor;
}
