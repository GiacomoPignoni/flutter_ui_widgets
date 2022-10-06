import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

const _handlerSize = 30.0;
const _handlerStrokeWidth = 4.0;
const _hitPadding = 10.0;
const _overDraw = 5;
const _height = _handlerSize + 6;
const middleY = _height / 2;
const _curveDistace = 120.0;

class FluidSlider extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;

  const FluidSlider({
    this.minValue = 0,
    this.maxValue = 100,
    this.value = 50,
    Key? key
  }) : super(key: key);

  @override
  State<FluidSlider> createState() => _FluidSliderState();
}

class _FluidSliderState extends State<FluidSlider> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500)
  );

  late final _curvedAnim = CurveTween(
    curve: const ElasticOutCurve(0.5)
  ).animate(_animationController);

  final _handlerPosition = ValueNotifier(const Offset(0, middleY));
   
  Offset _oldHandlerPosition = const Offset(0, middleY);
  bool _moving = false;
  double _maxWidth = 0;

  @override
  void dispose() {
    _animationController.dispose();
    _handlerPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        _maxWidth = constraints.maxWidth;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<Offset>(
                valueListenable: _handlerPosition,
                builder: (context, handlerPosition, child) {
                  return Text(
                    (handlerPosition.dx / (_maxWidth / widget.maxValue)).round().toString(),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                    ),
                  );
                }
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: _handlerSize + 6,
                width: double.infinity,
                child: Listener(
                  onPointerDown: _onPointerDown,
                  onPointerMove: _onPointerMove,
                  onPointerUp: _onPointerUp,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _animationController,
                      _handlerPosition
                    ]),
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _FluidSliderCustomPainter(
                          handlerSize: _handlerSize,
                          handlerPosition: _moving ? _handlerPosition.value : Offset(_oldHandlerPosition.dx, lerpDouble(_oldHandlerPosition.dy, middleY, _curvedAnim.value)!),
                          lineColor: theme.colorScheme.secondary,
                          handlerColor: theme.colorScheme.primary,
                          backgroundColor: theme.scaffoldBackgroundColor
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if(_isTouchingHandler(event.localPosition)) {
      _moving = true;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    final position = event.localPosition;

    if(_moving) {
      double finalX = _handlerPosition.value.dx;
      double finalY = _handlerPosition.value.dy;

      if(position.dx >= 0 && position.dx <= _maxWidth) {
        finalX = position.dx;
      }

      if(position.dy < _handlerSize + _overDraw && position.dy > -_overDraw) {
        finalY = position.dy;
      }

      _handlerPosition.value = Offset(
        finalX,
        finalY
      );
    }
  }

  Future<void> _onPointerUp(PointerUpEvent event) async {
    _moving = false;
    if(_oldHandlerPosition != _handlerPosition.value) {
      _oldHandlerPosition = Offset(_handlerPosition.value.dx, _handlerPosition.value.dy);

      await _animationController.forward();
      _oldHandlerPosition = Offset(_handlerPosition.value.dx, middleY);
      _handlerPosition.value = _oldHandlerPosition;
      _animationController.reset();
    }
  }

  bool _isTouchingHandler(Offset position) {
    if(
      position.dx >= _handlerPosition.value.dx - _hitPadding
      && position.dx <= _handlerPosition.value.dx + _handlerSize + _hitPadding
      && position.dy >= _handlerPosition.value.dy - _hitPadding
      && position.dy <= _handlerPosition.value.dy + _handlerSize + _hitPadding
    ) {
      return true;
    }

    return false;
  }
}

class _FluidSliderCustomPainter extends CustomPainter {
  final double handlerSize;
  final Offset handlerPosition;

  final Color lineColor;
  final Color handlerColor;
  final Color backgroundColor;

  _FluidSliderCustomPainter({
    required this.handlerSize,
    required this.handlerPosition,
    required this.lineColor,
    required this.handlerColor,
    required this.backgroundColor
  });

  @override
  void paint(Canvas canvas, Size size) {
    final handlerPaint = Paint()
      ..color = handlerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _handlerStrokeWidth;

    final handlerBackgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final middleY = size.height / 2;
    final handlerRadius = handlerSize / 2;

    final linePath = Path();
    linePath.moveTo(0, middleY);
    linePath.lineTo(max(handlerPosition.dx - _curveDistace, 0), middleY);
    linePath.cubicTo(
      max(handlerPosition.dx - (_curveDistace / 2), 0), 
      middleY, 
      max(handlerPosition.dx - (_curveDistace / 2), 0), 
      handlerPosition.dy, 
      handlerPosition.dx,
      handlerPosition.dy
    );
    linePath.cubicTo(
      min(handlerPosition.dx + (_curveDistace / 2), size.width), 
      handlerPosition.dy, 
      min(handlerPosition.dx + (_curveDistace / 2), size.width), 
      middleY,
      min(handlerPosition.dx + _curveDistace, size.width),
      middleY
    );
    linePath.lineTo(size.width, middleY);

    canvas.drawPath(linePath, linePaint);
    canvas.drawCircle(handlerPosition, handlerRadius, handlerBackgroundPaint);
    canvas.drawCircle(handlerPosition, handlerRadius, handlerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
