import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _mainCtrl;
  late final AnimationController _ringCtrl;

  late final Animation<double> _bgOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    _initAnimations();
    _mainCtrl.forward().then((_) {
      if (mounted) context.goNamed(AppRoutes.homeName);
    });
  }

  void _initAnimations() {
    _bgOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.06, 0.50, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.04, 0.28, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween(
      begin: const Offset(0, 0.9),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.46, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.44, 0.68, curve: Curves.easeIn),
      ),
    );

    _taglineOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.66, 0.82, curve: Curves.easeIn),
      ),
    );

    _progress = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.04, 0.96, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoSize = size.width * 0.38;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Stack(
        children: [
          // Radial background glow
          FadeTransition(
            opacity: _bgOpacity,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.18),
                  radius: 1.1,
                  colors: [
                    AppColors.primaryCLR.withValues(alpha: 0.55),
                    const Color(0xFF0A1628),
                  ],
                ),
              ),
            ),
          ),

          // Decorative corner dots
          ..._buildCornerDots(size),

          // Pulsing rings behind logo
          Center(
            child: _PulsingRings(
              controller: _ringCtrl,
              logoSize: logoSize,
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.02),
                // Logo
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: _LogoWidget(size: logoSize),
                  ),
                ),

                SizedBox(height: size.height * 0.048),

                // Brand text + tagline
                FadeTransition(
                  opacity: _textOpacity,
                  child: ClipRect(
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/bharat_nova_text.png',
                            width: size.width * 0.56,
                          ),
                          const SizedBox(height: 14),
                          FadeTransition(
                            opacity: _taglineOpacity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _dot(),
                                const SizedBox(height: 10),
                                const Text(
                                  "India's Stories. Your Way.",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFFB8C4D8),
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom: gradient progress bar + version
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(
              progress: _progress,
              bottomPad: MediaQuery.paddingOf(context).bottom,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryCLR.withValues(alpha: 0.5),
        ),
      )),
    );
  }

  List<Widget> _buildCornerDots(Size size) {
    const dotColor = Color(0xFF1E3A5F);
    Widget dot(double s) => Container(
      width: s, height: s,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
      ),
    );

    return [
      Positioned(top: size.height * 0.08, left: size.width * 0.08, child: dot(6)),
      Positioned(top: size.height * 0.12, left: size.width * 0.18, child: dot(4)),
      Positioned(top: size.height * 0.06, left: size.width * 0.32, child: dot(3)),
      Positioned(top: size.height * 0.10, right: size.width * 0.10, child: dot(5)),
      Positioned(top: size.height * 0.07, right: size.width * 0.24, child: dot(3)),
      Positioned(bottom: size.height * 0.14, left: size.width * 0.06, child: dot(5)),
      Positioned(bottom: size.height * 0.18, left: size.width * 0.20, child: dot(3)),
      Positioned(bottom: size.height * 0.12, right: size.width * 0.08, child: dot(6)),
      Positioned(bottom: size.height * 0.16, right: size.width * 0.22, child: dot(4)),
    ];
  }
}


class _PulsingRings extends StatelessWidget {
  final AnimationController controller;
  final double logoSize;

  const _PulsingRings({required this.controller, required this.logoSize});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final v = controller.value;
        return CustomPaint(
          size: Size(logoSize * 3, logoSize * 3),
          painter: _RingsPainter(
            phases: [v, (v + 0.33) % 1.0, (v + 0.66) % 1.0],
            baseRadius: logoSize / 2,
          ),
        );
      },
    );
  }
}

class _RingsPainter extends CustomPainter {
  final List<double> phases;
  final double baseRadius;

  const _RingsPainter({required this.phases, required this.baseRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final t in phases) {
      final radius = baseRadius * (1.0 + t * 0.85);
      final opacity = (1.0 - t) * 0.13;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = AppColors.primaryCLR.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) =>
      old.phases != phases || old.baseRadius != baseRadius;
}


class _LogoWidget extends StatelessWidget {
  final double size;
  const _LogoWidget({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCLR.withValues(alpha: 0.6),
            blurRadius: 60,
            spreadRadius: 8,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/bharat_nova_logo.png',
        width: size,
        height: size,
      ),
    );
  }
}


class _BottomBar extends StatelessWidget {
  final Animation<double> progress;
  final double bottomPad;

  const _BottomBar({required this.progress, required this.bottomPad});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Track
          Container(
            height: 2.5,
            color: Colors.white.withValues(alpha: 0.07),
          ),
          // Gradient fill
          Transform.translate(
            offset: const Offset(0, -2.5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.value,
                child: Container(
                  height: 2.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.splashProgress,
                        AppColors.primaryCLR,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: bottomPad + 16),
          Text(
            'v 1.0.0   •   BharatNova',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.25),
              letterSpacing: 1.4,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
