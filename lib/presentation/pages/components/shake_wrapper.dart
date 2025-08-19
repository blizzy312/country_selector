import 'package:flutter/material.dart';

class ShakeWrapper extends StatefulWidget {
  final Widget child;
  final bool shouldShake;
  final Duration duration;
  final double intensity;
  final VoidCallback? onShakeDone;

  const ShakeWrapper({
    super.key,
    required this.child,
    required this.shouldShake,
    this.duration = const Duration(milliseconds: 500),
    this.intensity = 10.0,
    this.onShakeDone,
  });

  @override
  State<ShakeWrapper> createState() => _ShakeWrapperState();
}

class _ShakeWrapperState extends State<ShakeWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ))..addStatusListener( (status) {
      if (status == AnimationStatus.dismissed ) {
        widget.onShakeDone?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ShakeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _triggerShake();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward().then((_) {
      if (mounted) {
        _shakeController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * widget.intensity * 
                ((_shakeAnimation.value * 4).round() % 2 == 0 ? 1 : -1),
            0,
          ),
          child: widget.child,
        );
      },
    );
  }
}