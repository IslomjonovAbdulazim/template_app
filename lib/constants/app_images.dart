/// Image asset paths and management
/// Centralized location for all image assets used throughout the app
class AppImages {
  AppImages._();

  // Base asset paths
  static const String _basePath = 'assets/images/';
  static const String _iconsPath = '${_basePath}icons/';
  static const String _illustrationsPath = '${_basePath}illustrations/';
  static const String _backgroundsPath = '${_basePath}backgrounds/';

  // App Branding & Logo
  static const String appLogo = '${_basePath}app_logo.png';
  static const String appLogoWhite = '${_basePath}app_logo_white.png';
  static const String appLogoIcon = '${_basePath}app_logo_icon.png';
  static const String splashLogo = '${_basePath}splash_logo.png';

  // Common Icons
  static const String _commonIcons = '${_iconsPath}common/';
  static const String iconHome = '${_commonIcons}home.svg';
  static const String iconSearch = '${_commonIcons}search.svg';
  static const String iconNotification = '${_commonIcons}notification.svg';
  static const String iconProfile = '${_commonIcons}profile.svg';
  static const String iconSettings = '${_commonIcons}settings.svg';
  static const String iconMenu = '${_commonIcons}menu.svg';
  static const String iconBack = '${_commonIcons}back.svg';
  static const String iconClose = '${_commonIcons}close.svg';
  static const String iconCheck = '${_commonIcons}check.svg';
  static const String iconCheckCircle = '${_commonIcons}check_circle.svg';
  static const String iconWarning = '${_commonIcons}warning.svg';
  static const String iconError = '${_commonIcons}error.svg';
  static const String iconInfo = '${_commonIcons}info.svg';
  static const String iconEdit = '${_commonIcons}edit.svg';
  static const String iconDelete = '${_commonIcons}delete.svg';
  static const String iconShare = '${_commonIcons}share.svg';
  static const String iconDownload = '${_commonIcons}download.svg';
  static const String iconUpload = '${_commonIcons}upload.svg';
  static const String iconRefresh = '${_commonIcons}refresh.svg';
  static const String iconFilter = '${_commonIcons}filter.svg';
  static const String iconSort = '${_commonIcons}sort.svg';
  static const String iconCalendar = '${_commonIcons}calendar.svg';
  static const String iconClock = '${_commonIcons}clock.svg';
  static const String iconLocation = '${_commonIcons}location.svg';
  static const String iconPhone = '${_commonIcons}phone.svg';
  static const String iconEmail = '${_commonIcons}email.svg';
  static const String iconWebsite = '${_commonIcons}website.svg';
  static const String iconCamera = '${_commonIcons}camera.svg';
  static const String iconGallery = '${_commonIcons}gallery.svg';
  static const String iconDocument = '${_commonIcons}document.svg';

  // Navigation Icons
  static const String _navigationIcons = '${_iconsPath}navigation/';
  static const String navHome = '${_navigationIcons}nav_home.svg';
  static const String navHomeActive = '${_navigationIcons}nav_home_active.svg';
  static const String navSearch = '${_navigationIcons}nav_search.svg';
  static const String navSearchActive = '${_navigationIcons}nav_search_active.svg';
  static const String navFavorites = '${_navigationIcons}nav_favorites.svg';
  static const String navFavoritesActive = '${_navigationIcons}nav_favorites_active.svg';
  static const String navProfile = '${_navigationIcons}nav_profile.svg';
  static const String navProfileActive = '${_navigationIcons}nav_profile_active.svg';

  // Authentication Icons
  static const String _authIcons = '${_iconsPath}auth/';
  static const String iconUser = '${_authIcons}user.svg';
  static const String iconLock = '${_authIcons}lock.svg';
  static const String iconUnlock = '${_authIcons}unlock.svg';
  static const String iconEye = '${_authIcons}eye.svg';
  static const String iconEyeOff = '${_authIcons}eye_off.svg';
  static const String iconFingerprint = '${_authIcons}fingerprint.svg';
  static const String iconFaceId = '${_authIcons}face_id.svg';
  static const String iconGoogle = '${_authIcons}google.svg';
  static const String iconFacebook = '${_authIcons}facebook.svg';
  static const String iconApple = '${_authIcons}apple.svg';
  static const String iconTwitter = '${_authIcons}twitter.svg';

