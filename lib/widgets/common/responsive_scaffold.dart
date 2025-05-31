import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/connectivity_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'bottom_navigation_bar.dart';
import 'custom_app_bar.dart';
import 'loading_widget.dart';

/// Responsive scaffold that handles common app structure
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool showConnectivityBanner;
  final bool isLoading;
  final String? loadingMessage;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.showConnectivityBanner = true,
    this.isLoading = false,
    this.loadingMessage,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? DarkColors.background : LightColors.background);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar,
      body: Stack(
        children: [
          // Main body
          body,

          // Connectivity banner
          if (showConnectivityBanner) _buildConnectivityBanner(),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingWidget(
                  message: loadingMessage,
                  size: 48,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  Widget _buildConnectivityBanner() {
    return GetBuilder<ConnectivityController>(
      builder: (controller) {
        if (controller.isConnected) return const SizedBox.shrink();

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'no_internet'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (controller.isRetrying)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: controller.retryConnection,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        'retry'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Scaffold with built-in bottom navigation
class NavigationScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int currentIndex;
  final Function(int) onTabChanged;
  final List<BottomNavItem> navigationItems;
  final Widget? floatingActionButton;
  final bool showConnectivityBanner;
  final bool isLoading;
  final String? loadingMessage;

  const NavigationScaffold({
    super.key,
    required this.body,
    this.appBar,
    required this.currentIndex,
    required this.onTabChanged,
    required this.navigationItems,
    this.floatingActionButton,
    this.showConnectivityBanner = true,
    this.isLoading = false,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: currentIndex,
        onTap: onTabChanged,
        items: navigationItems,
      ),
      floatingActionButton: floatingActionButton,
      showConnectivityBanner: showConnectivityBanner,
      isLoading: isLoading,
      loadingMessage: loadingMessage,
    );
  }
}

/// Scaffold with drawer navigation
class DrawerScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget drawer;
  final Widget? endDrawer;
  final bool showConnectivityBanner;
  final bool isLoading;

  const DrawerScaffold({
    super.key,
    required this.body,
    this.appBar,
    required this.drawer,
    this.endDrawer,
    this.showConnectivityBanner = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: appBar,
      body: body,
      drawer: drawer,
      endDrawer: endDrawer,
      showConnectivityBanner: showConnectivityBanner,
      isLoading: isLoading,
    );
  }
}

/// Simple page scaffold for single pages
class PageScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? floatingActionButton;
  final bool showConnectivityBanner;
  final bool isLoading;
  final String? loadingMessage;
  final bool centerTitle;

  const PageScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.floatingActionButton,
    this.showConnectivityBanner = true,
    this.isLoading = false,
    this.loadingMessage,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: title != null
          ? CustomAppBar(
        title: title,
        actions: actions,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
        centerTitle: centerTitle,
      )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      showConnectivityBanner: showConnectivityBanner,
      isLoading: isLoading,
      loadingMessage: loadingMessage,
    );
  }
}

/// Utility class for responsive breakpoints
class BreakPoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktop;
  }
}

/// Responsive widget builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (BreakPoints.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (BreakPoints.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Simple responsive container with max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;
  final bool center;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: center
          ? Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      )
          : ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}