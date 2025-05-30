import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Custom loading widget with various styles
class LoadingWidget extends StatelessWidget {
  final String? message;
  final LoadingType type;
  final LoadingSize size;
  final Color? color;
  final double? strokeWidth;
  final bool overlay;
  final Color? overlayColor;

  const LoadingWidget({
    super.key,
    this.message,
    this.type = LoadingType.circular,
    this.size = LoadingSize.medium,
    this.color,
    this.strokeWidth,
    this.overlay = false,
    this.overlayColor,
  });

  /// Circular loading constructor
  const LoadingWidget.circular({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
    this.color,
    this.strokeWidth,
    this.overlay = false,
    this.overlayColor,
  }) : type = LoadingType.circular;

  /// Linear loading constructor
  const LoadingWidget.linear({
    super.key,
    this.message,
    this.color,
    this.overlay = false,
    this.overlayColor,
  }) : type = LoadingType.linear,
        size = LoadingSize.medium,
        strokeWidth = null;

  /// Dots loading constructor
  const LoadingWidget.dots({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
    this.color,
    this.overlay = false,
    this.overlayColor,
  }) : type = LoadingType.dots,
        strokeWidth = null;

  /// Overlay loading constructor
  const LoadingWidget.overlay({
    super.key,
    this.message,
    this.type = LoadingType.circular,
    this.size = LoadingSize.medium,
    this.color,
    this.strokeWidth,
    this.overlayColor,
  }) : overlay = true;

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _buildLoadingWidget(context);

    if (overlay) {
      return _buildOverlay(context, loadingWidget);
    }

    return loadingWidget;
  }

  Widget _buildOverlay(BuildContext context, Widget loadingWidget) {
    return Container(
      color: overlayColor ?? Colors.black.withOpacity(0.5),
      child: Center(child: loadingWidget),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case LoadingType.circular:
        return _buildCircularLoading(theme);
      case LoadingType.linear:
        return _buildLinearLoading(theme);
      case LoadingType.dots:
        return _buildDotsLoading(theme);
    }
  }

  Widget _buildCircularLoading(ThemeData theme) {
    final content = <Widget>[];

    content.add(
      SizedBox(
        width: _getLoadingSize(),
        height: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? _getStrokeWidth(),
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );

    if (message != null) {
      content.add(const SizedBox(height: 16));
      content.add(_buildMessage(theme));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  }

  Widget _buildLinearLoading(ThemeData theme) {
    final content = <Widget>[];

    if (message != null) {
      content.add(_buildMessage(theme));
      content.add(const SizedBox(height: 16));
    }

    content.add(
      SizedBox(
        width: 200,
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
          backgroundColor: theme.colorScheme.surface,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  }

  Widget _buildDotsLoading(ThemeData theme) {
    final content = <Widget>[];

    content.add(_DotsLoadingIndicator(
      size: _getDotSize(),
      color: color ?? AppColors.primary,
    ));

    if (message != null) {
      content.add(const SizedBox(height: 16));
      content.add(_buildMessage(theme));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      message!,
      style: AppTextStyles.bodyMedium.copyWith(
        color: overlay
            ? Colors.white
            : theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  double _getLoadingSize() {
    switch (size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 32;
      case LoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  double _getDotSize() {
    switch (size) {
      case LoadingSize.small:
        return 6;
      case LoadingSize.medium:
        return 8;
      case LoadingSize.large:
        return 12;
    }
  }
}

/// Dots loading indicator animation
class _DotsLoadingIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const _DotsLoadingIndicator({
    required this.size,
    required this.color,
  });

  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimation();
  }

  void _startAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.25),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.3 + (0.7 * _animations[index].value)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

/// Loading types
enum LoadingType {
  circular,
  linear,
  dots,
}

/// Loading sizes
enum LoadingSize {
  small,
  medium,
  large,
}