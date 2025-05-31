# Flutter Widgets Library Documentation

## Overview
This is a comprehensive Flutter widget library built with GetX architecture, providing reusable UI components with consistent styling, theming support (light/dark), and internationalization. All widgets follow Material Design principles and include proper accessibility features.

## Architecture
- **Framework**: Flutter with GetX state management
- **Theming**: Automatic light/dark mode support
- **Internationalization**: Built-in i18n with GetX translations
- **Styling**: Consistent design system with AppColors and AppTextStyles
- **Responsiveness**: Adaptive layouts for different screen sizes

---

## Widget Categories

### 1. Navigation Widgets

#### CustomBottomNavigation
**File**: `lib/widgets/common/bottom_navigation_bar.dart`

A flexible bottom navigation component with multiple styles.

**Features**:
- Automatic theme adaptation (light/dark)
- Icon and label support
- Active/inactive states
- Customizable colors and styling
- Safe area handling

**Usage**:
```dart
import 'package:template_app/widgets/common/bottom_navigation_bar.dart';

CustomBottomNavigation(
  currentIndex: 0,
  onTap: (index) => controller.changePage(index),
  items: [
    BottomNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    BottomNavItem(
      label: 'Search',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
    ),
  ],
)
```

**Variants**:
- `Material3BottomNavigation`: Uses Flutter's NavigationBar
- `FloatingBottomNavigation`: Pill-shaped floating navigation
- `BadgedBottomNavigation`: Navigation with notification badges

**Controller**:
```dart
// Simple controller for navigation state
final controller = Get.put(BottomNavigationController());
```

---

### 2. Layout & Structure Widgets

#### CustomCard
**File**: `lib/widgets/common/custom_card_widget.dart`

Flexible card widget with consistent styling and multiple variants.

**Base Card Features**:
- Automatic theme-based colors
- Customizable padding, margin, border radius
- Optional tap handling with ripple effect
- Elevation and shadow support

**Usage**:
```dart
import 'package:template_app/widgets/common/custom_card_widget.dart';

CustomCard(
  child: Text('Content'),
  onTap: () => print('Card tapped'),
  elevation: 4,
  borderRadius: 12,
)
```

**Specialized Cards**:

##### InfoCard
```dart
InfoCard(
  title: 'Account Settings',
  subtitle: 'Manage your account',
  description: 'Update profile, security, and preferences',
  icon: Icons.settings,
  onTap: () => Get.toNamed('/settings'),
)
```

##### StatusCard
```dart
StatusCard(
  title: 'Payment Status',
  subtitle: 'Order #12345',
  status: 'Completed',
  statusColor: AppColors.success,
  icon: Icons.check_circle,
)
```

##### MetricCard
```dart
MetricCard(
  label: 'Total Revenue',
  value: '\$12,345',
  trend: '+12%',
  isPositiveTrend: true,
  icon: Icons.trending_up,
)
```

##### ListItemCard
```dart
ListItemCard(
  title: 'John Doe',
  subtitle: 'Software Engineer',
  leading: CircleAvatar(child: Text('JD')),
  trailing: Icon(Icons.more_vert),
  onTap: () => showUserDetails(),
)
```

---

#### ResponsiveScaffold
**File**: `lib/widgets/common/responsive_scaffold.dart`

Advanced scaffold with built-in features for modern app development.

**Features**:
- Connectivity banner (shows when offline)
- Loading overlay support
- Responsive breakpoints
- Multiple scaffold variants

**Usage**:
```dart
import 'package:template_app/widgets/common/responsive_scaffold.dart';

// Basic responsive scaffold
ResponsiveScaffold(
  body: YourContent(),
  appBar: CustomAppBar(title: 'Home'),
  isLoading: controller.isLoading,
  loadingMessage: 'Please wait...',
)

// Page scaffold (simpler)
PageScaffold(
  title: 'Settings',
  body: SettingsContent(),
  actions: [
    IconButton(
      icon: Icon(Icons.save),
      onPressed: () => controller.save(),
    ),
  ],
)

// Navigation scaffold
NavigationScaffold(
  body: PageContent(),
  currentIndex: controller.currentIndex,
  onTabChanged: controller.changePage,
  navigationItems: navigationItems,
)
```

**Responsive Utilities**:
```dart
// Breakpoint detection
bool isMobile = BreakPoints.isMobile(context);
bool isTablet = BreakPoints.isTablet(context);
bool isDesktop = BreakPoints.isDesktop(context);

// Responsive builder
ResponsiveBuilder(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)

// Responsive container
ResponsiveContainer(
  maxWidth: 800,
  child: Content(),
)
```

---

### 3. App Bar Widgets

