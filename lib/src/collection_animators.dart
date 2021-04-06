import 'package:flutter/material.dart';

/// Adds a reversable and repetitive slide transition to each child.
///
/// This widget arranges its [children] in a row and applies forward and
/// reverse animations to each child.
///
/// The animation can be played once or forever and is controlled
/// through [repeat] property.
class CollectionSlideTransition extends StatefulWidget {
  /// Collection of widgets on which slide animation is applied.
  ///
  /// Preferably, [Text], [Icon] or [Image] should be used.
  final List<Widget> children;

  /// End displacement for each child.
  final Offset end;

  /// Start of displacement.
  ///
  /// This is immutable field.
  final Offset begin = Offset.zero;

  /// The toggle to make the animation repeating or non-repeating.
  final bool repeat;

  /// Creates transiton widget.
  ///
  /// [children] is requied and must not be null.
  /// [end] property has default displacement of -1.0 in vertical direction.
  CollectionSlideTransition({
    required this.children,
    this.end = const Offset(0.0, -1.0),
    this.repeat = true,
  });

  @override
  _CollectionSlideTransitionState createState() =>
      new _CollectionSlideTransitionState();
}

class _CollectionSlideTransitionState extends State<CollectionSlideTransition>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  List<_WidgetAnimations<Offset>> _widgets = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.children.length * 0.25).round()),
    );

    _widgets = _WidgetAnimations.createList<Offset>(
      widgets: widget.children,
      controller: _controller,
      forwardCurve: Curves.ease,
      reverseCurve: Curves.ease,
      begin: widget.begin,
      end: widget.end,
    );

    if (widget.repeat) {
      _controller!.repeat();
    } else {
      _controller!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.end;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _widgets.map(
        (widgetAnimation) {
          return AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) {
              return FractionalTranslation(
                translation: widgetAnimation.forward!.value.distanceSquared >=
                        end.distanceSquared
                    ? widgetAnimation.reverse!.value
                    : widgetAnimation.forward!.value,
                child: widgetAnimation.widget,
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

/// Adds a reversable and repetitive scale transition to each child.
///
/// This widget arranges its [children] in a row and applies forward and
/// reverse animations to each child.
///
/// The animation can be played once or forever and is controlled
/// through [repeat] property.
class CollectionScaleTransition extends StatefulWidget {
  /// Collection of widgets on which slide animation is applied.
  ///
  /// Preferably, [Text], [Icon] or [Image] should be used.
  final List<Widget> children;

  /// End scale of each child.
  final double end;

  /// Start scale of each child.
  final double begin = 1.0;

  /// The toggle to make the animation repeating or non-repeating.
  final bool repeat;

  /// Creates transiton widget.
  ///
  /// [children] is requied and must not be null.
  /// [end] property has default value of 2.0.
  CollectionScaleTransition({
    required this.children,
    this.end = 2.0,
    this.repeat = true,
  });

  @override
  _CollectionScaleTransitionState createState() =>
      new _CollectionScaleTransitionState();
}

class _CollectionScaleTransitionState extends State<CollectionScaleTransition>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  List<_WidgetAnimations<double>> _widgets = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.children.length * 0.25).round()),
    );

    _widgets = _WidgetAnimations.createList<double>(
      widgets: widget.children,
      controller: _controller,
      forwardCurve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
      begin: widget.begin,
      end: widget.end,
    );

    if (widget.repeat) {
      _controller!.repeat();
    } else {
      _controller!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.end;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _widgets.map(
        (widgetAnimation) {
          return AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) {
              return Transform.scale(
                scale: widgetAnimation.forward!.value >= end
                    ? widgetAnimation.reverse!.value
                    : widgetAnimation.forward!.value,
                child: widgetAnimation.widget,
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

class _WidgetAnimations<T> {
  final Widget? widget;
  final Animation<T>? forward;
  final Animation<T>? reverse;

  _WidgetAnimations({this.widget, this.forward, this.reverse});

  static List<_WidgetAnimations<S>> createList<S>({
    required List<Widget> widgets,
    required AnimationController? controller,
    Cubic forwardCurve = Curves.ease,
    Cubic reverseCurve = Curves.ease,
    S? begin,
    S? end,
  }) {
    final animations = <_WidgetAnimations<S>>[];

    var start = 0.0;
    final duration = 1.0 / (widgets.length * 2);
    widgets.forEach((childWidget) {
      final animation = Tween<S>(
        begin: begin,
        end: end,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.ease),
          parent: controller!,
        ),
      );

      final revAnimation = Tween<S>(
        begin: end,
        end: begin,
      ).animate(
        CurvedAnimation(
          curve: Interval(start + duration, start + duration * 2,
              curve: Curves.ease),
          parent: controller,
        ),
      );

      animations.add(_WidgetAnimations(
        widget: childWidget,
        forward: animation,
        reverse: revAnimation,
      ));

      start += duration;
    });

    return animations;
  }
}
