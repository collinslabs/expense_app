import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationProperties>()
      ..add(AnimationProperties.opacity, Tween<double>(begin: 0.0, end: 1.0), const Duration(milliseconds: 500))
      ..add(AnimationProperties.translateY, Tween<double>(begin: -130.0, end: 0.0), const Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AnimationProperties>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AnimationProperties.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(AnimationProperties.translateY)),
          child: child,
        ),
      ),
    );
  }
}

enum AnimationProperties { opacity, translateY }
