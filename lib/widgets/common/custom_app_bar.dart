import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Simple, flexible app bar with consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarBgColor = backgroundColor ??
        (isDark ? DarkColors.surface : LightColors.surface);
    final appBarFgColor = foregroundColor ??
        (isDark ? DarkColors.textPrimary : LightColors.textPrimary);

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: appBarFgColor,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: centerTitle,
      backgroundColor: appBarBgColor,
      foregroundColor: appBarFgColor,
      elevation: elevation,
      scrolledUnderElevation: elevation > 0 ? elevation + 1 : 1,
      surfaceTintColor: isDark ? AppColors.primaryLight : AppColors.primary,
      leading: _buildLeading(context, appBarFgColor),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    if (showBackButton && (Get.routing.isBack ?? false)) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios, color: foregroundColor),
        onPressed: onBackPressed ?? () => Get.back(),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// App bar with search functionality
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final String? searchHint;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final VoidCallback? onSearchClear;
  final List<Widget>? actions;
  final bool showSearch;
  final bool autoFocus;

  const SearchAppBar({
    super.key,
    this.title,
    this.searchHint,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClear,
    this.actions,
    this.showSearch = false,
    this.autoFocus = false,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late bool _isSearching;
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _isSearching = widget.showSearch;
    _searchController = widget.searchController ?? TextEditingController();
    _searchFocusNode = FocusNode();

    if (widget.autoFocus && _isSearching) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: _isSearching ? _buildSearchField(isDark) : Text(widget.title ?? ''),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
      foregroundColor: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: _buildLeading(isDark),
      actions: _buildActions(isDark),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: widget.searchHint ?? 'search'.tr,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      style: AppTextStyles.bodyMedium.copyWith(
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      ),
      onChanged: widget.onSearchChanged,
      onSubmitted: widget.onSearchSubmitted,
    );
  }

  Widget? _buildLeading(bool isDark) {
    if (_isSearching) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        ),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            _searchFocusNode.unfocus();
          });
          widget.onSearchClear?.call();
        },
      );
    }

    if (Get.routing.isBack ?? false) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        ),
        onPressed: () => Get.back(),
      );
    }

    return null;
  }

  List<Widget>? _buildActions(bool isDark) {
    final actionColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;

    if (_isSearching) {
      return [
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear, color: actionColor),
            onPressed: () {
              _searchController.clear();
              widget.onSearchChanged?.call('');
              widget.onSearchClear?.call();
            },
          ),
      ];
    }

    return [
      IconButton(
        icon: Icon(Icons.search, color: actionColor),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
          if (widget.autoFocus) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _searchFocusNode.requestFocus();
            });
          }
        },
      ),
      ...?widget.actions,
    ];
  }
}

/// Simple app bar with profile/menu button
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final String? avatarUrl;
  final String? userInitials;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;

  const ProfileAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.avatarUrl,
    this.userInitials,
    this.onProfileTap,
    this.onMenuTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: AppTextStyles.titleMedium.copyWith(
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
        ],
      ),
      backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
      foregroundColor: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        ),
        onPressed: onMenuTap,
      ),
      actions: [
        ...?actions,
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                userInitials ?? 'U',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}