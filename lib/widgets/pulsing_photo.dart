import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Animation cycle states
enum AnimationPhase {
  startImage, // Step 1: Display start PNG
  forwardWebp, // Step 2: Forward WebP animation
  endImage, // Step 3: Display end PNG
  reverseWebp, // Step 4: Reverse WebP animation
}

/// Profile photo with animated plasma ring and WebP animation cycle
/// Cycle: start PNG (10s) -> forward WebP (10s) -> end PNG (10s) -> reverse WebP (10s) -> repeat
/// Option 1: Manual Crossfade - keeps both old and new content visible during transition
class PulsingPhoto extends StatefulWidget {
  final String startImagePath;
  final String forwardWebpPath;
  final String endImagePath;
  final String reverseWebpPath;
  final double size;
  final Duration displayDuration;
  final Duration fadeDuration;

  const PulsingPhoto({
    super.key,
    required this.startImagePath,
    required this.forwardWebpPath,
    required this.endImagePath,
    required this.reverseWebpPath,
    this.size = 200,
    this.displayDuration = const Duration(seconds: 10),
    this.fadeDuration = const Duration(milliseconds: 20),
  });

  @override
  State<PulsingPhoto> createState() => _PulsingPhotoState();
}

class _PulsingPhotoState extends State<PulsingPhoto>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _crossfadeController;
  late Animation<double> _pulseAnimation;

  Timer? _cycleTimer;

  // Track current and previous phase for crossfade
  AnimationPhase _currentPhase = AnimationPhase.startImage;
  AnimationPhase? _previousPhase;

  // Cycle counters to force WebP reload
  int _forwardCycle = 0;
  int _reverseCycle = 0;
  int _prevForwardCycle = 0;
  int _prevReverseCycle = 0;

  @override
  void initState() {
    super.initState();

    // Pulsing glow effect
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Rotating gradient ring
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Crossfade controller
    _crossfadeController = AnimationController(
      duration: widget.fadeDuration,
      vsync: this,
      value: 1.0, // Start with current content fully visible
    );

    // Start the animation cycle
    _startCycle();
  }

  void _startCycle() {
    _cycleTimer?.cancel();
    _cycleTimer = Timer(widget.displayDuration, () {
      if (!mounted) return;
      _transitionToNextPhase();
    });
  }

  void _transitionToNextPhase() {
    // Save current state as previous
    _previousPhase = _currentPhase;
    _prevForwardCycle = _forwardCycle;
    _prevReverseCycle = _reverseCycle;

    // Determine next phase
    AnimationPhase nextPhase;
    switch (_currentPhase) {
      case AnimationPhase.startImage:
        nextPhase = AnimationPhase.forwardWebp;
        _forwardCycle++;
        break;
      case AnimationPhase.forwardWebp:
        nextPhase = AnimationPhase.endImage;
        break;
      case AnimationPhase.endImage:
        nextPhase = AnimationPhase.reverseWebp;
        _reverseCycle++;
        break;
      case AnimationPhase.reverseWebp:
        nextPhase = AnimationPhase.startImage;
        break;
    }

    // Update to new phase and reset crossfade
    setState(() {
      _currentPhase = nextPhase;
      _crossfadeController.value = 0.0;
    });

    // Animate crossfade: previous fades out, current fades in
    _crossfadeController.forward().then((_) {
      if (!mounted) return;
      // Clear previous phase after transition completes
      setState(() {
        _previousPhase = null;
      });
      _startCycle();
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    _crossfadeController.dispose();
    super.dispose();
  }

  Widget _buildContent(
    AnimationPhase phase,
    int forwardCycle,
    int reverseCycle,
  ) {
    switch (phase) {
      case AnimationPhase.startImage:
        return Image.asset(
          widget.startImagePath,
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size,
        );
      case AnimationPhase.forwardWebp:
        return _WebPAnimation(
          key: ValueKey('forward_$forwardCycle'),
          assetPath: widget.forwardWebpPath,
          fit: BoxFit.cover,
          size: widget.size,
        );
      case AnimationPhase.endImage:
        return Image.asset(
          widget.endImagePath,
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size,
        );
      case AnimationPhase.reverseWebp:
        return _WebPAnimation(
          key: ValueKey('reverse_$reverseCycle'),
          assetPath: widget.reverseWebpPath,
          fit: BoxFit.cover,
          size: widget.size,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + 40,
      height: widget.size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing glow ring
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: widget.size + 30,
                height: widget.size + 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cyan.withValues(
                        alpha: 0.3 * _pulseAnimation.value,
                      ),
                      blurRadius: 30 * _pulseAnimation.value,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: AppTheme.purple.withValues(
                        alpha: 0.2 * _pulseAnimation.value,
                      ),
                      blurRadius: 40 * _pulseAnimation.value,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),

          // Rotating gradient ring
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Container(
                  width: widget.size + 16,
                  height: widget.size + 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppTheme.cyan,
                        AppTheme.purple,
                        AppTheme.magenta,
                        AppTheme.cyan,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Inner dark circle
          Container(
            width: widget.size + 8,
            height: widget.size + 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.background,
            ),
          ),

          // Manual crossfade: both previous and current content layered
          ClipOval(
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: AnimatedBuilder(
                animation: _crossfadeController,
                builder: (context, child) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Previous content (fades out)
                      if (_previousPhase != null)
                        Opacity(
                          opacity: 1.0 - _crossfadeController.value,
                          child: _buildContent(
                            _previousPhase!,
                            _prevForwardCycle,
                            _prevReverseCycle,
                          ),
                        ),
                      // Current content (fades in)
                      Opacity(
                        opacity: _crossfadeController.value,
                        child: _buildContent(
                          _currentPhase,
                          _forwardCycle,
                          _reverseCycle,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Separate widget for WebP animation to ensure complete disposal
class _WebPAnimation extends StatefulWidget {
  final String assetPath;
  final BoxFit fit;
  final double size;

  const _WebPAnimation({
    super.key,
    required this.assetPath,
    required this.fit,
    required this.size,
  });

  @override
  State<_WebPAnimation> createState() => _WebPAnimationState();
}

class _WebPAnimationState extends State<_WebPAnimation> {
  Uint8List? _imageBytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final data = await rootBundle.load(widget.assetPath);
      if (mounted) {
        setState(() {
          _imageBytes = data.buffer.asUint8List();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _imageBytes == null) {
      return Container(color: AppTheme.background);
    }

    return Image.memory(
      _imageBytes!,
      fit: widget.fit,
      width: widget.size,
      height: widget.size,
      gaplessPlayback: false,
    );
  }
}
