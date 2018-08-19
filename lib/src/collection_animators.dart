import 'package:flutter/material.dart';

class CollectionSlideTransition extends StatefulWidget {
  final List<Widget> children;
  final Offset end;
  final Offset begin = Offset.zero;
  final bool repeat;

  CollectionSlideTransition({
    @required this.children,
    this.end = const Offset(0.0, -1.0),
    this.repeat = true,
  });

  @override
  _CollectionSlideTransitionState createState() =>
      new _CollectionSlideTransitionState();
}

class _CollectionSlideTransitionState extends State<CollectionSlideTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
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
      _controller.repeat();
    } else {
      _controller.forward();
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
            animation: _controller,
            builder: (context, _) {
              return FractionalTranslation(
                translation: widgetAnimation.forward.value.distanceSquared >=
                        end.distanceSquared
                    ? widgetAnimation.reverse.value
                    : widgetAnimation.forward.value,
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
    _controller.dispose();
    super.dispose();
  }
}

class CollectionScaleTransition extends StatefulWidget {
  final List<Widget> children;
  final double end;
  final double begin = 1.0;
    final bool repeat;

  CollectionScaleTransition({
    @required this.children,
    this.end = 2.0,
    this.repeat = true,
  });

  @override
  _CollectionScaleTransitionState createState() =>
      new _CollectionScaleTransitionState();
}

class _CollectionScaleTransitionState extends State<CollectionScaleTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
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
      _controller.repeat();
    } else {
      _controller.forward();
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
            animation: _controller,
            builder: (context, _) {
              return Transform.scale(
                scale: widgetAnimation.forward.value >= end
                    ? widgetAnimation.reverse.value
                    : widgetAnimation.forward.value,
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
    _controller.dispose();
    super.dispose();
  }
}

class _WidgetAnimations<T> {
  final Widget widget;
  final Animation<T> forward;
  final Animation<T> reverse;

  _WidgetAnimations({this.widget, this.forward, this.reverse});

  static List<_WidgetAnimations<S>> createList<S>({
    @required List<Widget> widgets,
    @required AnimationController controller,
    Cubic forwardCurve = Curves.ease,
    Cubic reverseCurve = Curves.ease,
    S begin,
    S end,
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
          parent: controller,
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
