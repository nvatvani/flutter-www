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

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while (mounted) {
      final currentText = widget.texts[_textIndex];

      if (!_isDeleting) {
        // Typing
        if (_charIndex < currentText.length) {
          await Future.delayed(widget.typingSpeed);
          if (mounted) {
            setState(() {
              _charIndex++;
              _displayText = currentText.substring(0, _charIndex);
            });
          }
        } else {
          // Pause before deleting
          await Future.delayed(widget.pauseDuration);
          if (mounted) {
            setState(() => _isDeleting = true);
          }
        }
      } else {
        // Deleting
        if (_charIndex > 0) {
          await Future.delayed(
            Duration(milliseconds: widget.typingSpeed.inMilliseconds ~/ 2),
          );
          if (mounted) {
            setState(() {
              _charIndex--;
              _displayText = currentText.substring(0, _charIndex);
            });
          }
        } else {
          // Move to next text
          if (mounted) {
            setState(() {
              _isDeleting = false;
              _textIndex = (_textIndex + 1) % widget.texts.length;
            });
          }
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
