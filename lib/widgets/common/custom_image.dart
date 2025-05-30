import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Custom image widget with caching, error handling, and loading states
class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showLoading;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CustomImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.showLoading = true,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.onTap,
  });

  /// Network image constructor
  const CustomImage.network({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.showLoading = true,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.onTap,
  }) : assetPath = null;

  /// Asset image constructor
  const CustomImage.asset({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.onTap,
  }) : imageUrl = null,
       placeholder = null,
       errorWidget = null,
       showLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget();

    // Apply container styling if needed
    if (borderRadius != null || border != null || backgroundColor != null) {
      imageWidget = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: border,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: imageWidget,
        ),
      );
    }

    // Add tap functionality if provided
    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildImageWidget() {
    // Asset image
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    // Network image with caching
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder:
            showLoading ? (context, url) => _buildLoadingWidget() : null,
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
    }

    // Fallback to placeholder or error widget
    return _buildErrorWidget();
  }

  Widget _buildLoadingWidget() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: AppColors.grey100,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: AppColors.grey100,
          child: Icon(
            Icons.image_not_supported_outlined,
            size:
                (width != null && height != null)
                    ? (width! < height! ? width! * 0.3 : height! * 0.3)
                    : 40,
            color: AppColors.grey400,
          ),
        );
  }
}

/// Avatar widget for user profile images
class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool showOnlineStatus;
  final bool isOnline;
  final Widget? badge;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 24,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.badge,
  });

  /// Large avatar constructor
  const CustomAvatar.large({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.badge,
  }) : radius = 40;

  /// Medium avatar constructor
  const CustomAvatar.medium({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.badge,
  }) : radius = 28;

  /// Small avatar constructor
  const CustomAvatar.small({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.badge,
  }) : radius = 20;

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = Stack(
      children: [
        _buildAvatar(context),
        if (showOnlineStatus) _buildOnlineIndicator(),
        if (badge != null) _buildBadge(),
      ],
    );

    if (onTap != null) {
      avatarWidget = GestureDetector(onTap: onTap, child: avatarWidget);
    }

    return avatarWidget;
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppColors.grey200,
        child: ClipOval(
          child: CustomImage.network(
            imageUrl: imageUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: _buildPlaceholder(theme),
            errorWidget: _buildPlaceholder(theme),
          ),
        ),
      );
    }

    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.primaryShade,
      child: Text(
        _getInitials(),
        style: AppTextStyles.titleMedium.copyWith(
          color: textColor ?? AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: radius * 0.4,
        height: radius * 0.4,
        decoration: BoxDecoration(
          color: isOnline ? AppColors.success : AppColors.grey400,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(top: -2, right: -2, child: badge!);
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';

    final words = name!.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}

/// Hero image widget for detail screens
class HeroImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final String? heroTag;
  final double? height;
  final BoxFit fit;
  final Widget? overlay;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const HeroImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.heroTag,
    this.height,
    this.fit = BoxFit.cover,
    this.overlay,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final imageHeight = height ?? mediaQuery.size.height * 0.3;

    Widget imageWidget = Container(
      width: double.infinity,
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomImage(
            imageUrl: imageUrl,
            assetPath: assetPath,
            fit: fit,
            placeholder: Container(
              color: AppColors.grey200,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (overlay != null) overlay!,
          if (actions != null) _buildActions(),
        ],
      ),
    );

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildActions() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children:
            actions!.map((action) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: action,
              );
            }).toList(),
      ),
    );
  }
}

/// Image gallery widget
class ImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final bool showIndicators;
  final bool enableSwipe;
  final double? height;
  final VoidCallback? onPageChanged;

  const ImageGallery({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.showIndicators = true,
    this.enableSwipe = true,
    this.height,
    this.onPageChanged,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final galleryHeight = widget.height ?? mediaQuery.size.height * 0.25;

    return Container(
      height: galleryHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics:
                widget.enableSwipe
                    ? const PageScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return CustomImage.network(
                imageUrl: widget.imageUrls[index],
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          if (widget.showIndicators && widget.imageUrls.length > 1)
            _buildIndicators(),
          if (widget.imageUrls.length > 1) _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            widget.imageUrls.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _previousImage,
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _nextImage,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onPageChanged?.call();
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

/// Image picker widget for selecting images
class ImagePickerWidget extends StatelessWidget {
  final String? currentImageUrl;
  final Function(String)? onImageSelected;
  final double size;
  final bool isEditable;
  final String? placeholder;

  const ImagePickerWidget({
    super.key,
    this.currentImageUrl,
    this.onImageSelected,
    this.size = 100,
    this.isEditable = true,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditable ? _showImagePicker : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.grey300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  currentImageUrl != null
                      ? CustomImage.network(
                        imageUrl: currentImageUrl!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      )
                      : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: size * 0.3,
                              color: AppColors.grey500,
                            ),
                            if (placeholder != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                placeholder!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
            ),
            if (isEditable)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() {
    // TODO: Implement image picker functionality
    // This would typically show a bottom sheet or dialog
    // with options to take photo or select from gallery
  }
}

/// Thumbnail grid widget for displaying image thumbnails
class ThumbnailGrid extends StatelessWidget {
  final List<String> imageUrls;
  final int crossAxisCount;
  final double aspectRatio;
  final double spacing;
  final Function(int)? onThumbnailTap;
  final int? maxDisplay;
  final Widget? moreWidget;

  const ThumbnailGrid({
    super.key,
    required this.imageUrls,
    this.crossAxisCount = 3,
    this.aspectRatio = 1.0,
    this.spacing = 8.0,
    this.onThumbnailTap,
    this.maxDisplay,
    this.moreWidget,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = maxDisplay ?? imageUrls.length;
    final showMore = maxDisplay != null && imageUrls.length > maxDisplay!;
    final itemsToShow = showMore ? maxDisplay! - 1 : displayCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: showMore ? maxDisplay! : itemsToShow,
      itemBuilder: (context, index) {
        if (showMore && index == maxDisplay! - 1) {
          return _buildMoreWidget();
        }

        return _buildThumbnail(index);
      },
    );
  }

  Widget _buildThumbnail(int index) {
    return GestureDetector(
      onTap: () => onThumbnailTap?.call(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImage.network(
          imageUrl: imageUrls[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMoreWidget() {
    if (moreWidget != null) return moreWidget!;

    final remainingCount = imageUrls.length - (maxDisplay! - 1);

    return GestureDetector(
      onTap: () => onThumbnailTap?.call(maxDisplay! - 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '+$remainingCount',
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Image zoom widget for viewing images in detail
class ImageZoomWidget extends StatefulWidget {
  final String imageUrl;
  final double? minScale;
  final double? maxScale;
  final bool enablePanAndZoom;

  const ImageZoomWidget({
    super.key,
    required this.imageUrl,
    this.minScale = 1.0,
    this.maxScale = 3.0,
    this.enablePanAndZoom = true,
  });

  @override
  State<ImageZoomWidget> createState() => _ImageZoomWidgetState();
}

class _ImageZoomWidgetState extends State<ImageZoomWidget> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enablePanAndZoom) {
      return CustomImage.network(
        imageUrl: widget.imageUrl,
        fit: BoxFit.contain,
      );
    }

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: widget.minScale ?? 1.0,
      maxScale: widget.maxScale ?? 3.0,
      child: CustomImage.network(
        imageUrl: widget.imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Reset zoom to original scale
  void resetZoom() {
    _transformationController.value = Matrix4.identity();
  }
}
