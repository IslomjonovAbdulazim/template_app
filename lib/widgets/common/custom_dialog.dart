import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'custom_button_widget.dart';

/// Simple, flexible dialog widget with consistent styling
class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<DialogAction>? actions;
  final IconData? icon;
  final Color? iconColor;
  final bool barrierDismissible;
  final EdgeInsets? contentPadding;

  const CustomDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.barrierDismissible = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: contentPadding ?? const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
            if (message != null) ...[
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            if (content != null) ...[
              content!,
              const SizedBox(height: 20),
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              if (actions!.length == 1)
                SizedBox(
                  width: double.infinity,
                  child: _buildActionButton(actions!.first),
                )
              else
                Row(
                  children: actions!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final action = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index > 0 ? 8 : 0,
                          right: index < actions!.length - 1 ? 8 : 0,
                        ),
                        child: _buildActionButton(action),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(DialogAction action) {
    return CustomButton(
      text: action.text,
      onPressed: action.onPressed,
      type: action.isPrimary ? ButtonType.primary : ButtonType.secondary,
      size: ButtonSize.medium,
    );
  }

  /// Show custom dialog
  static Future<T?> show<T>({
    String? title,
    String? message,
    Widget? content,
    List<DialogAction>? actions,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<T>(
      CustomDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}

/// Dialog action model
class DialogAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;

  DialogAction({
    required this.text,
    this.onPressed,
    this.isPrimary = false,
  });
}

/// Pre-built dialog types
class ConfirmationDialog {
  static Future<bool> show({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    Color? iconColor,
  }) async {
    final result = await CustomDialog.show<bool>(
      title: title,
      message: message,
      icon: icon ?? Icons.help_outline,
      iconColor: iconColor ?? AppColors.warning,
      actions: [
        DialogAction(
          text: cancelText ?? 'cancel'.tr,
          onPressed: () => Get.back(result: false),
        ),
        DialogAction(
          text: confirmText ?? 'confirm'.tr,
          onPressed: () => Get.back(result: true),
          isPrimary: true,
        ),
      ],
    );
    return result ?? false;
  }
}

class AlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;

  const AlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      icon: icon ?? Icons.info_outline,
      iconColor: iconColor ?? AppColors.info,
      actions: [
        DialogAction(
          text: buttonText ?? 'ok'.tr,
          onPressed: onPressed ?? () => Get.back(),
          isPrimary: true,
        ),
      ],
    );
  }

  static Future<void> show({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
  }) {
    return Get.dialog(
      AlertDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}

class ErrorDialog {
  static Future<void> show({
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return AlertDialog.show(
      title: title ?? 'error'.tr,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.error_outline,
      iconColor: AppColors.error,
    );
  }
}

class SuccessDialog {
  static Future<void> show({
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return AlertDialog.show(
      title: title ?? 'success'.tr,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.check_circle_outline,
      iconColor: AppColors.success,
    );
  }
}

class LoadingDialog {
  static void show({
    String? message,
  }) {
    Get.dialog(
      CustomDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

/// Bottom sheet dialog alternative
class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool isScrollControlled;
  final double? height;

  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.isScrollControlled = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surface : LightColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: isDark ? DarkColors.border : LightColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title!,
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                ),
              ),
            ),
            Divider(color: isDark ? DarkColors.border : LightColors.border),
          ],

          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),

          if (actions != null && actions!.isNotEmpty) ...[
            Divider(color: isDark ? DarkColors.border : LightColors.border),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: actions!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index > 0 ? 8 : 0,
                        right: index < actions!.length - 1 ? 8 : 0,
                      ),
                      child: action,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool isScrollControlled = false,
    double? height,
  }) {
    return Get.bottomSheet<T>(
      CustomBottomSheet(
        title: title,
        child: child,
        actions: actions,
        isScrollControlled: isScrollControlled,
        height: height,
      ),
      isScrollControlled: isScrollControlled,
    );
  }
}