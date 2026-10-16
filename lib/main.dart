import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const GlowHockeyApp());

const Color bg = Color(0xFF070B18);
const Color cyan = Color(0xFF37F6FF);
const Color pink = Color(0xFFFF3DCE);
const Color gold = Color(0xFFFFD166);

class GlowHockeyApp extends StatelessWidget {
  const GlowHockeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow Hockey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: cyan, brightness: Brightness.dark),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

enum PlayMode { ai, local }
enum Difficulty { easy, medium, hard }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Difficulty difficulty = Difficulty.hard; // Default to hard to showcase the upgrade

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.35), radius: 1.2,
            colors: [Color(0xFF152346), bg],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 112, height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cyan.withOpacity(.08),
                        border: Border.all(color: cyan, width: 2),
                        boxShadow: [BoxShadow(color: cyan.withOpacity(.35), blurRadius: 32)],
                      ),
                      child: const Icon(Icons.sports_hockey, color: cyan, size: 64),
                    ),
                    const SizedBox(height: 24),
                    const Text('GLOW HOCKEY', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900,
                        letterSpacing: 3, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('NEON ARENA  •  1 VS 1 PRO', style: TextStyle(
                      color: cyan, letterSpacing: 2, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 34),
                    const Align(alignment: Alignment.centerLeft, child: Text(
                      'AI DIFFICULTY', style: TextStyle(color: Colors.white70,
                      fontSize: 12, letterSpacing: 1.8, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 12),
                    Row(
                      children: Difficulty.values.map((d) {
                        final selected = d == difficulty;
                        return Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => setState(() => difficulty = d),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selected ? cyan.withOpacity(.13) : Colors.white.withOpacity(.035),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: selected ? cyan : Colors.white24),
                                boxShadow: selected ? [BoxShadow(color: cyan.withOpacity(.12), blurRadius: 18)] : [],
                              ),
                              child: Column(children: [
                                Icon(d == Difficulty.easy ? Icons.sentiment_satisfied_alt :
                                  d == Difficulty.medium ? Icons.bolt : Icons.local_fire_department,
                                  color: selected ? cyan : Colors.white54),
                                const SizedBox(height: 7),
                                Text(d.name.toUpperCase(), style: TextStyle(
                                  color: selected ? Colors.white : Colors.white60,
                                  fontWeight: FontWeight.bold, fontSize: 11)),
                              ]),
                            ),
                          ),
                        ));
                      }).toList(),
                    ),
                    const SizedBox(height: 26),
                    _MenuButton(label: 'PLAY VS AI', detail: 'Challenge the Pro ML Policy Bot',
                      icon: Icons.smart_toy_outlined, color: cyan,
                      onTap: () => _start(context, PlayMode.ai)),
                    const SizedBox(height: 12),
                    _MenuButton(label: 'LOCAL 2 PLAYERS', detail: 'Challenge a friend on one device',
                      icon: Icons.people_alt_outlined, color: pink,
                      onTap: () => _start(context, PlayMode.local)),
                    const SizedBox(height: 22),
                    const Text('FIRST TO 7 GOALS  •  DRAG TO MOVE  •  NO ADS',
                      textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.white38, fontSize: 10, letterSpacing: 1.1)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _start(BuildContext context, PlayMode mode) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GameScreen(mode: mode, difficulty: difficulty)));
  }
}

class _MenuButton extends StatelessWidget {
  final String label, detail;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MenuButton({required this.label, required this.detail, required this.icon,
    required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(18), onTap: onTap,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(.045),
          border: Border.all(color: color.withOpacity(.65)),
          boxShadow: [BoxShadow(color: color.withOpacity(.08), blurRadius: 20)],
        ),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(
            color: color.withOpacity(.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 26)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
            const SizedBox(height: 4),
            Text(detail, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ])),
          Icon(Icons.arrow_forward_ios, color: color, size: 16),
        ]),
      ),
    ),
  );
}

class Puck {
  Offset p = const Offset(.5, .5);
  Offset v = Offset.zero;
  double r = .022;
}

class Paddle {
  Offset p;
  Offset target;
  final int team;
  Paddle(this.p, this.team) : target = p;
}

