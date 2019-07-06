import 'package:flutter/material.dart';

import 'package:progress_indicators/src/collection_animators.dart';

/// Adds fading effect on each character in the [text] provided to it.
///
/// The animation is repeated continuously so this widget is ideal
/// to be used as progress indicator.
/// Although this widget does not put explicit limit on string character count,
/// however, it should be given such that it does not exceed a line.
///
/// The text displayed follows the default [TextStyle] of current theme, unless
/// otherwise specified.
class FadingText extends StatefulWidget {
  /// Text to animate
  final String text;
  /// Custom text style. If not specified, uses the default style.
  final TextStyle style;

  /// Creates a fading continuous animation.
  ///
  /// The provided [text] is continuously animated using [FadeTransition].
  /// [text] must not be null.
  FadingText(this.text, {this.style}) : assert(text != null);

  @override
  _FadingTextState createState() => new _FadingTextState();
}

class _FadingTextState extends State<FadingText> with TickerProviderStateMixin {
  final _characters = <MapEntry<String, Animation>>[];
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    var start = 0.2;
    final duration = 0.6 / widget.text.length;
    widget.text.runes.forEach((int rune) {
      final character = new String.fromCharCode(rune);
      final animation = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.easeInOut),
          parent: _controller,
        ),
      );
      _characters.add(MapEntry(character, animation));
      start += duration;
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _characters
          .map(
            (entry) => FadeTransition(
                  opacity: entry.value,
                  child: Text(entry.key, style: style),
                ),
          )
          .toList(),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Adds jumping effect on each character in the [text] provided to it.
///
/// The animation is repeated continuously so this widget is ideal
/// to be used as progress indicator.
/// Although this widget does not put explicit limit on string character count,
/// however, it should be given such that it does not exceed a line.
///
/// The text displayed follows the default [TextStyle] of current theme, unless
/// otherwise specified.
class JumpingText extends StatelessWidget {
  final String text;
  final Offset begin = Offset(0.0, 0.0);
  final Offset end;
  final TextStyle style;

  /// Creates a jumping text widget.
  ///
  /// Each character in [text] is animated to look like a jumping effect.
  /// The [end] is the target [Offset] for each character.
  JumpingText(this.text, {this.end = const Offset(0.0, -0.5), this.style});

  @override
  Widget build(BuildContext context) {
    return CollectionSlideTransition(
      children: text.runes
          .map(
            (rune) => Text(String.fromCharCode(rune), style: style),
          )
          .toList(),
    );
  }
}

/// Adds jumping effect on each character in the [text] provided to it.
///
/// The animation is repeated continuously so this widget is ideal
/// to be used as progress indicator.
/// Although this widget does not put explicit limit on string character count,
/// however, it should be given such that it does not exceed a line.
///
/// The text displayed follows the default [TextStyle] of current theme, unless
/// otherwise specified.
class ScalingText extends StatelessWidget {
  /// The text to add scaling effect to.
  final String text;
  final double begin = 1.0;
  final double end;
  final TextStyle style;

  /// Creates a jumping text widget.
  ///
  /// Each character in [text] is scaled to [end].
  ScalingText(this.text, {this.end = 2.0, this.style});

  @override
  Widget build(BuildContext context) {
    return CollectionScaleTransition(
      end: end,
      children: text.runes
          .map(
            (rune) => Text(String.fromCharCode(rune), style: style),
          )
          .toList(),
    );
  }
}
