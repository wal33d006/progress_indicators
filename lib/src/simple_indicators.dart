import 'package:flutter/material.dart';

/// Adds a heartbeat animation to its child widget.
///
/// The animation is repeated continuously.
class HeartbeatProgressIndicator extends StatefulWidget {
  /// The duration of animation playback for each iteration.
  final Duration duration;

  /// Starting scale of child widget. Normally, it should be 1.0.
  final double startScale;

  /// Ending scale of child widget.
  final double endScale;

  /// Widget to apply the animation to.
  final Widget child;

  /// Creates heartbeat indicator.
  ///
  /// [child] widget must not be null.
  /// [startScale] is optional and default value is 1.0.
  /// [endScale] is optional and default value is 2.0.
  /// [duration] is optional and default value is 1 second.
  HeartbeatProgressIndicator({
    this.duration = const Duration(seconds: 1),
    this.startScale: 1.0,
    this.endScale: 2.0,
    @required this.child,
  }) : assert(child != null);

  @override
  _HeartbeatProgressIndicatorState createState() =>
      _HeartbeatProgressIndicatorState();
}

class _HeartbeatProgressIndicatorState extends State<HeartbeatProgressIndicator>
    with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  initState() {
    super.initState();
    _controller = _createOscillatingAnimationController(widget.duration, this);
    _animation = _createTweenAnimation(
      _controller,
      begin: widget.startScale,
      end: widget.endScale,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _animation, child: widget.child);

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Adds a glowing animation to its child widget.
///
/// The animation is repeated continuously.
class GlowingProgressIndicator extends StatefulWidget {
  /// The duration of animation playback for each iteration.
  final Duration duration;

  /// Widget to apply the animation to.
  final Widget child;

  /// Creates glowing indicator.
  ///
  /// [child] widget must not be null.
  /// [duration] is optional and default value is 1 second.
  GlowingProgressIndicator({
    this.duration = const Duration(seconds: 1),
    @required this.child,
  }) : assert(child != null);

  @override
  _GlowingProgressIndicatorState createState() =>
      _GlowingProgressIndicatorState();
}

class _GlowingProgressIndicatorState extends State<GlowingProgressIndicator>
    with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  initState() {
    super.initState();
    _controller = _createOscillatingAnimationController(widget.duration, this);
    _animation = _createTweenAnimation(
      _controller,
      begin: 0.0,
      end: 1.0,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _animation, child: widget.child);

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

AnimationController _createOscillatingAnimationController(
  Duration duration,
  TickerProvider provider,
) {
  final AnimationController controller =
      AnimationController(duration: duration, vsync: provider);
  controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
  });
  return controller;
}

Animation _createTweenAnimation(
  AnimationController controller, {
  double begin: 1.0,
  double end: 2.0,
  Curve curve: Curves.easeOut,
}) {
  return Tween(begin: begin, end: end)
      .animate(CurvedAnimation(parent: controller, curve: curve));
}
