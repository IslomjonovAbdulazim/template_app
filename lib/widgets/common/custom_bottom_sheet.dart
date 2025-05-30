import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'custom_button.dart';

/// Custom bottom sheet widget with various configurations
class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final bool isDismissible;
  final bool enableDrag;
  final bool showDragHandle;
  final bool showCloseButton;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? borderRadius;

  const CustomBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.onClose,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.maxHeight,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  /// Simple bottom sheet constructor
  const CustomBottomSheet.simple({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.onClose,
    this.isDismissible = true,
  }) : subtitle = null,
        enableDrag = true,
        showDragHandle = true,
        showCloseButton = false,
        maxHeight = null,
        padding = null,
        backgroundColor = null,
        borderRadius = null;

  /// List bottom sheet constructor
  const CustomBottomSheet.list({
    super.key,
    this.title,
    required this.content,
    this.onClose,
    this.isDismissible = true,
    this.showCloseButton = false,
  }) : subtitle = null,
        actions = null,
        enableDrag = true,
        showDragHandle = true,
        maxHeight = null,
        padding = null,
        backgroundColor = null,
        borderRadius = null;

  /// Action bottom sheet constructor
  const CustomBottomSheet.actions({
    super.key,
    this.title,
    this.subtitle,
    required this.actions,
    this.onClose,
    this.isDismissible = true,
  }) : content = null,
        enableDrag = true,
        showDragHandle = true,
        showCloseButton = false,
        maxHeight = null,
        padding = null,
        backgroundColor = null,
        borderRadius = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final maxSheetHeight = maxHeight ?? mediaQuery.size.height * 0.8;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxSheetHeight,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius ?? 20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) _buildDragHandle(theme),
          if (title != null || showCloseButton) _buildHeader(context, theme),
          Flexible(
            child: SingleChildScrollView(
              padding: padding ?? const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (subtitle != null) _buildSubtitle(theme),
                  if (content != null) content!,
                  if (actions != null) ...[
                    const SizedBox(height: 20),
                    _buildActions(),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: mediaQuery.padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          if (showCloseButton)
            IconButton(
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        subtitle!,
        style: AppTextStyles.bodyMedium.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions!.map((action) {
        final index = actions!.indexOf(action);
        return Padding(
          padding: EdgeInsets.only(bottom: index < actions!.length - 1 ? 12 : 0),
          child: action,
        );
      }).toList(),
    );
  }

  /// Show bottom sheet helper method
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget bottomSheet,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      shape: shape,
      isScrollControlled: true,
      builder: (context) => bottomSheet,
    );
  }
}

/// Bottom sheet list item widget
class BottomSheetListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isSelected;

  const BottomSheetListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: isDestructive
              ? AppColors.error
              : isSelected
              ? AppColors.primary
              : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle!,
        style: AppTextStyles.bodySmall.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      )
          : null,
      trailing: trailing ??
          (isSelected
              ? const Icon(Icons.check, color: AppColors.primary)
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }
}

/// Confirmation bottom sheet
class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final Widget? icon;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: title,
      showDragHandle: true,
      content: Column(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        CustomButton.outline(
          text: cancelText,
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
        ),
        CustomButton.primary(
          text: confirmText,
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          backgroundColor: isDestructive ? AppColors.error : null,
        ),
      ],
    );
  }

  /// Show confirmation bottom sheet
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    Widget? icon,
  }) {
    return CustomBottomSheet.show<bool>(
      context: context,
      bottomSheet: ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        icon: icon,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}

/// Selection bottom sheet
class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<SelectionItem<T>> items;
  final T? selectedValue;
  final Function(T)? onSelected;
  final bool allowMultiple;
  final List<T>? selectedValues;
  final Function(List<T>)? onMultipleSelected;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    this.onSelected,
    this.allowMultiple = false,
    this.selectedValues,
    this.onMultipleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet.list(
      title: title,
      content: Column(
        children: items.map((item) {
          final isSelected = allowMultiple
              ? selectedValues?.contains(item.value) ?? false
              : selectedValue == item.value;

          return BottomSheetListItem(
            leading: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            isSelected: isSelected,
            onTap: () {
              if (allowMultiple) {
                final currentValues = List<T>.from(selectedValues ?? []);
                if (isSelected) {
                  currentValues.remove(item.value);
                } else {
                  currentValues.add(item.value);
                }
                onMultipleSelected?.call(currentValues);
              } else {
                Navigator.of(context).pop();
                onSelected?.call(item.value);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  /// Show selection bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<SelectionItem<T>> items,
    T? selectedValue,
  }) {
    return CustomBottomSheet.show<T>(
      context: context,
      bottomSheet: SelectionBottomSheet<T>(
        title: title,
        items: items,
        selectedValue: selectedValue,
        onSelected: (value) => Navigator.of(context).pop(value),
      ),
    );
  }
}

/// Selection item model
class SelectionItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final Widget? icon;

  const SelectionItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
  });
}