  // Payment Icons
  static const String _paymentIcons = '${_iconsPath}payment/';
  static const String iconCreditCard = '${_paymentIcons}credit_card.svg';
  static const String iconPaypal = '${_paymentIcons}paypal.svg';
  static const String iconVisa = '${_paymentIcons}visa.svg';
  static const String iconMastercard = '${_paymentIcons}mastercard.svg';
  static const String iconAmex = '${_paymentIcons}amex.svg';
  static const String iconWallet = '${_paymentIcons}wallet.svg';
  static const String iconBankTransfer = '${_paymentIcons}bank_transfer.svg';

  // Status Icons
  static const String _statusIcons = '${_iconsPath}status/';
  static const String statusSuccess = '${_statusIcons}success.svg';
  static const String statusWarning = '${_statusIcons}warning.svg';
  static const String statusError = '${_statusIcons}error.svg';
  static const String statusInfo = '${_statusIcons}info.svg';
  static const String statusPending = '${_statusIcons}pending.svg';
  static const String statusProcessing = '${_statusIcons}processing.svg';

  // Onboarding Illustrations
  static const String _onboardingIllustrations = '${_illustrationsPath}onboarding/';
  static const String onboarding1 = '${_onboardingIllustrations}onboarding_1.svg';
  static const String onboarding2 = '${_onboardingIllustrations}onboarding_2.svg';
  static const String onboarding3 = '${_onboardingIllustrations}onboarding_3.svg';
  static const String welcome = '${_onboardingIllustrations}welcome.svg';

  // Empty States Illustrations
  static const String _emptyStates = '${_illustrationsPath}empty_states/';
  static const String emptySearch = '${_emptyStates}empty_search.svg';
  static const String emptyFavorites = '${_emptyStates}empty_favorites.svg';
  static const String emptyNotifications = '${_emptyStates}empty_notifications.svg';
  static const String emptyCart = '${_emptyStates}empty_cart.svg';
  static const String emptyData = '${_emptyStates}empty_data.svg';
  static const String emptyInbox = '${_emptyStates}empty_inbox.svg';

  // Error Illustrations
  static const String _errorIllustrations = '${_illustrationsPath}errors/';
  static const String error404 = '${_errorIllustrations}error_404.svg';
  static const String error500 = '${_errorIllustrations}error_500.svg';
  static const String errorNetwork = '${_errorIllustrations}error_network.svg';
  static const String errorMaintenance = '${_errorIllustrations}error_maintenance.svg';
  static const String errorGeneral = '${_errorIllustrations}error_general.svg';

  // Background Images
  static const String backgroundSplash = '${_backgroundsPath}splash_background.png';
  static const String backgroundLogin = '${_backgroundsPath}login_background.png';
  static const String backgroundOnboarding = '${_backgroundsPath}onboarding_background.png';
  static const String backgroundPattern = '${_backgroundsPath}pattern_background.png';
  static const String backgroundGradient = '${_backgroundsPath}gradient_background.png';

  // Placeholder Images
  static const String placeholderUser = '${_basePath}placeholder_user.png';
  static const String placeholderImage = '${_basePath}placeholder_image.png';
  static const String placeholderAvatar = '${_basePath}placeholder_avatar.png';
  static const String placeholderProduct = '${_basePath}placeholder_product.png';

  // Country Flags (if needed)
  static const String _flagsPath = '${_basePath}flags/';
  static const String flagUS = '${_flagsPath}us.png';
  static const String flagUK = '${_flagsPath}uk.png';
  static const String flagSA = '${_flagsPath}sa.png'; // Saudi Arabia
  static const String flagUAE = '${_flagsPath}uae.png';

  // Category/Feature Icons
  static const String _categoryIcons = '${_iconsPath}categories/';
  static const String categoryFood = '${_categoryIcons}food.svg';
  static const String categoryTravel = '${_categoryIcons}travel.svg';
  static const String categoryShopping = '${_categoryIcons}shopping.svg';
  static const String categoryHealth = '${_categoryIcons}health.svg';
  static const String categoryEducation = '${_categoryIcons}education.svg';
  static const String categoryEntertainment = '${_categoryIcons}entertainment.svg';

