import 'dart:ui';
import 'package:flutter/material.dart';

/// The model to describe a button to give to the LineSegmentedSelector
class LineSegmentedSelectorButton<T> {
  final String text;
  final T value;

  LineSegmentedSelectorButton({
    required this.text,
    required this.value
  });
}

/// A segmented selector with a line animation on selection change.
/// It can have N buttons and every buttons will take the same available width.
/// The height is given
class LineSegmentedSelector<T> extends StatefulWidget {
  /// List of the buttons to show
  final List<LineSegmentedSelectorButton<T>> buttons;

  /// Callback when the user tap on a button
  final void Function(T selectedValue) onSelectionChanged;

  /// The stroke width fo the line
  final double strokeWidth;

  /// The height of every buttons
  final double buttonsHeight;

  /// The border radius of the line around the selected button
  final double buttonsBorderRadius;

  /// The selected button. When this value it will be change the widget automatically run the animation.
  final T selectedValue;

  const LineSegmentedSelector({
    required this.buttons,
    required this.onSelectionChanged,
    required this.selectedValue,
    this.strokeWidth = 3,
    this.buttonsHeight = 30,
    this.buttonsBorderRadius = 10,
    Key? key
  }): assert(buttons.length > 0), super(key: key);

  @override
  State<LineSegmentedSelector<T>> createState() => _LineSegmentedSelectorState<T>();
}

class _LineSegmentedSelectorState<T> extends State<LineSegmentedSelector<T>> with SingleTickerProviderStateMixin {
  /// Main animation that controls all the other smaller animations
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  /// Animation that controls the line around the old selected button
  late final _oldSelectedAnimation = CurvedAnimation(
    parent: _animationController, 
    curve: const Interval(
      0, 1 / 3,
      curve: Curves.ease,
    ),
  );

  /// Animation that controls the line between the old and the new selected button
  late final _lineAnimation = CurvedAnimation(
    parent: _animationController, 
    curve: const Interval(
      (1 / 3) / 2, 2 / 3,
      curve: Curves.easeOut,
    ),
  );

  /// Animation that controls the line around the new selected button
  late final _newSelectedAnimation = CurvedAnimation(
    parent: _animationController, 
    curve: const Interval(
      1 / 3, 1,
      curve: Curves.ease,
    ),
  );

  int _oldIndex = 0;
  int _newIndex = 0;
  double _availableWidth = 0;
  double _buttonsWidth = 0;

  late Path _oldRectPath;
  late Path _newRectPath;

  @override
  void initState() {
    final selectedIndex = widget.buttons.indexWhere((x) => x.value == widget.selectedValue);
    _oldIndex = selectedIndex;
    _newIndex = selectedIndex;

    super.initState();
  }

