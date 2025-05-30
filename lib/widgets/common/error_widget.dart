import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_text_styles.dart';
import 'custom_button.dart';

/// Custom error widget with various error types and actions
class CustomErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final ErrorType type;
  final Widget? icon;
  final String? imagePath;
  final bool showRetryButton;
  final bool compact;
  final EdgeInsetsGeometry? padding;

  const CustomErrorWidget({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.type = ErrorType.general,
    this.icon,
    this.imagePath,
    this.showRetryButton = true,
    this.compact = false,
    this.padding,
  });

  /// Network error constructor
  const CustomErrorWidget.network({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.showRetryButton = true,
    this.compact = false,
    this.padding,
  }) : type = ErrorType.network,
       icon = null,
       imagePath = null;

  /// Not found error constructor
  const CustomErrorWidget.notFound({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.showRetryButton = false,
    this.compact = false,
    this.padding,
  }) : type = ErrorType.notFound,
       icon = null,
       imagePath = null;

  /// Server error constructor
  const CustomErrorWidget.server({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.showRetryButton = true,
    this.compact = false,
    this.padding,
  }) : type = ErrorType.server,
       icon = null,
       imagePath = null;

  /// Permission error constructor
  const CustomErrorWidget.permission({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.showRetryButton = false,
    this.compact = false,
    this.padding,
  }) : type = ErrorType.permission,
       icon = null,
       imagePath = null;

  /// Maintenance error constructor
  const CustomErrorWidget.maintenance({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.showRetryButton = false,
    this.compact = false,
    this.padding,
  }) : type = ErrorType.maintenance,
       icon = null,
       imagePath = null;

  /// Compact error constructor
  const CustomErrorWidget.compact({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.type = ErrorType.general,
    this.showRetryButton = true,
  }) : icon = null,
       imagePath = null,
       compact = true,
       padding = null;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactError(context);
    }
    return _buildFullError(context);
  }

  Widget _buildFullError(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorIcon(context),
          const SizedBox(height: 24),
          _buildTitle(theme),
          if (message != null) ...[
            const SizedBox(height: 12),
            _buildMessage(theme),
          ],
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 32),
            _buildRetryButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactError(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(_getErrorIconData(), color: _getErrorColor(), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? _getDefaultTitle(),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(width: 12),
            CustomButton.text(
              text: buttonText ?? 'retry'.tr,
              onPressed: onRetry,
              size: ButtonSize.small,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    if (icon != null) return icon!;

    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }

    final defaultImage = _getDefaultImage();
    if (defaultImage != null) {
      return Image.asset(
        defaultImage,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _getErrorColor().withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(_getErrorIconData(), size: 40, color: _getErrorColor()),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      title ?? _getDefaultTitle(),
      style: AppTextStyles.headlineSmall.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      message!,
      style: AppTextStyles.bodyMedium.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRetryButton() {
    return CustomButton.primary(
      text: buttonText ?? _getDefaultButtonText(),
      onPressed: onRetry,
      icon: const Icon(Icons.refresh, size: 20),
    );
  }

  String _getDefaultTitle() {
    switch (type) {
      case ErrorType.network:
        return 'no_internet'.tr;
      case ErrorType.notFound:
        return 'not_found'.tr;
      case ErrorType.server:
        return 'server_error'.tr;
      case ErrorType.permission:
        return 'permission_denied'.tr;
      case ErrorType.maintenance:
        return 'under_maintenance'.tr;
      case ErrorType.general:
      default:
        return 'something_went_wrong'.tr;
    }
  }

  String _getDefaultButtonText() {
    switch (type) {
      case ErrorType.network:
        return 'retry'.tr;
      case ErrorType.server:
        return 'try_again'.tr;
      case ErrorType.permission:
        return 'open_settings'.tr;
      case ErrorType.maintenance:
        return 'ok'.tr;
      case ErrorType.notFound:
        return 'go_back'.tr;
      case ErrorType.general:
      default:
        return 'retry'.tr;
    }
  }

  IconData _getErrorIconData() {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.notFound:
        return Icons.search_off;
      case ErrorType.server:
        return Icons.error_outline;
      case ErrorType.permission:
        return Icons.lock_outline;
      case ErrorType.maintenance:
        return Icons.build_outlined;
      case ErrorType.general:
      default:
        return Icons.error_outline;
    }
  }

  Color _getErrorColor() {
    switch (type) {
      case ErrorType.network:
        return AppColors.warning;
      case ErrorType.notFound:
        return AppColors.grey500;
      case ErrorType.server:
        return AppColors.error;
      case ErrorType.permission:
        return AppColors.warning;
      case ErrorType.maintenance:
        return AppColors.info;
      case ErrorType.general:
      default:
        return AppColors.error;
    }
  }

  String? _getDefaultImage() {
    switch (type) {
      case ErrorType.network:
        return AppImages.errorNetwork;
      case ErrorType.notFound:
        return AppImages.error404;
      case ErrorType.server:
        return AppImages.error500;
      case ErrorType.maintenance:
        return AppImages.errorMaintenance;
      case ErrorType.general:
      case ErrorType.permission:
        return null;
      default:
        return AppImages.errorGeneral;
    }
  }
}

/// Error types
enum ErrorType { general, network, notFound, server, permission, maintenance }

/// Helper extension for error handling
extension ErrorWidgetHelper on Widget {
  Widget withErrorBoundary({Widget Function(Object error)? errorBuilder}) {
    return Builder(
      builder: (context) {
        try {
          return this;
        } catch (error) {
          if (errorBuilder != null) {
            return errorBuilder(error);
          }
          return const CustomErrorWidget(type: ErrorType.general);
        }
      },
    );
  }
}

// Add the translation extension if not already present
extension StringTranslation on String {
  String get tr => this; // This should use your actual translation system
}
