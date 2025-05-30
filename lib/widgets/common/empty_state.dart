import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_text_styles.dart';
import 'custom_button.dart';

/// Empty state widget for displaying when no content is available
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? illustration;
  final String? illustrationPath;
  final EmptyStateType type;
  final bool showButton;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.illustration,
    this.illustrationPath,
    this.type = EmptyStateType.general,
    this.showButton = true,
    this.padding,
    this.maxWidth,
  });

  /// Search empty state constructor
  const EmptyStateWidget.search({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showButton = false,
    this.padding,
    this.maxWidth,
  }) : type = EmptyStateType.search,
        illustration = null,
        illustrationPath = null;

  /// No data empty state constructor
  const EmptyStateWidget.noData({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showButton = true,
    this.padding,
    this.maxWidth,
  }) : type = EmptyStateType.noData,
        illustration = null,
        illustrationPath = null;

  /// No internet empty state constructor
  const EmptyStateWidget.noInternet({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showButton = true,
    this.padding,
    this.maxWidth,
  }) : type = EmptyStateType.noInternet,
        illustration = null,
        illustrationPath = null;

  /// Favorites empty state constructor
  const EmptyStateWidget.favorites({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showButton = true,
    this.padding,
    this.maxWidth,
  }) : type = EmptyStateType.favorites,
        illustration = null,
        illustrationPath = null;

  /// Notifications empty state constructor
  const EmptyStateWidget.notifications({
    super.key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showButton = false,
    this.padding,
    this.maxWidth,
  }) : type = EmptyStateType.notifications,
        illustration = null,
        illustrationPath = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? 300,
            ),
            child: Column(
              children: [
                _buildTitle(theme),
                if (message != null) ...[
                  const SizedBox(height: 12),
                  _buildMessage(theme),
                ],
                if (showButton && (buttonText != null || onButtonPressed != null)) ...[
                  const SizedBox(height: 24),
                  _buildButton(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    if (illustration != null) return illustration!;

    final illustrationWidget = _getDefaultIllustration();
    if (illustrationWidget != null) return illustrationWidget;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: _getIllustrationColor().withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getDefaultIcon(),
        size: 60,
        color: _getIllustrationColor(),
      ),
    );
  }

  Widget? _getDefaultIllustration() {
    String? assetPath = illustrationPath;

    if (assetPath == null) {
      switch (type) {
        case EmptyStateType.search:
          assetPath = AppImages.emptySearch;
          break;
        case EmptyStateType.favorites:
          assetPath = AppImages.emptyFavorites;
          break;
        case EmptyStateType.notifications:
          assetPath = AppImages.emptyNotifications;
          break;
        case EmptyStateType.noData:
          assetPath = AppImages.emptyData;
          break;
        case EmptyStateType.noInternet:
          assetPath = AppImages.errorNetwork;
          break;
        case EmptyStateType.general:
        default:
          return null;
      }
    }

    if (assetPath != null) {
      return SizedBox(
        width: 120,
        height: 120,
        child: assetPath.endsWith('.svg')
            ? SvgPicture.asset(
          assetPath,
          width: 120,
          height: 120,
          colorFilter: ColorFilter.mode(
            _getIllustrationColor(),
            BlendMode.srcIn,
          ),
        )
            : Image.asset(
          assetPath,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      );
    }

    return null;
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      title ?? _getDefaultTitle(),
      style: AppTextStyles.titleLarge.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      message!,
      style: AppTextStyles.bodyMedium.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton() {
    return CustomButton.primary(
      text: buttonText ?? _getDefaultButtonText(),
      onPressed: onButtonPressed,
      icon: _getButtonIcon(),
    );
  }

  String _getDefaultTitle() {
    switch (type) {
      case EmptyStateType.search:
        return 'no_search_results'.tr;
      case EmptyStateType.noData:
        return 'no_data'.tr;
      case EmptyStateType.noInternet:
        return 'no_internet'.tr;
      case EmptyStateType.favorites:
        return 'no_favorites'.tr;
      case EmptyStateType.notifications:
        return 'no_notifications'.tr;
      case EmptyStateType.general:
      default:
        return 'nothing_here'.tr;
    }
  }

  String _getDefaultButtonText() {
    switch (type) {
      case EmptyStateType.search:
        return 'clear_search'.tr;
      case EmptyStateType.noData:
        return 'refresh'.tr;
      case EmptyStateType.noInternet:
        return 'retry'.tr;
      case EmptyStateType.favorites:
        return 'explore'.tr;
      case EmptyStateType.notifications:
        return 'ok'.tr;
      case EmptyStateType.general:
      default:
        return 'get_started'.tr;
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case EmptyStateType.search:
        return Icons.search_off;
      case EmptyStateType.noData:
        return Icons.inbox_outlined;
      case EmptyStateType.noInternet:
        return Icons.wifi_off;
      case EmptyStateType.favorites:
        return Icons.favorite_border;
      case EmptyStateType.notifications:
        return Icons.notifications_none;
      case EmptyStateType.general:
      default:
        return Icons.inventory_2_outlined;
    }
  }

  Widget? _getButtonIcon() {
    switch (type) {
      case EmptyStateType.noInternet:
        return const Icon(Icons.refresh, size: 20);
      case EmptyStateType.noData:
        return const Icon(Icons.refresh, size: 20);
      default:
        return null;
    }
  }

  Color _getIllustrationColor() {
    switch (type) {
      case EmptyStateType.search:
        return AppColors.info;
      case EmptyStateType.noData:
        return AppColors.grey500;
      case EmptyStateType.noInternet:
        return AppColors.warning;
      case EmptyStateType.favorites:
        return AppColors.error;
      case EmptyStateType.notifications:
        return AppColors.info;
      case EmptyStateType.general:
      default:
        return AppColors.primary;
    }
  }
}

/// Empty state types
enum EmptyStateType {
  general,
  search,
  noData,
  noInternet,
  favorites,
  notifications,
}

/// Shimmer loading widget for empty states that are loading
class ShimmerEmptyState extends StatefulWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ShimmerEmptyState({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
    this.margin,
  });

  @override
  State<ShimmerEmptyState> createState() => _ShimmerEmptyStateState();
}

class _ShimmerEmptyStateState extends State<ShimmerEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          widget.itemCount,
              (index) => Container(
            margin: widget.margin ?? const EdgeInsets.only(bottom: 16),
            child: _buildShimmerItem(),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                AppColors.grey200,
                AppColors.grey200.withOpacity(0.5),
                AppColors.grey200,
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      },
    );
  }
}

/// Pull to refresh empty state
class PullToRefreshEmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRefresh;
  final bool isRefreshing;
  final Widget? illustration;

  const PullToRefreshEmptyState({
    super.key,
    this.title,
    this.message,
    this.onRefresh,
    this.isRefreshing = false,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: EmptyStateWidget(
            title: title ?? 'pull_to_refresh'.tr,
            message: message ?? 'pull_down_to_refresh_content'.tr,
            illustration: illustration ??
                Icon(
                  Icons.refresh,
                  size: 60,
                  color: AppColors.primary,
                ),
            showButton: false,
          ),
        ),
      ),
    );
  }
}

// Add the translation extension if not already present
extension StringTranslation on String {
  String get tr => this; // This should use your actual translation system
}