  /// Get all image assets as a list (useful for preloading)
  static List<String> get allImages => [
    appLogo,
    appLogoWhite,
    appLogoIcon,
    splashLogo,
    backgroundSplash,
    backgroundLogin,
    backgroundOnboarding,
    placeholderUser,
    placeholderImage,
    placeholderAvatar,
    placeholderProduct,
  ];

  /// Get all SVG icons as a list
  static List<String> get allSvgIcons => [
    iconHome,
    iconSearch,
    iconNotification,
    iconProfile,
    iconSettings,
    iconMenu,
    iconBack,
    iconClose,
    iconCheck,
    iconEdit,
    iconDelete,
    iconShare,
    iconUser,
    iconLock,
    iconEye,
    iconEyeOff,
    iconGoogle,
    iconFacebook,
    iconApple,
    statusSuccess,
    statusWarning,
    statusError,
    statusInfo,
    onboarding1,
    onboarding2,
    onboarding3,
    emptySearch,
    emptyFavorites,
    emptyNotifications,
    error404,
    error500,
    errorNetwork,
  ];

  /// Get navigation icons map
  static Map<String, Map<String, String>> get navigationIcons => {
    'home': {'inactive': navHome, 'active': navHomeActive},
    'search': {'inactive': navSearch, 'active': navSearchActive},
    'favorites': {'inactive': navFavorites, 'active': navFavoritesActive},
    'profile': {'inactive': navProfile, 'active': navProfileActive},
  };

  /// Get social login icons
  static Map<String, String> get socialIcons => {
    'google': iconGoogle,
    'facebook': iconFacebook,
    'apple': iconApple,
    'twitter': iconTwitter,
  };

  /// Get payment method icons
  static Map<String, String> get paymentIcons => {
    'visa': iconVisa,
    'mastercard': iconMastercard,
    'amex': iconAmex,
    'paypal': iconPaypal,
    'wallet': iconWallet,
    'bank_transfer': iconBankTransfer,
  };

  /// Get status icons map
  static Map<String, String> get statusIcons => {
    'success': statusSuccess,
    'warning': statusWarning,
    'error': statusError,
    'info': statusInfo,
    'pending': statusPending,
    'processing': statusProcessing,
  };

  /// Get empty state illustrations
  static Map<String, String> get emptyStateIllustrations => {
    'search': emptySearch,
    'favorites': emptyFavorites,
    'notifications': emptyNotifications,
    'cart': emptyCart,
    'data': emptyData,
    'inbox': emptyInbox,
  };

  /// Get error illustrations
  static Map<String, String> get errorIllustrations => {
    '404': error404,
    '500': error500,
    'network': errorNetwork,
    'maintenance': errorMaintenance,
    'general': errorGeneral,
  };

  /// Check if asset is SVG
  static bool isSvg(String assetPath) {
    return assetPath.endsWith('.svg');
  }

  /// Check if asset is PNG
  static bool isPng(String assetPath) {
    return assetPath.endsWith('.png');
  }

  /// Check if asset is JPG/JPEG
  static bool isJpg(String assetPath) {
    return assetPath.endsWith('.jpg') || assetPath.endsWith('.jpeg');
  }

  /// Get asset type
  static String getAssetType(String assetPath) {
    if (isSvg(assetPath)) return 'svg';
    if (isPng(assetPath)) return 'png';
    if (isJpg(assetPath)) return 'jpg';
    return 'unknown';
  }

  /// Get icon by name (returns null if not found)
  static String? getIconByName(String iconName) {
    final iconMap = {
      'home': iconHome,
      'search': iconSearch,
      'notification': iconNotification,
      'profile': iconProfile,
      'settings': iconSettings,
      'menu': iconMenu,
      'back': iconBack,
      'close': iconClose,
      'check': iconCheck,
      'edit': iconEdit,
      'delete': iconDelete,
      'share': iconShare,
      'user': iconUser,
      'lock': iconLock,
      'eye': iconEye,
      'eye_off': iconEyeOff,
      'google': iconGoogle,
      'facebook': iconFacebook,
      'apple': iconApple,
    };
    return iconMap[iconName];
  }
}