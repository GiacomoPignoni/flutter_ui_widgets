import 'dart:ui';
import 'package:flutter/material.dart';

/// A model to describe a button to give to the [CupertioStyleSegmentedSelector]
class CupertioStyleSegmentedSelectorButton<T> {
  final String text;
  final T value;
  final IconData icon;

  CupertioStyleSegmentedSelectorButton({
    required this.text,
    required this.value,
    required this.icon
  });
}

/// A Cupertino style segmented selector with a (maybe) cool animation on selection change
/// The width of every buttons is calculated based on the available max width
/// The height of every buttons is calculated base on the font size + vericalInternalPadding 
class CupertioStyleSegmentedSelector<T> extends StatefulWidget {
  /// List of the buttons to show
  final List<CupertioStyleSegmentedSelectorButton<T>> buttons;

  /// Callback when the user tap on a button
  final void Function(T selectedValue) onSelectionChanged;

  /// The selected value. 
  /// When this value it will be change the widget automatically run the animation to match the selection.
  final T selectedValue;

  /// Border radius to the selected button
  final double borderRadius;

  /// Padding added to the top and the bottom of the text inside a button
  final double vericalInternalPadding;

  const CupertioStyleSegmentedSelector({
    required this.buttons,
    required this.onSelectionChanged,
    required this.selectedValue,
    this.borderRadius = 10,
    this.vericalInternalPadding = 20,
    Key? key
  }): assert(buttons.length > 0), super(key: key);

  @override
  State<CupertioStyleSegmentedSelector<T>> createState() => _CupertioStyleSegmentedSelectorState<T>();
}

class _CupertioStyleSegmentedSelectorState<T> extends State<CupertioStyleSegmentedSelector<T>> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final _firstHalfAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInQuart)),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: ConstantTween(1),
      weight: 50,
    )
  ]).animate(_animationController);

  late final _secondHalfAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: ConstantTween(0),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutQuart)),
      weight: 50,
    )
  ]).animate(_animationController);

  int _currentIndex = 0;
  int _oldIndex = 0;

  @override
  void initState() {
    final selectedIndex = widget.buttons.indexWhere((x) => x.value == widget.selectedValue);
    _currentIndex = selectedIndex;
    _oldIndex = selectedIndex;

    super.initState();
  }

  @override
  void didUpdateWidget(CupertioStyleSegmentedSelector<T> oldWidget) {
    if (oldWidget.selectedValue != widget.selectedValue) {
      final newSelectedIndex = widget.buttons.indexWhere((x) => x.value == widget.selectedValue);
      _animateToValue(newSelectedIndex);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth / widget.buttons.length;
        final height = (theme.textTheme.bodyText1?.fontSize ?? 20) + widget.vericalInternalPadding;
    
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(widget.borderRadius)
          ), 
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: _CupertioStyleSegmentedSelectorPainter(
                  color: theme.colorScheme.primary,
                  buttonWidth: buttonWidth,
                  oldIndex: _oldIndex,
                  newIndex: _currentIndex,
                  borderRadius: widget.borderRadius,
                  lastAndFirstSwitch: _lastAndFirstSwitch(),
                  firstHalfAnimProgress: _firstHalfAnimation.value,
                  secondHalfAnimProgress: _secondHalfAnimation.value
                ),
                child: child
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.buttons.length, 
                (index) {
                  final button = widget.buttons[index];
                  final isSelected = index == _currentIndex;
                  final color = (isSelected) ? theme.colorScheme.onPrimary : theme.textTheme.bodyText1!.color!;

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => widget.onSelectionChanged(button.value),
                      child: Container(
                        width: buttonWidth,
                        height: height,
                        color: Colors.transparent,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInQuart,
                          style: theme.textTheme.bodyText1!.copyWith(color: color),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImplicitlyAnimatedIcon(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInQuart,
                                icon: button.icon,
                                color: color,
                                size: 22,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                button.text,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } 
              ),
            ),
          )
        );
      }
    );
  }

  bool _lastAndFirstSwitch() {
    if(widget.buttons.length <= 2) {
      return false;
    } else {
      return (_currentIndex == 0 && _oldIndex == widget.buttons.length - 1) 
        || (_currentIndex == widget.buttons.length - 1 && _oldIndex == 0);
    }
  }

  void _animateToValue(int newIndex) {
    if(newIndex == _currentIndex) {
      return;
    }

    setState(() {
      _oldIndex = _currentIndex;
      _currentIndex = newIndex;
    });

    _animationController.forward(from: 0);
  }
}

