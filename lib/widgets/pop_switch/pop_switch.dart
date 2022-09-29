import 'dart:ui';
import 'package:flutter/material.dart';

class PopSwitch extends StatefulWidget {
  final bool checked;
  final void Function(bool newValue) onCheckedChange;

  const PopSwitch({
    required this.checked,
    required this.onCheckedChange,
    Key? key
  }) : super(key: key);

  @override
  State<PopSwitch> createState() => _PopSwitchState();
}

class _PopSwitchState extends State<PopSwitch> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final _firstHalfAnimation = CurvedAnimation(
    curve: Curves.easeInQuart,
    reverseCurve: Curves.elasticIn, 
    parent: TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1),
        weight: 50,
      )
    ]).animate(_animationController)
  );

  late final _secondHalfAnimation = CurvedAnimation(
    curve: Curves.elasticOut,
    reverseCurve: Curves.easeOutQuart,
    parent: TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 50,
      )
    ]).animate(_animationController), 
  );

  @override
  void didUpdateWidget(PopSwitch oldWidget) {
    if(widget.checked != oldWidget.checked) {
      _animateToValue(widget.checked);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstHalfAnimation.dispose();
    _secondHalfAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onCheckedChange(!widget.checked);
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              foregroundPainter: _AnimatedSwitchCustomPainter(
                color: theme.colorScheme.primary,
                overflow: 3,
                onColor: theme.colorScheme.onPrimary,
                offColor: theme.colorScheme.onSecondary,
                firstHalfAnimProgress: _firstHalfAnimation.value,
                secondHalfAnimProgress: _secondHalfAnimation.value,
              ),
              child: child
            );
          },
          child: Container(
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(20)
            ),
          ),
        ),
      ),
    );
  }

  void _animateToValue(bool newValue) {
    if(newValue) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}

class _AnimatedSwitchCustomPainter extends CustomPainter {
  final Color color;
  final double overflow;
  final Color onColor;
  final Color offColor;
  final double firstHalfAnimProgress;
  final double secondHalfAnimProgress;

  _AnimatedSwitchCustomPainter({
    required this.color,
    required this.overflow,
    required this.onColor,
    required this.offColor,
    required this.firstHalfAnimProgress,
    required this.secondHalfAnimProgress
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final radius = (size.width / 4);
    final left = lerpDouble(-overflow, (radius * 2) - overflow, secondHalfAnimProgress)!;
    final top = -overflow;
    final right = lerpDouble((radius * 2) + overflow, size.width + overflow, firstHalfAnimProgress)!;
    final bottom = size.height + overflow;

    canvas.drawRRect(
      RRect.fromLTRBR(
        left,
        top,
        right,
        bottom,
        Radius.circular(radius + overflow)
      ), 
      paint
    );

    final leftColor = Color.lerp(onColor, offColor, firstHalfAnimProgress)!;
    final rightColor = Color.lerp(offColor, onColor, firstHalfAnimProgress)!;
    
    canvas.drawCircle(Offset(radius, size.height / 2), 6, strokePaint..color = leftColor);
    canvas.drawLine(Offset(size.width - radius, 13), Offset(size.width - radius, size.height - 13), strokePaint..color = rightColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
