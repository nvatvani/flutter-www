import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Typewriter animation for hero text
class TypingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;

  const TypingText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 80),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  String _displayText = '';

  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _tryTypeNext();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _tryTypeNext() {
    if (!mounted) return;

    final currentText = widget.texts[_textIndex];
    Duration nextDelay;

    if (!_isDeleting) {
      if (_charIndex < currentText.length) {
        // Typing
        nextDelay = widget.typingSpeed;
        _typingTimer = Timer(nextDelay, () {
          if (mounted) {
            setState(() {
              _charIndex++;
              _displayText = currentText.substring(0, _charIndex);
            });
            _tryTypeNext();
          }
        });
      } else {
        // Finished typing, wait before deleting
        nextDelay = widget.pauseDuration;
        _typingTimer = Timer(nextDelay, () {
          if (mounted) {
            setState(() {
              _isDeleting = true;
            });
            _tryTypeNext();
          }
        });
      }
    } else {
      // Deleting
      if (_charIndex > 0) {
        nextDelay = Duration(
          milliseconds: widget.typingSpeed.inMilliseconds ~/ 2,
        );
        _typingTimer = Timer(nextDelay, () {
          if (mounted) {
            setState(() {
              _charIndex--;
              _displayText = currentText.substring(0, _charIndex);
            });
            _tryTypeNext();
          }
        });
      } else {
        // Finished deleting, move to next text
        // No delay needed to switch index, but maybe a small frame delay?
        // Let's just switch and continue
        if (mounted) {
          setState(() {
            _isDeleting = false;
            _textIndex = (_textIndex + 1) % widget.texts.length;
          });
          _tryTypeNext();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.displayLarge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [AppTheme.cyan, AppTheme.purple],
              ).createShader(bounds),
          child: Text(
            _displayText,
            style: (widget.style ?? defaultStyle)?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        _Cursor(style: widget.style ?? defaultStyle),
      ],
    );
  }
}

class _Cursor extends StatefulWidget {
  final TextStyle? style;

  const _Cursor({this.style});

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Container(
            width: 3,
            height: (widget.style?.fontSize ?? 64) * 0.8,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: AppTheme.cyan,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cyan.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