/// The [CustomPainter] used by [CupertioStyleSegmentedSelector]
/// 
/// It's used to draw the colored rectangle. 
/// It also takes care to animate the rectangle movement
class _CupertioStyleSegmentedSelectorPainter extends CustomPainter {
  final Color color;
  final double buttonWidth;
  final int oldIndex;
  final int newIndex;
  final double borderRadius;
  final bool lastAndFirstSwitch;
  final double firstHalfAnimProgress;
  final double secondHalfAnimProgress;

  _CupertioStyleSegmentedSelectorPainter({
    required this.color,
    required this.buttonWidth,
    required this.oldIndex,
    required this.newIndex,
    required this.borderRadius,
    required this.lastAndFirstSwitch,
    required this.firstHalfAnimProgress,
    required this.secondHalfAnimProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color;

    final direction = oldIndex < newIndex;

    final double rightStart = buttonWidth * (oldIndex + 1);
    final double rightEnd = buttonWidth * (newIndex + 1);
    final double leftStart = buttonWidth * oldIndex; 
    final double leftEnd = buttonWidth * newIndex; 

    if(lastAndFirstSwitch) {
      late final double firstRight;
      late final double firstLeft;
      late final double secondRight;
      late final double secondLeft;

      if(direction) {
        firstRight = lerpDouble(rightStart, 0, firstHalfAnimProgress)!;
        firstLeft = leftStart;
        secondRight = rightEnd;
        secondLeft = lerpDouble(leftEnd + buttonWidth, leftEnd, secondHalfAnimProgress)!;
      } else {
        firstRight = leftStart + buttonWidth;
        firstLeft = lerpDouble(leftStart, leftStart + buttonWidth, firstHalfAnimProgress)!;
        secondRight = lerpDouble(0, rightEnd, secondHalfAnimProgress)!;
        secondLeft = 0;
      }

      canvas.drawRRect(
        RRect.fromLTRBR(
          firstLeft,
          0,
          firstRight,
          size.height,
          Radius.circular(borderRadius)
        ), 
        paint
      );

      canvas.drawRRect(
        RRect.fromLTRBR(
          secondLeft,
          0,
          secondRight,
          size.height,
          Radius.circular(borderRadius)
        ), 
        paint
      );
    } else {
      late final double right;
      late final double left;

      if(direction) {
        right = lerpDouble(rightStart, rightEnd, firstHalfAnimProgress)!;
        left = lerpDouble(leftStart, leftEnd, secondHalfAnimProgress)!;
      } else {
        left = lerpDouble(leftStart, leftEnd, firstHalfAnimProgress)!;
        right = lerpDouble(rightStart, rightEnd, secondHalfAnimProgress)!;
      }

      canvas.drawRRect(
        RRect.fromLTRBR(
          left,
          0,
          right,
          size.height,
          Radius.circular(borderRadius)
        ), 
        paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CupertioStyleSegmentedSelectorPainter oldDelegate) {
    return color != oldDelegate.color
      || buttonWidth != oldDelegate.buttonWidth
      || oldIndex != oldDelegate.oldIndex
      || newIndex != oldDelegate.newIndex
      || firstHalfAnimProgress != oldDelegate.firstHalfAnimProgress
      || secondHalfAnimProgress != oldDelegate.secondHalfAnimProgress
      || lastAndFirstSwitch != oldDelegate.lastAndFirstSwitch;
  }
}

class ImplicitlyAnimatedIcon extends ImplicitlyAnimatedWidget {
  final IconData icon;
  final Color color;
  final double? size;

  const ImplicitlyAnimatedIcon({
    required super.duration,
    required this.color,
    required this.icon,
    this.size,
    super.curve = Curves.ease,
    super.key, 
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _ImplicitlyAnimatedIconState();
}

class _ImplicitlyAnimatedIconState extends AnimatedWidgetBaseState<ImplicitlyAnimatedIcon> {
  ColorTween? _color;
  Tween<double>? _size;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(_color, widget.color, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _size = visitor(_size, widget.size, (dynamic value) => Tween<double>(begin: value as double)) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      color: _color?.evaluate(animation),
      size: _size?.evaluate(animation)
    );
  }
}