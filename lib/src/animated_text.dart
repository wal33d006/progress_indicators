import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedText extends StatefulWidget {
  final String text;

  AnimatedText(this.text);

  @override
  _AnimatedTextState createState() => new _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
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

class JumpingText extends StatefulWidget {
  final String text;
  final Offset begin = Offset(0.0, 0.0);
  final Offset end = Offset(0.0, -0.5);

  JumpingText(this.text);

  @override
  _JumpingTextState createState() => new _JumpingTextState();
}

class _JumpingTextState extends State<JumpingText>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final _characters = <_CharacterAnimation<Offset>>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.text.length * 0.25).round()),
    );

    var start = 0.0;
    final duration = 1.0 / (widget.text.length * 2);
    widget.text.runes.forEach((int rune) {
      final character = new String.fromCharCode(rune);
      final animation = Tween<Offset>(
        begin: widget.begin,
        end: widget.end,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.ease),
          parent: _controller,
        ),
      );

      final revAnimation = Tween<Offset>(
        begin: widget.end,
        end: widget.begin,
      ).animate(
        CurvedAnimation(
          curve: Interval(start + duration, start + duration * 2,
              curve: Curves.ease),
          parent: _controller,
        ),
      );
      _characters.add(_CharacterAnimation(
          text: character, forward: animation, reverse: revAnimation));
      start += duration;
    });

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.end;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _characters.map(
        (entry) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, widget) {
              return FractionalTranslation(
                translation:
                    entry.forward.value.distanceSquared >= end.distanceSquared
                        ? entry.reverse.value
                        : entry.forward.value,
                child: Text(entry.text),
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CharacterAnimation<T> {
  final String text;
  final Animation<T> forward;
  final Animation<T> reverse;

  _CharacterAnimation({this.text, this.forward, this.reverse});
}

class ScalingText extends StatefulWidget {
  final String text;
  final double begin = 1.0;
  final double end = 2.0;

  ScalingText(this.text);

  @override
  _ScalingTextState createState() => new _ScalingTextState();
}

class _ScalingTextState extends State<ScalingText>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final _characters = <_CharacterAnimation<double>>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.text.length * 0.25).round()),
    );

    var start = 0.0;
    final duration = 1.0 / (widget.text.length * 2);
    widget.text.runes.forEach((int rune) {
      final character = new String.fromCharCode(rune);
      final animation = Tween<double>(
        begin: widget.begin,
        end: widget.end,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.easeOut),
          parent: _controller,
        ),
      );

      final revAnimation = Tween<double>(
        begin: widget.end,
        end: widget.begin,
      ).animate(
        CurvedAnimation(
          curve: Interval(start + duration, start + duration * 2,
              curve: Curves.easeIn),
          parent: _controller,
        ),
      );
      _characters.add(_CharacterAnimation(
          text: character, forward: animation, reverse: revAnimation));
      start += duration;
    });

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.end;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _characters.map(
        (entry) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, widget) {
              return Transform.scale(
                scale: entry.forward.value >= end
                    ? entry.reverse.value
                    : entry.forward.value,
                child: Text(entry.text),
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