  @override
  void didUpdateWidget(LineSegmentedSelector<T> oldWidget) {
    if (oldWidget.selectedValue != widget.selectedValue) {
      final newSelectedIndex = widget.buttons.indexWhere((x) => x.value == widget.selectedValue);
      _animateToValue(newSelectedIndex);
    }

    if(oldWidget.buttonsHeight != widget.buttonsHeight) {
      _calculatePaths(_oldIndex, _newIndex);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _oldSelectedAnimation.dispose();
    _lineAnimation.dispose();
    _newSelectedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth != _availableWidth) {
          _availableWidth = constraints.maxWidth;
          _calculatePaths(_oldIndex, _newIndex);
        }

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: _LineSegmentedSelectorPainter(
                oldAnimProgress: _oldSelectedAnimation.value,
                lineAnimProgress: _lineAnimation.value,
                newAnimProgress: _newSelectedAnimation.value,
                oldIndex: _oldIndex,
                newIndex: _newIndex,
                total: widget.buttons.length,
                borderRadius: widget.buttonsBorderRadius,
                color: theme.colorScheme.primary,
                newRectPath: _newRectPath,
                oldRectPath: _oldRectPath,
                strokeWidth: widget.strokeWidth
              ),
              child: child
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.buttons.length,
              (index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _onSelected(index),
                    child: Container(
                      width: _buttonsWidth,
                      height: widget.buttonsHeight,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        widget.buttons[index].text,
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }
  
  void _onSelected(int index) {
    widget.onSelectionChanged(widget.buttons[index].value); 
  }

  void _animateToValue(int index) {
    if(index == _newIndex) {
      return;
    }

    _calculatePaths(_newIndex, index);
    setState(() {
      _oldIndex = _newIndex;
      _newIndex = index;
    });

    _animationController.forward(from: 0);
  }

  void _calculatePaths(int oldIndex, int newIndex) {
    final direction = oldIndex > newIndex;
    _buttonsWidth = _availableWidth / widget.buttons.length;
    
    final oldRectStart = _buttonsWidth * oldIndex;
    final oldRectMiddle = oldRectStart + _buttonsWidth / 2;
    final oldRectEnd = oldRectStart + _buttonsWidth;
    _oldRectPath = _createPathRect(
      xStart: oldRectStart, 
      xMiddle: oldRectMiddle, 
      xEnd: oldRectEnd, 
      height: widget.buttonsHeight, 
      borderRadius: widget.buttonsBorderRadius,
      direction: !direction
    );

    final newRectStart = _buttonsWidth * newIndex;
    final newRectMiddle = newRectStart + _buttonsWidth / 2;
    final newRectEnd = newRectStart + _buttonsWidth;
    _newRectPath = _createPathRect(
      xStart: newRectStart, 
      xMiddle: newRectMiddle, 
      xEnd: newRectEnd, 
      height: widget.buttonsHeight, 
      borderRadius: widget.buttonsBorderRadius,
      direction: direction
    );
  }

  Path _createPathRect({
    required double xStart,
    required double xMiddle,
    required double xEnd,
    required double height,
    required double borderRadius,
    required bool direction
  }) {
    final path = Path();
    if(direction) {
      path.moveTo(xMiddle, height);
      path.lineTo(xStart + borderRadius, height);
      path.quadraticBezierTo(xStart, height, xStart, height - borderRadius);
      path.lineTo(xStart, borderRadius);
      path.quadraticBezierTo(xStart, 0, xStart + borderRadius, 0);
      path.lineTo(xEnd - borderRadius, 0);
      path.quadraticBezierTo(xEnd, 0, xEnd, borderRadius);
      path.lineTo(xEnd, height - borderRadius);
      path.quadraticBezierTo(xEnd, height, xEnd - borderRadius, height);
      path.lineTo(xMiddle, height);
    } else {
      path.moveTo(xMiddle, height);
      path.lineTo(xEnd - borderRadius, height);
      path.quadraticBezierTo(xEnd, height, xEnd, height - borderRadius);
      path.lineTo(xEnd, borderRadius);
      path.quadraticBezierTo(xEnd, 0, xEnd - borderRadius, 0);
      path.lineTo(xStart + borderRadius, 0);
      path.quadraticBezierTo(xStart, 0, xStart, borderRadius);
      path.lineTo(xStart, height - borderRadius);
      path.quadraticBezierTo(xStart, height, xStart + borderRadius, height);
      path.lineTo(xMiddle, height);
    }

    return path;
  }
}

class _LineSegmentedSelectorPainter extends CustomPainter {
  final double oldAnimProgress;
  final double lineAnimProgress;
  final double newAnimProgress;
  final int oldIndex;
  final int newIndex;
  final int total;
  final double borderRadius;
  final Color color;
  final double strokeWidth;

  final Path oldRectPath;
  final Path newRectPath;

  _LineSegmentedSelectorPainter({
    required this.oldAnimProgress,
    required this.lineAnimProgress,
    required this.newAnimProgress,
    required this.oldIndex,
    required this.newIndex,
    required this.total,
    required this.borderRadius,
    required this.color,
    required this.oldRectPath,
    required this.newRectPath,
    required this.strokeWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = color;

    final singleWidth = size.width / total;
    final oldRectMiddle = (singleWidth * oldIndex) + (singleWidth / 2); 
    final newRectMiddle = (singleWidth * newIndex) + ((singleWidth / 2));

    // This is necessary to transform 1 animation into 2 animations like this
    // |----------|----------|
    // 0          1          0
    final halfAnimation1 = lineAnimProgress <= 0.5 ? lerpDouble(0, 1, lineAnimProgress / 0.5)! : 1.0;
    final halfAnimation2 = lineAnimProgress > 0.5 ? lerpDouble(1, 0, (lineAnimProgress - 0.5) / 0.5)! : 0.0;
    
    final startLine = (lineAnimProgress <= 0.5) 
      ? oldRectMiddle
      : lerpDouble(newRectMiddle, oldRectMiddle, halfAnimation2)!;
    final endLine = (lineAnimProgress <= 0.5)
      ? lerpDouble(oldRectMiddle, newRectMiddle, halfAnimation1)!
      : newRectMiddle;

    final linePath = Path();
    linePath.moveTo(endLine, size.height);
    linePath.lineTo(startLine, size.height);

    canvas.drawPath(linePath, paint);
    final reverseOldAnimation = 1 - oldAnimProgress;
    canvas.drawPath(_createAnimatedPath(oldRectPath, reverseOldAnimation), paint);
    canvas.drawPath(_createAnimatedPath(newRectPath, newAnimProgress), paint);
  }
  
  static Path _createAnimatedPath(Path originalPath, double animationPercent) {
    final totalLength = originalPath.computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return _extractPathUntilLength(originalPath, currentLength);
  }

  static Path _extractPathUntilLength(Path originalPath, double length) {
    var currentLength = 0.0;

    final path = Path();

    final metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;

      final nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _LineSegmentedSelectorPainter oldDelegate) {
    return oldAnimProgress != oldDelegate.oldAnimProgress 
      || lineAnimProgress != oldDelegate.lineAnimProgress
      || newAnimProgress != oldDelegate.newAnimProgress
      || oldIndex != oldDelegate.oldIndex
      || newIndex != oldDelegate.newIndex
      || total != oldDelegate.total
      || borderRadius != oldDelegate.borderRadius
      || color != oldDelegate.color
      || strokeWidth != oldDelegate.strokeWidth
      || oldRectPath != oldDelegate.oldRectPath
      || newRectPath != oldDelegate.newRectPath;
  }
}