class GameScreen extends StatefulWidget {
  final PlayMode mode;
  final Difficulty difficulty;
  const GameScreen({super.key, required this.mode, required this.difficulty});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late final TickerController _ticker;
  final Puck puck = Puck();
  late List<Paddle> paddles;
  int cyanScore = 0, pinkScore = 0;
  bool paused = false, ended = false;
  String banner = 'FACE OFF!';
  double bannerTime = 1.6;
  Size arena = Size.zero;
  final math.Random random = math.Random();
  final List<_Spark> sparks = [];

  double get aiSpeed => switch (widget.difficulty) {
    Difficulty.easy => .40,
    Difficulty.medium => .85,
    Difficulty.hard => 2.80, // Extremely fast neural tracking speed
  };

  @override
  void initState() {
    super.initState();
    _resetPositions();
    _ticker = TickerController(onTick: _step)..start();
  }

  void _resetPositions() {
    paddles = [
      Paddle(const Offset(.20, .50), 0),
      Paddle(const Offset(.80, .50), 1),
    ];
    puck.p = const Offset(.5, .5);
    puck.v = Offset((random.nextBool() ? 1 : -1) * .38, (random.nextDouble() - .5) * .28);
  }

  @override
  void dispose() { _ticker.dispose(); super.dispose(); }

  void _step(double dt) {
    if (!mounted || paused || ended || arena == Size.zero) return;
    dt = dt.clamp(0.0, .032);
    if (bannerTime > 0) bannerTime -= dt;

    final bounds = _bounds();
    for (int i = 0; i < paddles.length; i++) {
      final paddle = paddles[i];
      final isHuman = widget.mode == PlayMode.local || paddle.team == 0;
      
      if (!isHuman) {
        _moveAI(paddle, dt);
      }
      
      final maxMove = (isHuman ? 2.2 : aiSpeed) * dt;
      final delta = paddle.target - paddle.p;
      final dist = delta.distance;
      if (dist > 0) {
        paddle.p += delta * (math.min(1.0, maxMove / dist));
      }
      
      final minX = paddle.team == 0 ? bounds.left + .05 : .52;
      final maxX = paddle.team == 0 ? .48 : bounds.right - .05;
      paddle.p = Offset(
        paddle.p.dx.clamp(minX, maxX), 
        paddle.p.dy.clamp(bounds.top + .06, bounds.bottom - .06)
      );
    }

    puck.p += puck.v * dt;
    puck.v = puck.v * math.pow(.996, dt * 60).toDouble();

    final minY = bounds.top + puck.r, maxY = bounds.bottom - puck.r;
    if (puck.p.dy < minY) { 
      puck.p = Offset(puck.p.dx, minY); 
      puck.v = Offset(puck.v.dx, puck.v.dy.abs()); 
      _burst(puck.p, cyan); 
    }
    if (puck.p.dy > maxY) { 
      puck.p = Offset(puck.p.dx, maxY); 
      puck.v = Offset(puck.v.dx, -puck.v.dy.abs()); 
      _burst(puck.p, pink); 
    }

    final goalTop = .41, goalBottom = .59;
    if (puck.p.dx < bounds.left) {
      if (puck.p.dy > goalTop && puck.p.dy < goalBottom) { _score(1); return; }
      puck.p = Offset(bounds.left, puck.p.dy); 
      puck.v = Offset(puck.v.dx.abs(), puck.v.dy);
    }
    if (puck.p.dx > bounds.right) {
      if (puck.p.dy > goalTop && puck.p.dy < goalBottom) { _score(0); return; }
      puck.p = Offset(bounds.right, puck.p.dy); 
      puck.v = Offset(-puck.v.dx.abs(), puck.v.dy);
    }

    for (final paddle in paddles) {
      final diff = puck.p - paddle.p;
      final distance = diff.distance;
      const combinedRadius = .065;
      if (distance < combinedRadius && distance > 0) {
        final normal = diff / distance;
        
        // Apply Pro ML smash factor for Hard difficulty
        double speedMultiplier = 1.15;
        double goalSteeringY = 0.0;
        
        if (paddle.team == 1 && widget.difficulty == Difficulty.hard) {
          speedMultiplier = 1.45; // Aggressive power smash
          // Direct puck towards upper or lower corners of player goal (dx = 0.0, dy = 0.5)
          goalSteeringY = (puck.p.dy < 0.5) ? -0.4 : 0.4;
        }

        final impactSpeed = math.max(.75, puck.v.distance * speedMultiplier);
        puck.v = (normal * impactSpeed) + Offset(paddle.team == 0 ? .15 : -.22, ((puck.p.dy - paddle.p.dy) * 2.5) + goalSteeringY);
        puck.p = paddle.p + normal * combinedRadius;
        _burst(puck.p, paddle.team == 0 ? cyan : pink);
      }
    }

    if (puck.v.distance > 1.6) puck.v = puck.v / puck.v.distance * 1.6;

    if (random.nextDouble() < .15 && puck.v.distance > 0.2) {
      sparks.add(_Spark(puck.p, Offset((random.nextDouble()-.5)*.15, (random.nextDouble()-.5)*.15), random.nextDouble()*.4+.15, cyan));
    }
    for (final s in sparks) { s.life -= dt; s.p += s.v * dt; }
    sparks.removeWhere((s) => s.life <= 0);

    if (mounted) setState(() {});
  }

