import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Custom card widget with various styles and configurations
class CustomCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? elevation;
  final double? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isClickable;
  final double? width;
  final double? height;

  const CustomCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isClickable = false,
    this.width,
    this.height,
  });

  /// Elevated card constructor
  const CustomCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  }) : shadowColor = null,
        elevation = 4,
        borderRadius = 12,
        border = null,
        isSelected = false,
        isClickable = true;

  /// Outlined card constructor
  const CustomCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  }) : shadowColor = null,
        elevation = 0,
        borderRadius = 12,
        border = const Border.fromBorderSide(BorderSide(color: AppColors.grey300)),
        isSelected = false,
        isClickable = true;

  /// Flat card constructor
  const CustomCard.flat({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  }) : shadowColor = null,
        elevation = 0,
        borderRadius = 12,
        border = null,
        isSelected = false,
        isClickable = true;

  /// Selectable card constructor
  const CustomCard.selectable({
    super.key,
    required this.child,
    required this.isSelected,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  }) : backgroundColor = null,
        shadowColor = null,
        elevation = 2,
        borderRadius = 12,
        border = null,
        isClickable = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: _getBorder(),
        boxShadow: _getBoxShadow(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap != null || onLongPress != null || isClickable) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (isSelected) {
      return AppColors.primaryShade;
    }
    return backgroundColor ?? theme.colorScheme.surface;
  }

  Border? _getBorder() {
    if (isSelected) {
      return Border.all(color: AppColors.primary, width: 2);
    }
    return border;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (elevation == null || elevation == 0) return null;

    return [
      BoxShadow(
        color: shadowColor ?? Colors.black.withOpacity(0.1),
        blurRadius: elevation! * 2,
        offset: Offset(0, elevation!),
      ),
    ];
  }
}

/// Info card widget for displaying key-value information
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final String? value;
  final Widget? valueWidget;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showArrow;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.valueWidget,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard.flat(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: textColor ?? theme.colorScheme.primary,
                size: 24,
              ),
              child: icon!,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: (textColor ?? theme.colorScheme.onSurface).withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (value != null || valueWidget != null) ...[
            const SizedBox(width: 12),
            valueWidget ??
                Text(
                  value!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ],
          if (showArrow) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: (textColor ?? theme.colorScheme.onSurface).withOpacity(0.5),
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}

/// Stat card widget for displaying statistics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? accentColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final String? trend;
  final bool isPositiveTrend;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.accentColor,
    this.onTap,
    this.isLoading = false,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;

    return CustomCard.elevated(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: accent, size: 20),
                    child: icon!,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (subtitle != null || trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                if (trend != null) ...[
                  Icon(
                    isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: isPositiveTrend ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isPositiveTrend ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Action card widget with primary action
class ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;
  final String actionText;
  final VoidCallback? onAction;
  final Color? backgroundColor;
  final Color? accentColor;
  final bool isLoading;

  const ActionCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    required this.actionText,
    this.onAction,
    this.backgroundColor,
    this.accentColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;

    return CustomCard.elevated(
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: accent, size: 24),
                    child: icon!,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                actionText,
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Feature card widget for showcasing features
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget icon;
  final VoidCallback? onTap;
  final bool isComingSoon;
  final Color? accentColor;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.isComingSoon = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;

    return CustomCard.flat(
      onTap: isComingSoon ? null : onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconTheme(
              data: IconThemeData(
                color: isComingSoon ? theme.colorScheme.onSurface.withOpacity(0.5) : accent,
                size: 28,
              ),
              child: icon,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              color: isComingSoon
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isComingSoon) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Coming Soon',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Profile card widget for user profiles
class ProfileCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final Widget? avatar;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final bool isOnline;
  final bool showOnlineStatus;

  const ProfileCard({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.avatar,
    this.onTap,
    this.actions,
    this.isOnline = false,
    this.showOnlineStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard.flat(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              _buildAvatar(),
              if (showOnlineStatus)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.success : AppColors.grey400,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: theme.colorScheme.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatar != null) return avatar!;

    if (avatarUrl != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: AppColors.grey200,
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primaryShade,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}