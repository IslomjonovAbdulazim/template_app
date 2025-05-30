import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_images.dart';
import 'custom_button.dart';

/// Social login button widget for Google, Apple, Facebook, etc.
class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final String? customText;

  const SocialLoginButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.customText,
  });

  /// Google login button constructor
  const SocialLoginButton.google({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.customText,
  }) : provider = SocialProvider.google;

  /// Apple login button constructor
  const SocialLoginButton.apple({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.customText,
  }) : provider = SocialProvider.apple;

  /// Facebook login button constructor
  const SocialLoginButton.facebook({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.customText,
  }) : provider = SocialProvider.facebook;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: CustomButton.social(
        text: customText ?? _getButtonText(),
        onPressed: isEnabled ? onPressed : null,
        isLoading: isLoading,
        isEnabled: isEnabled,
        icon: _buildIcon(),
        backgroundColor: _getBackgroundColor(),
        textColor: _getTextColor(),
        borderColor: _getBorderColor(),
        size: ButtonSize.large,
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    return SizedBox(
      width: 20,
      height: 20,
      child: _getIcon(),
    );
  }

  Widget _getIcon() {
    final iconPath = _getIconPath();

    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: 20,
        height: 20,
        colorFilter: provider == SocialProvider.apple
            ? ColorFilter.mode(_getIconColor(), BlendMode.srcIn)
            : null,
      );
    }

    return Image.asset(
      iconPath,
      width: 20,
      height: 20,
    );
  }

  String _getIconPath() {
    switch (provider) {
      case SocialProvider.google:
        return AppImages.iconGoogle;
      case SocialProvider.apple:
        return AppImages.iconApple;
      case SocialProvider.facebook:
        return AppImages.iconFacebook;
    }
  }

  String _getButtonText() {
    switch (provider) {
      case SocialProvider.google:
        return 'sign_in_with_google'.tr;
      case SocialProvider.apple:
        return 'sign_in_with_apple'.tr;
      case SocialProvider.facebook:
        return 'sign_in_with_facebook'.tr;
    }
  }

  Color _getBackgroundColor() {
    switch (provider) {
      case SocialProvider.google:
        return Colors.white;
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.facebook:
        return AppColors.facebook;
    }
  }

  Color _getTextColor() {
    switch (provider) {
      case SocialProvider.google:
        return AppColors.grey800;
      case SocialProvider.apple:
        return Colors.white;
      case SocialProvider.facebook:
        return Colors.white;
    }
  }

  Color _getBorderColor() {
    switch (provider) {
      case SocialProvider.google:
        return AppColors.grey300;
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.facebook:
        return AppColors.facebook;
    }
  }

  Color _getIconColor() {
    switch (provider) {
      case SocialProvider.google:
        return AppColors.grey800;
      case SocialProvider.apple:
        return Colors.white;
      case SocialProvider.facebook:
        return Colors.white;
    }
  }
}

/// Social login providers
enum SocialProvider {
  google,
  apple,
  facebook,
}

/// Social login section widget
class SocialLoginSection extends StatelessWidget {
  final List<SocialProvider> providers;
  final Function(SocialProvider)? onProviderSelected;
  final bool isLoading;
  final String? loadingProvider;
  final EdgeInsetsGeometry? padding;
  final String? dividerText;

  const SocialLoginSection({
    super.key,
    this.providers = const [SocialProvider.google, SocialProvider.apple],
    this.onProviderSelected,
    this.isLoading = false,
    this.loadingProvider,
    this.padding,
    this.dividerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          if (dividerText != null) ...[
            _buildDivider(context),
            const SizedBox(height: 24),
          ],
          ...providers.map((provider) => _buildProviderButton(provider)),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.colorScheme.outline.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            dividerText ?? 'or'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.colorScheme.outline.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderButton(SocialProvider provider) {
    final isProviderLoading = isLoading && loadingProvider == provider.name;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SocialLoginButton(
        provider: provider,
        onPressed: () => onProviderSelected?.call(provider),
        isLoading: isProviderLoading,
        isEnabled: !isLoading,
      ),
    );
  }
}

/// Compact social login buttons row
class CompactSocialLoginButtons extends StatelessWidget {
  final List<SocialProvider> providers;
  final Function(SocialProvider)? onProviderSelected;
  final bool isLoading;
  final String? loadingProvider;
  final double? buttonSize;
  final MainAxisAlignment alignment;

  const CompactSocialLoginButtons({
    super.key,
    this.providers = const [SocialProvider.google, SocialProvider.apple],
    this.onProviderSelected,
    this.isLoading = false,
    this.loadingProvider,
    this.buttonSize,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final size = buttonSize ?? 56;

    return Row(
      mainAxisAlignment: alignment,
      children: providers.map((provider) {
        final isProviderLoading = isLoading && loadingProvider == provider.name;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildCompactButton(provider, isProviderLoading, size),
        );
      }).toList(),
    );
  }

  Widget _buildCompactButton(SocialProvider provider, bool isProviderLoading, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: !isLoading ? () => onProviderSelected?.call(provider) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(provider),
          foregroundColor: _getTextColor(provider),
          elevation: 1,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _getBorderColor(provider),
              width: 1,
            ),
          ),
        ),
        child: isProviderLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(provider)),
          ),
        )
            : _buildCompactIcon(provider),
      ),
    );
  }

  Widget _buildCompactIcon(SocialProvider provider) {
    final iconPath = _getIconPath(provider);

    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: provider == SocialProvider.apple
            ? ColorFilter.mode(_getIconColor(provider), BlendMode.srcIn)
            : null,
      );
    }

    return Image.asset(
      iconPath,
      width: 24,
      height: 24,
    );
  }

  String _getIconPath(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return AppImages.iconGoogle;
      case SocialProvider.apple:
        return AppImages.iconApple;
      case SocialProvider.facebook:
        return AppImages.iconFacebook;
    }
  }

  Color _getBackgroundColor(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return Colors.white;
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.facebook:
        return AppColors.facebook;
    }
  }

  Color _getTextColor(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return AppColors.grey800;
      case SocialProvider.apple:
        return Colors.white;
      case SocialProvider.facebook:
        return Colors.white;
    }
  }

  Color _getBorderColor(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return AppColors.grey300;
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.facebook:
        return AppColors.facebook;
    }
  }

  Color _getIconColor(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return AppColors.grey800;
      case SocialProvider.apple:
        return Colors.white;
      case SocialProvider.facebook:
        return Colors.white;
    }
  }
}

// Add the translation extension if not already present
extension StringTranslation on String {
  String get tr => this; // This should use your actual translation system
}