  Rect _bounds() => Rect.fromLTRB(.045, .075, .955, .925);

  void _moveAI(Paddle paddle, double dt) {
    final bounds = _bounds();
    final isHeadingToAI = puck.v.dx > 0;

    switch (widget.difficulty) {
      case Difficulty.easy:
        if (isHeadingToAI && puck.p.dx > 0.4) {
          paddle.target = Offset(0.78, puck.p.dy + (random.nextDouble() - 0.5) * 0.2);
        } else {
          paddle.target = const Offset(0.82, 0.5);
        }
        break;

      case Difficulty.medium:
        if (isHeadingToAI) {
          double predictY = puck.p.dy + (puck.v.dy * 0.3);
          paddle.target = Offset(0.76, predictY.clamp(bounds.top + .1, bounds.bottom - .1));
        } else {
          paddle.target = const Offset(0.80, 0.5);
        }
        break;

      case Difficulty.hard:
        // Pro Policy Neural/Vector Prediction Engine
        if (isHeadingToAI || puck.p.dx > 0.45) {
          double targetX = (puck.p.dx > 0.60) ? puck.p.dx - 0.02 : 0.68;
          double timeToReach = (targetX - puck.p.dx) / (puck.v.dx == 0 ? 0.01 : puck.v.dx);
          double predictedY = puck.p.dy + (puck.v.dy * timeToReach);

          // Full wall-bounce regression simulation
          final top = bounds.top + puck.r;
          final bottom = bounds.bottom - puck.r;

          while (predictedY < top || predictedY > bottom) {
            if (predictedY < top) {
              predictedY = top + (top - predictedY);
            } else if (predictedY > bottom) {
              predictedY = bottom - (predictedY - bottom);
            }
          }

          // Aggressive attacking posture: intercept early and press forward
          paddle.target = Offset(targetX.clamp(0.55, 0.88), predictedY);
        } else {
          // Tactical center-line containment
          paddle.target = Offset(0.75, puck.p.dy);
        }
        break;
    }
  }

  void _score(int team) {
    if (team == 0) cyanScore++; else pinkScore++;
    _burst(puck.p, team == 0 ? cyan : pink, count: 32);
    if (cyanScore >= 7 || pinkScore >= 7) {
      ended = true;
      banner = cyanScore > pinkScore ? 'CYAN WINS!' : 'MAGENTA WINS!';
    } else {
      banner = team == 0 ? 'CYAN SCORES!' : 'MAGENTA SCORES!';
      bannerTime = 1.5;
      _resetPositions();
    }
    setState(() {});
  }

  void _burst(Offset p, Color color, {int count = 10}) {
    for (var i = 0; i < count; i++) {
      final a = random.nextDouble() * math.pi * 2;
      final speed = .2 + random.nextDouble() * .9;
      sparks.add(_Spark(p, Offset(math.cos(a) * speed, math.sin(a) * speed), .25 + random.nextDouble() * .45, color));
    }
  }

  Offset _normalized(Offset local) => Offset(
    (local.dx / arena.width).clamp(.04, .96),
    (local.dy / arena.height).clamp(.08, .92),
  );