#### CustomAppBar
**File**: `lib/widgets/common/custom_app_bar.dart`

Consistent app bar with theming and navigation support.

**Features**:
- Automatic back button handling
- Theme-aware colors
- Custom title widget support
- System UI overlay styling

**Usage**:
```dart
import 'package:template_app/widgets/common/custom_app_bar.dart';

CustomAppBar(
  title: 'Profile',
  actions: [
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () => editProfile(),
    ),
  ],
  showBackButton: true,
  centerTitle: true,
)
```

**Specialized App Bars**:

##### SearchAppBar
```dart
SearchAppBar(
  title: 'Products',
  searchHint: 'Search products...',
  onSearchChanged: (query) => controller.search(query),
  onSearchSubmitted: (query) => controller.performSearch(query),
  autoFocus: true,
)
```

##### ProfileAppBar
```dart
ProfileAppBar(
  title: 'Welcome back',
  subtitle: 'John Doe',
  avatarUrl: user.profileImage,
  userInitials: 'JD',
  onProfileTap: () => showProfile(),
  onMenuTap: () => openDrawer(),
)
```

---

### 4. Input Widgets

#### CustomTextField
**File**: `lib/widgets/common/custom_text_field_widget.dart`

Comprehensive text input with validation and consistent styling.

**Features**:
- Built-in validation support
- Password visibility toggle
- Prefix/suffix icons
- Input formatters support
- Theme-aware styling

**Usage**:
```dart
import 'package:template_app/widgets/common/custom_text_field_widget.dart';

CustomTextField(
  label: 'Full Name',
  hint: 'Enter your full name',
  controller: nameController,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
  prefixIcon: Icons.person,
  onChanged: (value) => controller.updateName(value),
)
```

**Specialized Text Fields**:

##### EmailTextField
```dart
EmailTextField(
  controller: emailController,
  validator: (email) => EmailValidator.validate(email),
  onChanged: (email) => controller.updateEmail(email),
)
```

##### PasswordTextField
```dart
PasswordTextField(
  controller: passwordController,
  label: 'New Password',
  validator: (password) => PasswordValidator.validate(password),
)
```

##### SearchTextField
```dart
SearchTextField(
  hint: 'Search users...',
  onSubmitted: (query) => controller.search(query),
  onChanged: (query) => controller.liveSearch(query),
)
```

---

### 5. Button Widgets

#### CustomButton
**File**: `lib/widgets/common/custom_button_widget.dart`

Flexible button component with multiple styles and states.

**Features**:
- Three button types: primary, secondary, text
- Three sizes: small, medium, large
- Loading state support
- Icon support
- Disabled state handling

**Usage**:
```dart
import 'package:template_app/widgets/common/custom_button_widget.dart';

// Primary button
CustomButton(
  text: 'Save Changes',
  onPressed: () => controller.save(),
  type: ButtonType.primary,
  size: ButtonSize.medium,
  isLoading: controller.isLoading,
  icon: Icons.save,
)

// Secondary button
CustomButton(
  text: 'Cancel',
  onPressed: () => Get.back(),
  type: ButtonType.secondary,
  size: ButtonSize.medium,
)

// Text button
CustomButton(
  text: 'Learn More',
  onPressed: () => showInfo(),
  type: ButtonType.text,
  size: ButtonSize.small,
)
```

**Button Types**:
- `ButtonType.primary`: Filled background, prominent
- `ButtonType.secondary`: Outlined style
- `ButtonType.text`: Text-only, minimal

**Button Sizes**:
- `ButtonSize.small`: 40px height, compact padding
- `ButtonSize.medium`: 48px height, standard padding
- `ButtonSize.large`: 56px height, generous padding

---

### 6. Dialog Widgets

#### CustomDialog
**File**: `lib/widgets/common/custom_dialog.dart`

Flexible dialog system with consistent styling and pre-built variants.

**Features**:
- Icon support with background
- Multiple action buttons
- Consistent theming
- Barrier dismissible option

**Usage**:
```dart
import 'package:template_app/widgets/common/custom_dialog.dart';

// Basic custom dialog
CustomDialog.show(
  title: 'Confirm Action',
  message: 'Are you sure you want to delete this item?',
  icon: Icons.warning,
  iconColor: AppColors.warning,
  actions: [
    DialogAction(
      text: 'Cancel',
      onPressed: () => Get.back(result: false),
    ),
    DialogAction(
      text: 'Delete',
      onPressed: () => Get.back(result: true),
      isPrimary: true,
    ),
  ],
);
```

**Pre-built Dialogs**:

##### ConfirmationDialog
```dart
final result = await ConfirmationDialog.show(
  title: 'Delete Account',
  message: 'This action cannot be undone.',
  confirmText: 'Delete',
  cancelText: 'Keep Account',
);
if (result) {
  await controller.deleteAccount();
}
```

