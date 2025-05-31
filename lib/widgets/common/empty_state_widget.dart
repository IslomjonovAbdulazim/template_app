import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'custom_button_widget.dart';

/// Simple empty state widget for when there's no data
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? imagePath;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final EmptyStateType type;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.imagePath,
    this.icon,
    this.actionText,
    this.onAction,
    this.type = EmptyStateType.general,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _getEmptyStateConfig();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or Image
            _buildIllustration(isDark, config),
            const SizedBox(height: 24),

            // Title
            Text(
              title ?? config.title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message ?? config.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionText != null || config.actionText != null) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: actionText ?? config.actionText!,
                onPressed: onAction,
                type: ButtonType.primary,
                size: ButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isDark, EmptyStateConfig config) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }

    final iconData = icon ?? config.icon;
    final iconColor = isDark ? DarkColors.textTertiary : LightColors.textTertiary;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isDark ? AppColors.grey700 : AppColors.grey100).withOpacity(0.5),
      ),
      child: Icon(
        iconData,
        size: 64,
        color: iconColor,
      ),
    );
  }

  EmptyStateConfig _getEmptyStateConfig() {
    switch (type) {
      case EmptyStateType.search:
        return EmptyStateConfig(
          title: 'no_search_results'.tr,
          message: 'try_different_keywords'.tr,
          icon: Icons.search_off,
          actionText: 'refine_your_search'.tr,
        );
      case EmptyStateType.favorites:
        return EmptyStateConfig(
          title: 'no_favorites'.tr,
          message: 'Add items to favorites to see them here',
          icon: Icons.favorite_border,
          actionText: 'explore'.tr,
        );
      case EmptyStateType.notifications:
        return EmptyStateConfig(
          title: 'no_notifications'.tr,
          message: 'Notifications will appear here',
          icon: Icons.notifications_none,
        );
      case EmptyStateType.messages:
        return EmptyStateConfig(
          title: 'no_messages'.tr,
          message: 'Start a conversation',
          icon: Icons.message,
          actionText: 'New Message',
        );
      case EmptyStateType.history:
        return EmptyStateConfig(
          title: 'no_history'.tr,
          message: 'Your activity will appear here',
          icon: Icons.history,
        );
      case EmptyStateType.data:
        return EmptyStateConfig(
          title: 'no_data'.tr,
          message: 'Data will appear here',
          icon: Icons.inbox,
          actionText: 'refresh'.tr,
        );
      case EmptyStateType.offline:
        return EmptyStateConfig(
          title: 'no_internet'.tr,
          message: 'check_internet_connection'.tr,
          icon: Icons.wifi_off,
          actionText: 'retry'.tr,
        );
      case EmptyStateType.error:
        return EmptyStateConfig(
          title: 'Something went wrong',
          message: 'please_try_again_later'.tr,
          icon: Icons.error_outline,
          actionText: 'retry'.tr,
        );
      case EmptyStateType.general:
      default:
        return EmptyStateConfig(
          title: 'nothing_here'.tr,
          message: 'Content will appear here',
          icon: Icons.inbox,
        );
    }
  }
}

/// Specialized empty state widgets for common cases
class SearchEmptyState extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClear;

  const SearchEmptyState({
    super.key,
    this.searchQuery,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final message = searchQuery != null && searchQuery!.isNotEmpty
        ? 'No results for "$searchQuery"'
        : 'no_search_results'.tr;

    return EmptyStateWidget(
      type: EmptyStateType.search,
      message: message,
      actionText: onClear != null ? 'Clear Search' : null,
      onAction: onClear,
    );
  }
}

class OfflineEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineEmptyState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      type: EmptyStateType.offline,
      onAction: onRetry,
    );
  }
}

class ErrorEmptyState extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorEmptyState({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      type: EmptyStateType.error,
      message: errorMessage,
      onAction: onRetry,
    );
  }
}

/// Simple list empty state
class ListEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const ListEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      message: message,
      icon: icon ?? Icons.list_alt,
      actionText: actionText,
      onAction: onAction,
      type: EmptyStateType.general,
    );
  }
}

/// Configuration class for empty states
class EmptyStateConfig {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;

  EmptyStateConfig({
    required this.title,
    required this.message,
    required this.icon,
    this.actionText,
  });
}

enum EmptyStateType {
  general,
  search,
  favorites,
  notifications,
  messages,
  history,
  data,
  offline,
  error,
}