  void _moveHuman(Offset local, bool isRightSidePlayer) {
    final pos = _normalized(local);
    if (widget.mode == PlayMode.ai) {
      paddles[0].target = Offset(pos.dx.clamp(.08, .46), pos.dy.clamp(.14, .86));
    } else {
      if (!isRightSidePlayer && pos.dx < .5) {
        paddles[0].target = Offset(pos.dx.clamp(.08, .46), pos.dy.clamp(.14, .86));
      } else if (isRightSidePlayer || pos.dx >= .5) {
        paddles[1].target = Offset(pos.dx.clamp(.54, .92), pos.dy.clamp(.14, .86));
      }
    }
  }

  void _rematch() => setState(() {
    cyanScore = 0; pinkScore = 0; paused = false; ended = false;
    banner = 'FACE OFF!'; bannerTime = 1.5; sparks.clear(); _resetPositions();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
            Expanded(child: Column(children: [
              const Text('GLOW HOCKEY', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900)),
              Text(widget.mode == PlayMode.ai ? '${widget.difficulty.name.toUpperCase()} AI' : 'LOCAL 2 PLAYERS',
                style: const TextStyle(fontSize: 10, color: Colors.white54, letterSpacing: 1.5)),
            ])),
            IconButton(onPressed: () => setState(() => paused = !paused),
              icon: Icon(paused ? Icons.play_arrow_rounded : Icons.pause_rounded, color: gold, size: 28)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _Score(color: cyan, label: 'CYAN', score: cyanScore),
            const Text('FIRST TO 7', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.4)),
            _Score(color: pink, label: 'MAGENTA', score: pinkScore),
          ]),
        ),
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          arena = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (d) => _moveHuman(d.localPosition, d.localPosition.dx >= arena.width / 2),
            onPanUpdate: (d) => _moveHuman(d.localPosition, d.localPosition.dx >= arena.width / 2),
            child: CustomPaint(
              painter: ArenaPainter(puck: puck, paddles: paddles, sparks: sparks,
                banner: bannerTime > 0 || ended ? banner : '', cyanScore: cyanScore,
                pinkScore: pinkScore, paused: paused, ended: ended),
              size: Size.infinite,
            ),
          );
        })),
        if (ended) Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ElevatedButton.icon(
            onPressed: _rematch,
            icon: const Icon(Icons.replay_rounded),
            label: const Text('REMATCH'),
            style: ElevatedButton.styleFrom(backgroundColor: cyan, foregroundColor: bg,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(widget.mode == PlayMode.ai
            ? 'DRAG ON YOUR HALF (LEFT) TO CONTROL YOUR PADDLE'
            : 'LEFT SIDE: CYAN  •  RIGHT SIDE: MAGENTA',
            textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
        ),
      ])),
    );
  }
}

class _Score extends StatelessWidget {
  final Color color; final String label; final int score;
  const _Score({required this.color, required this.label, required this.score});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color.withOpacity(.8), blurRadius: 8)])),
    const SizedBox(width: 7),
    Text('$label  $score', style: TextStyle(color: color, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
  ]);
}

class _Spark {
  Offset p, v; double life; final Color color;
  _Spark(this.p, this.v, this.life, this.color);
}

class TickerController {
  final void Function(double) onTick;
  late final Ticker _ticker;
  Duration? _last;
  TickerController({required this.onTick}) { _ticker = Ticker((elapsed) {
    final dt = _last == null ? 0.016 : (elapsed - _last!).inMicroseconds / 1e6;
    _last = elapsed; onTick(dt);
  }); }
  void start() => _ticker.start();
  void dispose() => _ticker.dispose();
}

