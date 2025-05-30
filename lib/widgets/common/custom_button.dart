import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Custom button widget with various styles and states
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.suffixIcon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.textStyle,
    this.width,
    this.height,
  });

  /// Primary button constructor
  const CustomButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.suffixIcon,
    this.borderRadius,
    this.width,
    this.height,
    this.backgroundColor,
  }) : type = ButtonType.primary,
        textColor = null,
        borderColor = null,
        padding = null,
        elevation = null,
        textStyle = null;

  /// Secondary button constructor
  const CustomButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.suffixIcon,
    this.borderRadius,
    this.width,
    this.height,
  }) : type = ButtonType.secondary,
        backgroundColor = null,
        textColor = null,
        borderColor = null,
        padding = null,
        elevation = null,
        textStyle = null;

  /// Outline button constructor
  const CustomButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.suffixIcon,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.width,
    this.height,
  }) : type = ButtonType.outline,
        backgroundColor = null,
        padding = null,
        elevation = null,
        textStyle = null;

  /// Text button constructor
  const CustomButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.suffixIcon,
    this.textColor,
    this.borderRadius,
    this.width,
    this.height,
  }) : type = ButtonType.text,
        backgroundColor = null,
        borderColor = null,
        padding = null,
        elevation = null,
        textStyle = null;

  /// Social button constructor
  const CustomButton.social({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.width,
    this.height,
  }) : type = ButtonType.social,
        suffixIcon = null,
        padding = null,
        elevation = null,
        textStyle = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !isEnabled || isLoading;

    return SizedBox(
      width: width,
      height: height ?? _getButtonHeight(),
      child: _buildButton(context, theme, isDisabled),
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, bool isDisabled) {
    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton(context, theme, isDisabled);
      case ButtonType.secondary:
        return _buildSecondaryButton(context, theme, isDisabled);
      case ButtonType.outline:
        return _buildOutlineButton(context, theme, isDisabled);
      case ButtonType.text:
        return _buildTextButton(context, theme, isDisabled);
      case ButtonType.social:
        return _buildSocialButton(context, theme, isDisabled);
    }
  }

  Widget _buildElevatedButton(BuildContext context, ThemeData theme, bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? Colors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        elevation: elevation ?? (type == ButtonType.primary ? 2 : 0),
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        padding: padding ?? _getButtonPadding(),
        textStyle: textStyle ?? _getTextStyle(),
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, ThemeData theme, bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.secondary,
        foregroundColor: textColor ?? Colors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        elevation: elevation ?? 1,
        shadowColor: AppColors.secondary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        padding: padding ?? _getButtonPadding(),
        textStyle: textStyle ?? _getTextStyle(),
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlineButton(BuildContext context, ThemeData theme, bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        disabledForegroundColor: AppColors.grey500,
        side: BorderSide(
          color: isDisabled ? AppColors.grey300 : (borderColor ?? AppColors.primary),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        padding: padding ?? _getButtonPadding(),
        textStyle: textStyle ?? _getTextStyle(),
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context, ThemeData theme, bool isDisabled) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        disabledForegroundColor: AppColors.grey500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        padding: padding ?? _getButtonPadding(),
        textStyle: textStyle ?? _getTextStyle(),
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSocialButton(BuildContext context, ThemeData theme, bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: textColor ?? AppColors.grey800,
        disabledBackgroundColor: AppColors.grey200,
        disabledForegroundColor: AppColors.grey500,
        elevation: elevation ?? 1,
        shadowColor: AppColors.grey400.withOpacity(0.3),
        side: BorderSide(
          color: borderColor ?? AppColors.grey300,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        padding: padding ?? _getButtonPadding(),
        textStyle: textStyle ?? _getTextStyle(),
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: _getLoadingSize(),
        height: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary || type == ButtonType.secondary
                ? Colors.white
                : AppColors.primary,
          ),
        ),
      );
    }

    final children = <Widget>[];

    if (icon != null) {
      children.add(icon!);
      if (text.isNotEmpty) {
        children.add(SizedBox(width: _getIconSpacing()));
      }
    }

    if (text.isNotEmpty) {
      children.add(
        Flexible(
          child: Text(
            text,
            style: _getTextStyle(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    if (suffixIcon != null) {
      if (text.isNotEmpty || icon != null) {
        children.add(SizedBox(width: _getIconSpacing()));
      }
      children.add(suffixIcon!);
    }

    if (children.length == 1) {
      return children.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  EdgeInsetsGeometry _getButtonPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall;
      case ButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case ButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 10;
    }
  }
}

/// Button types
enum ButtonType {
  primary,
  secondary,
  outline,
  text,
  social,
}

/// Button sizes
enum ButtonSize {
  small,
  medium,
  large,
}