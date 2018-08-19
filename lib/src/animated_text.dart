import 'package:flutter/material.dart';

import 'package:progress_indicators/src/collection_animators.dart';

class FadingText extends StatefulWidget {
  final String text;

  FadingText(this.text);

  @override
  _FadingTextState createState() => new _FadingTextState();
}

class _FadingTextState extends State<FadingText>
    with TickerProviderStateMixin {
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
                  child: Text(entry.key),
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

class JumpingText extends StatelessWidget {
  final String text;
  final Offset begin = Offset(0.0, 0.0);
  final Offset end = Offset(0.0, -0.5);

  JumpingText(this.text);

  @override
  Widget build(BuildContext context) {
    return CollectionSlideTransition(
      children: text.runes
          .map(
            (rune) => Text(String.fromCharCode(rune)),
          )
          .toList(),
    );
  }
}

class ScalingText extends StatelessWidget {
  final String text;
  final double begin = 1.0;
  final double end = 2.0;

  ScalingText(this.text);

  @override
  Widget build(BuildContext context) {
    return CollectionScaleTransition(
      children: text.runes
          .map(
            (rune) => Text(String.fromCharCode(rune)),
          )
          .toList(),
    );
  }
}