##### AlertDialog
```dart
AlertDialog.show(
  title: 'Success',
  message: 'Your profile has been updated.',
  icon: Icons.check_circle,
  iconColor: AppColors.success,
);
```

##### ErrorDialog
```dart
ErrorDialog.show(
  message: 'Failed to save changes. Please try again.',
);
```

##### SuccessDialog
```dart
SuccessDialog.show(
  title: 'Payment Complete',
  message: 'Your order has been confirmed.',
);
```

##### LoadingDialog
```dart
// Show loading
LoadingDialog.show(message: 'Processing payment...');

// Hide loading
LoadingDialog.hide();
```

**Bottom Sheet Alternative**:
```dart
CustomBottomSheet.show(
  title: 'Select Option',
  child: OptionsList(),
  actions: [
    CustomButton(text: 'Cancel', onPressed: () => Get.back()),
    CustomButton(text: 'Confirm', onPressed: () => confirm()),
  ],
);
```

---

### 7. State Widgets

#### LoadingWidget
**File**: `lib/widgets/common/loading_widget.dart`

Comprehensive loading indicators with multiple styles.

**Basic Loading**:
```dart
import 'package:template_app/widgets/common/loading_widget.dart';

LoadingWidget(
  message: 'Loading data...',
  size: 48,
  color: AppColors.primary,
)
```

**Loading Overlay**:
```dart
LoadingOverlay(
  isLoading: controller.isLoading,
  loadingMessage: 'Please wait...',
  child: YourContent(),
)
```

**Shimmer Loading**:
```dart
ShimmerLoading(
  isLoading: controller.isLoading,
  child: YourContent(),
)

// Pre-built shimmer components
LoadingListItem()
LoadingCard(height: 200)

// Custom shimmer shapes
ShimmerBox(width: 100, height: 20)
ShimmerText(width: 150)
```

---

#### EmptyStateWidget
**File**: `lib/widgets/common/empty_state_widget.dart`

User-friendly empty states for different scenarios.

**Features**:
- Pre-defined empty state types
- Custom illustrations support
- Action button support
- Internationalization ready

**Usage**:
```dart
import 'package:template_app/widgets/common/empty_state_widget.dart';

EmptyStateWidget(
  type: EmptyStateType.search,
  title: 'No results found',
  message: 'Try adjusting your search criteria',
  actionText: 'Clear Search',
  onAction: () => controller.clearSearch(),
)
```

**Pre-built Empty States**:

##### SearchEmptyState
```dart
SearchEmptyState(
  searchQuery: controller.searchQuery,
  onClear: () => controller.clearSearch(),
)
```

##### OfflineEmptyState
```dart
OfflineEmptyState(
  onRetry: () => controller.retryConnection(),
)
```

##### ErrorEmptyState
```dart
ErrorEmptyState(
  errorMessage: 'Something went wrong',
  onRetry: () => controller.retry(),
)
```

##### ListEmptyState
```dart
ListEmptyState(
  title: 'No notifications',
  message: 'You\'ll see notifications here when you receive them',
  icon: Icons.notifications_none,
  actionText: 'Refresh',
  onAction: () => controller.refresh(),
)
```

**Empty State Types**:
- `EmptyStateType.general`: Generic empty state
- `EmptyStateType.search`: No search results
- `EmptyStateType.favorites`: No favorites
- `EmptyStateType.notifications`: No notifications
- `EmptyStateType.messages`: No messages
- `EmptyStateType.history`: No history
- `EmptyStateType.data`: No data
- `EmptyStateType.offline`: Offline state
- `EmptyStateType.error`: Error state

---

## Integration Examples

### Complete Page Example
```dart
class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Profile',
      isLoading: controller.isLoading,
      body: Obx(() {
        if (controller.hasError) {
          return ErrorEmptyState(
            errorMessage: controller.errorMessage,
            onRetry: controller.retry,
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              InfoCard(
                title: controller.user.name,
                subtitle: controller.user.email,
                icon: Icons.person,
                onTap: () => Get.toNamed('/edit-profile'),
              ),
              SizedBox(height: 16),
              MetricCard(
                label: 'Total Orders',
                value: '${controller.user.totalOrders}',
                trend: '+5%',
                isPositiveTrend: true,
              ),
              SizedBox(height: 24),
              CustomButton(
                text: 'Edit Profile',
                onPressed: () => Get.toNamed('/edit-profile'),
                type: ButtonType.primary,
                icon: Icons.edit,
              ),
            ],
          ),
        );
      }),
    );
  }
}
```

