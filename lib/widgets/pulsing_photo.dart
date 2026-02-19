import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import '../theme/app_theme.dart';

/// Animation cycle states
enum AnimationState {
  pausedAtFirst, // Step 1: Paused at first frame
  playingForward, // Step 2: Playing forward to last frame
  pausedAtLast, // Step 3: Paused at last frame
  playingReverse, // Step 4: Playing reverse to first frame
}

/// Profile photo with animated plasma ring and controlled GIF animation
/// Plays: first frame (10s pause) -> forward to last -> last frame (10s pause) -> reverse to first -> repeat
class PulsingPhoto extends StatefulWidget {
  final String gifPath;
  final String? backgroundImagePath; // Static image to show behind GIF
  final double size;
  final Duration pauseDuration;

  const PulsingPhoto({
    super.key,
    required this.gifPath,
    this.backgroundImagePath,
    this.size = 200,
    this.pauseDuration = const Duration(seconds: 10),
  });

  @override
  State<PulsingPhoto> createState() => _PulsingPhotoState();
}

class _PulsingPhotoState extends State<PulsingPhoto>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  GifController? _gifController;
  Timer? _cycleTimer;
  AnimationState _currentState = AnimationState.pausedAtFirst;
  bool _hasStartedCycle = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _gifController = GifController();

    // Add listener to detect when controller is ready
    _gifController!.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    // Start the cycle once the GIF is loaded and we haven't started yet
    if (!_hasStartedCycle && _gifController!.status != GifStatus.loading) {
      _hasStartedCycle = true;
      _startStep1();
    }
  }

  // Step 1: Pause at first frame for 10 seconds
  void _startStep1() {
    // debugPrint('Step 1: Pausing at first frame');
    _currentState = AnimationState.pausedAtFirst;
    _gifController?.stop(); // Use stop() to reset to frame 0

    _cycleTimer?.cancel();
    _cycleTimer = Timer(widget.pauseDuration, () {
      if (!mounted) return;
      _startStep2();
    });
  }

  // Step 2: Play forward to last frame
  void _startStep2() {
    if (!mounted || _gifController == null) return;
    // debugPrint('Step 2: Playing forward');
    _currentState = AnimationState.playingForward;
    // Explicitly set inverted: false to ensure forward playback
    _gifController!.play(initialFrame: 0, inverted: false);
  }

  // Step 3: Pause at last frame for 10 seconds
  void _startStep3() {
    // debugPrint('Step 3: Pausing at last frame');
    _currentState = AnimationState.pausedAtLast;
    _gifController?.pause();

    _cycleTimer?.cancel();
    _cycleTimer = Timer(widget.pauseDuration, () {
      if (!mounted) return;
      _startStep4();
    });
  }

  // Step 4: Play reverse to first frame
  void _startStep4() {
    if (!mounted || _gifController == null) return;
    // debugPrint('Step 4: Playing reverse');
    _currentState = AnimationState.playingReverse;
    _gifController!.play(inverted: true);
  }

  void _onAnimationFinished() {
    if (!mounted) return;

    // Ignore spurious finish events during paused states
    if (_currentState == AnimationState.pausedAtFirst ||
        _currentState == AnimationState.pausedAtLast) {
      // debugPrint('Ignoring finish during paused state: $_currentState');
      return;
    }

    // debugPrint('Animation finished in state: $_currentState');

    switch (_currentState) {
      case AnimationState.playingForward:
        // Finished playing forward -> go to step 3 (pause at last)
        _startStep3();
        break;
      case AnimationState.playingReverse:
        // Finished playing reverse -> go to step 1 (pause at first)
        _startStep1();
        break;
      case AnimationState.pausedAtFirst:
      case AnimationState.pausedAtLast:
        // Should not happen, already handled above
        break;
    }
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _gifController?.removeListener(_onControllerUpdate);
    _pulseController.dispose();
    _rotationController.dispose();
    _gifController?.dispose();
    super.dispose();
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
                angle: _rotationController.value * 2 * pi,
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

          // Static background image (prevents GIF transparency issues)
          if (widget.backgroundImagePath != null)
            ClipOval(
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Image.asset(
                  widget.backgroundImagePath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // GIF with controlled animation (layered on top)
          ClipOval(
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: GifView.asset(
                widget.gifPath,
                controller: _gifController,
                fit: BoxFit.cover,
                loop: false,
                onFinish: _onAnimationFinished,
                errorBuilder: (context, error, stackTrace) {
                  // debugPrint('GIF Error: $error');
                  return Container(
                    color: AppTheme.surface,
                    child: Icon(
                      Icons.person,
                      size: widget.size * 0.5,
                      color: AppTheme.textSecondary,
                    ),
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
