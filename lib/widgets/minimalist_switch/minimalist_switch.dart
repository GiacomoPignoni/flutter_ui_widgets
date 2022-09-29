import 'dart:ui';
import 'package:flutter/material.dart';

class MinimalistSwitch extends StatefulWidget {
  final bool checked;
  final void Function(bool newValue) onCheckedChange;

  const MinimalistSwitch({
    required this.checked,
    required this.onCheckedChange,
    Key? key
  }) : super(key: key);

  @override
  State<MinimalistSwitch> createState() => _MinimalistSwitchState();
}

class _MinimalistSwitchState extends State<MinimalistSwitch> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final _curvedAnimation = CurvedAnimation(
    parent: _animationController, 
    curve: const ElasticOutCurve(0.8),
    reverseCurve: const ElasticInCurve(0.8),
  );

  @override
  void didUpdateWidget(MinimalistSwitch oldWidget) {
    if(widget.checked != oldWidget.checked) {
      _animateToValue(widget.checked);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              size: const Size(70, 35),
              painter: _AnimatedSwitch2CustomPainter(
                color: theme.colorScheme.primary,
                lineColor: theme.colorScheme.secondary,
                backgroundColor: theme.scaffoldBackgroundColor,
                animationProgress: _curvedAnimation.value
              ),
            );
          },
        )
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

class _AnimatedSwitch2CustomPainter extends CustomPainter {
  final double borderWidth = 6;

  final Color color;
  final Color lineColor;
  final Color backgroundColor;
  final double animationProgress;

  _AnimatedSwitch2CustomPainter({
    required this.color,
    required this.lineColor,
    required this.backgroundColor,
    required this.animationProgress
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    
    final frontCirclePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final backCirclePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = size.width / 4;
    final centerY = size.height / 2;   

    final frontCircleRadius = lerpDouble(radius - borderWidth, 0, animationProgress)!;
    final circleXPosition = lerpDouble(radius, radius * 3, animationProgress)!;

    canvas.drawLine(Offset(radius - borderWidth, centerY), Offset(size.width - radius + borderWidth, centerY), linePaint);
    canvas.drawCircle(Offset(circleXPosition, centerY), radius + 4, frontCirclePaint);
    canvas.drawCircle(Offset(circleXPosition, centerY), radius, backCirclePaint);
    canvas.drawCircle(Offset(circleXPosition, centerY), frontCircleRadius, frontCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