class ArenaPainter extends CustomPainter {
  final Puck puck;
  final List<Paddle> paddles;
  final List<_Spark> sparks;
  final String banner;
  final int cyanScore, pinkScore;
  final bool paused, ended;
  ArenaPainter({required this.puck, required this.paddles, required this.sparks,
    required this.banner, required this.cyanScore, required this.pinkScore,
    required this.paused, required this.ended});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = const LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF101B38), Color(0xFF070B18), Color(0xFF11142D)],
    ).createShader(rect));
    
    final field = Rect.fromLTRB(size.width*.045, size.height*.075, size.width*.955, size.height*.925);
    final r = RRect.fromRectAndRadius(field, const Radius.circular(22));
    canvas.drawRRect(r, Paint()..color = const Color(0xFF0A1126));
    canvas.drawRRect(r, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.2
      ..color = cyan.withOpacity(.7)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7));
    canvas.drawRRect(r, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.4..color = cyan.withOpacity(.8));
    
    final center = size.height*.5;
    canvas.drawLine(Offset(field.center.dx, field.top), Offset(field.center.dx, field.bottom),
      Paint()..color = Colors.white.withOpacity(.15)..strokeWidth = 1.2);
    canvas.drawCircle(Offset(field.center.dx, center), size.width*.095,
      Paint()..style = PaintingStyle.stroke..strokeWidth = 1.4..color = Colors.white.withOpacity(.17));
    canvas.drawCircle(Offset(field.center.dx, center), 4, Paint()..color = Colors.white.withOpacity(.4));
    
    final goalH = size.height*.20;
    for (final team in [0, 1]) {
      final x = team == 0 ? field.left : field.right;
      final goal = Rect.fromCenter(center: Offset(x, center), width: 10, height: goalH);
      final color = team == 0 ? pink : cyan;
      canvas.drawRRect(RRect.fromRectAndRadius(goal, const Radius.circular(5)),
        Paint()..color = color.withOpacity(.12));
      canvas.drawRRect(RRect.fromRectAndRadius(goal, const Radius.circular(5)),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    }
    
    for (final s in sparks) {
      final p = Offset(s.p.dx * size.width, s.p.dy * size.height);
      canvas.drawCircle(p, 2.5 * s.life, Paint()..color = s.color.withOpacity(s.life.clamp(0, 1)));
    }
    
    _drawGlow(canvas, Offset(puck.p.dx*size.width, puck.p.dy*size.height), size.width*.022, Colors.white, cyan);
    
    for (final p in paddles) {
      final c = p.team == 0 ? cyan : pink;
      _drawGlow(canvas, Offset(p.p.dx*size.width, p.p.dy*size.height), size.width*.035, c, c);
      canvas.drawCircle(Offset(p.p.dx*size.width, p.p.dy*size.height), size.width*.022,
        Paint()..color = const Color(0xFF10172C));
      canvas.drawCircle(Offset(p.p.dx*size.width, p.p.dy*size.height), size.width*.022,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = c);
    }
    
    if (banner.isNotEmpty) {
      final text = TextPainter(text: TextSpan(text: banner, style: TextStyle(
        color: ended ? gold : Colors.white, fontSize: math.min(26, size.width*.055),
        fontWeight: FontWeight.w900, letterSpacing: 2,
        shadows: [Shadow(color: ended ? gold : cyan, blurRadius: 16)])),
        textDirection: TextDirection.ltr)..layout(maxWidth: size.width*.85);
      final y = ended || paused ? size.height*.43 : size.height*.18;
      final box = Rect.fromCenter(center: Offset(size.width*.5, y), width: text.width+34, height: text.height+22);
      canvas.drawRRect(RRect.fromRectAndRadius(box, const Radius.circular(14)),
        Paint()..color = const Color(0xDD080D1E));
      canvas.drawRRect(RRect.fromRectAndRadius(box, const Radius.circular(14)),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = (ended ? gold : cyan).withOpacity(.55));
      text.paint(canvas, Offset(box.left+17, box.top+11));
    }
    
    if (paused || ended) {
      canvas.drawRect(rect, Paint()..color = Colors.black.withOpacity(.48));
      final msg = ended ? 'MATCH COMPLETE' : 'PAUSED';
      final tp = TextPainter(text: TextSpan(text: msg, style: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 3)),
        textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset((size.width-tp.width)/2, size.height*.5));
      final hint = TextPainter(text: TextSpan(text: ended ? 'TAP REMATCH BELOW' : 'TAP PLAY TO CONTINUE',
        style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5)),
        textDirection: TextDirection.ltr)..layout();
      hint.paint(canvas, Offset((size.width-hint.width)/2, size.height*.5+34));
    }
  }

  void _drawGlow(Canvas canvas, Offset p, double radius, Color core, Color glow) {
    canvas.drawCircle(p, radius*2.1, Paint()..color = glow.withOpacity(.18)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius*.75));
    canvas.drawCircle(p, radius*1.4, Paint()..color = glow.withOpacity(.25)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius*.35));
    canvas.drawCircle(p, radius, Paint()..color = core);
    canvas.drawCircle(p, radius*.45, Paint()..color = Colors.white.withOpacity(.9));
  }

  @override
  bool shouldRepaint(covariant ArenaPainter oldDelegate) => true;
}