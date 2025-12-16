import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/pulse_grid_theme.dart';

/// Animated typing text widget
/// Types out text character by character with a blinking cursor
/// Can cycle through multiple strings
class TypingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration pauseDuration;
  final bool showCursor;

  const TypingText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 80),
    this.deletingSpeed = const Duration(milliseconds: 40),
    this.pauseDuration = const Duration(seconds: 2),
    this.showCursor = true,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayText = '';
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  bool _cursorVisible = true;
  Timer? _typingTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _startCursorBlink();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (timer) {
      if (mounted) {
        setState(() {
          _cursorVisible = !_cursorVisible;
        });
      }
    });
  }

  void _startTyping() {
    final currentText = widget.texts[_textIndex];
    
    if (_isDeleting) {
      if (_charIndex > 0) {
        _typingTimer = Timer(widget.deletingSpeed, () {
          if (mounted) {
            setState(() {
              _charIndex--;
              _displayText = currentText.substring(0, _charIndex);
            });
            _startTyping();
          }
        });
      } else {
        _isDeleting = false;
        _textIndex = (_textIndex + 1) % widget.texts.length;
        _startTyping();
      }
    } else {
      if (_charIndex < currentText.length) {
        _typingTimer = Timer(widget.typingSpeed, () {
          if (mounted) {
            setState(() {
              _charIndex++;
              _displayText = currentText.substring(0, _charIndex);
            });
            _startTyping();
          }
        });
      } else {
        // Pause before deleting
        _typingTimer = Timer(widget.pauseDuration, () {
          if (mounted) {
            setState(() {
              _isDeleting = true;
            });
            _startTyping();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = widget.style ?? 
        Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: PulseGridColors.primary,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _displayText,
          style: defaultStyle,
        ),
        if (widget.showCursor)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: _cursorVisible ? 1.0 : 0.0,
            child: Text(
              '|',
              style: defaultStyle?.copyWith(
                color: PulseGridColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
