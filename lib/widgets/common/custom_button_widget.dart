import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Simple, flexible button widget with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final Color? color;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: _getHeight(),
      child: _buildButton(context, isDark),
    );
  }

  Widget _buildButton(BuildContext context, bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton(context, isDark);
      case ButtonType.secondary:
        return _buildOutlinedButton(context, isDark);
      case ButtonType.text:
        return _buildTextButton(context, isDark);
    }
  }

  Widget _buildElevatedButton(BuildContext context, bool isDark) {
    return ElevatedButton(
      onPressed: _isButtonEnabled() ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? (isDark ? AppColors.primaryLight : AppColors.primary),
        foregroundColor: isDark ? AppColors.grey900 : Colors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        elevation: type == ButtonType.primary ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: _getPadding(),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDark) {
    final buttonColor = color ?? (isDark ? AppColors.primaryLight : AppColors.primary);

    return OutlinedButton(
      onPressed: _isButtonEnabled() ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        disabledForegroundColor: AppColors.grey400,
        side: BorderSide(
          color: _isButtonEnabled() ? buttonColor : AppColors.grey300,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: _getPadding(),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDark) {
    final buttonColor = color ?? (isDark ? AppColors.primaryLight : AppColors.primary);

    return TextButton(
      onPressed: _isButtonEnabled() ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: buttonColor,
        disabledForegroundColor: AppColors.grey400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: _getPadding(),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary ? Colors.white : AppColors.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text, style: _getTextStyle()),
        ],
      );
    }

    return Text(text, style: _getTextStyle());
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
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

  bool _isButtonEnabled() {
    return isEnabled && !isLoading && onPressed != null;
  }
}

enum ButtonType { primary, secondary, text }
enum ButtonSize { small, medium, large }