### Form Page Example
```dart
class LoginPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Login',
      showBackButton: false,
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Spacer(),
              EmailTextField(
                controller: controller.emailController,
                validator: controller.validateEmail,
              ),
              SizedBox(height: 16),
              PasswordTextField(
                controller: controller.passwordController,
                validator: controller.validatePassword,
              ),
              SizedBox(height: 24),
              Obx(() => CustomButton(
                text: 'Login',
                onPressed: controller.login,
                type: ButtonType.primary,
                size: ButtonSize.large,
                isLoading: controller.isLoading,
                width: double.infinity,
              )),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
```

### List Page Example
```dart
class ProductsPage extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return NavigationScaffold(
      appBar: SearchAppBar(
        title: 'Products',
        onSearchChanged: controller.search,
      ),
      currentIndex: 1,
      onTabChanged: controller.changeTab,
      navigationItems: AppNavigation.items,
      body: Obx(() {
        if (controller.isLoading && controller.products.isEmpty) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => LoadingListItem(),
          );
        }

        if (controller.products.isEmpty) {
          return SearchEmptyState(
            searchQuery: controller.searchQuery,
            onClear: controller.clearSearch,
          );
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListItemCard(
              title: product.name,
              subtitle: '\$${product.price}',
              leading: CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: 48,
                height: 48,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => Get.toNamed('/product/${product.id}'),
            );
          },
        );
      }),
    );
  }
}
```

---

## Theming Integration

### Colors
All widgets automatically use the app's color system:
- `AppColors.primary`, `AppColors.primaryLight`
- `LightColors.*` and `DarkColors.*` for theme-specific colors
- Semantic colors: `AppColors.success`, `AppColors.error`, `AppColors.warning`

### Typography
Consistent text styles through `AppTextStyles`:
- `AppTextStyles.headlineLarge` to `AppTextStyles.bodySmall`
- `AppTextStyles.buttonMedium`, `AppTextStyles.inputLabel`

### Dark Mode
All widgets automatically adapt to system theme changes through:
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
```

---

## Internationalization

All widgets support i18n through GetX translations:
```dart
Text('welcome'.tr)  // Translates based on current locale
```

Common translation keys used:
- `loading`, `search`, `cancel`, `confirm`, `ok`, `error`, `success`
- `email`, `password`, `retry`, `refresh`
- `no_internet`, `no_data`, `no_search_results`

---

## Dependencies

### Required Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                    # State management & routing
  flutter_localizations:         # Internationalization
    sdk: flutter
  cached_network_image: ^3.4.1   # Image caching (for examples)
```

### Import Structure
```dart
// Core widgets
import 'package:template_app/widgets/common/custom_button_widget.dart';
import 'package:template_app/widgets/common/custom_card_widget.dart';
import 'package:template_app/widgets/common/custom_dialog.dart';
import 'package:template_app/widgets/common/custom_text_field_widget.dart';
import 'package:template_app/widgets/common/responsive_scaffold.dart';

// Constants
import 'package:template_app/constants/app_colors.dart';
import 'package:template_app/constants/app_text_styles.dart';

// GetX
import 'package:get/get.dart';
```

---

## Best Practices

### 1. Widget Usage
- Always use theme-aware widgets for consistent appearance
- Prefer specialized widgets (EmailTextField) over generic ones when available
- Use responsive scaffolds for proper layout handling

### 2. State Management
- Integrate with GetX controllers for reactive UI
- Use Obx() for reactive widgets
- Handle loading and error states consistently

### 3. Accessibility
- All widgets include proper semantic labels
- Color contrast follows accessibility guidelines
- Touch targets meet minimum size requirements

### 4. Performance
- Widgets are stateless where possible
- Proper use of const constructors
- Efficient rebuilding with GetX reactivity

### 5. Styling
- Use provided color and text style constants
- Maintain consistent spacing (8px grid system)
- Follow Material Design principles

---

## File Structure Summary

```
lib/widgets/
├── common/
│   ├── bottom_navigation_bar.dart     # Navigation components
│   ├── custom_app_bar.dart           # App bar variants
│   ├── custom_button_widget.dart     # Button components
│   ├── custom_card_widget.dart       # Card variants
│   ├── custom_dialog.dart            # Dialog system
│   ├── custom_text_field_widget.dart # Input components
│   ├── empty_state_widget.dart       # Empty states
│   ├── loading_widget.dart           # Loading indicators
│   └── responsive_scaffold.dart      # Layout scaffolds
└── dialogs/
    ├── confirmation_dialog.dart      # (Empty - use CustomDialog)
    └── info_dialog.dart             # (Empty - use CustomDialog)
```

This widget library provides a complete foundation for building consistent, accessible, and maintainable Flutter applications with modern design patterns and best practices.