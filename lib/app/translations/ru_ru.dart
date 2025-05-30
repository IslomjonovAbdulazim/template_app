import 'keys.dart';

/// Russian translations for authentication
const Map<String, String> ruRU = {
  // General Actions
  TranslationKeys.ok: 'ОК',
  TranslationKeys.cancel: 'Отмена',
  TranslationKeys.confirm: 'Подтвердить',
  TranslationKeys.save: 'Сохранить',
  TranslationKeys.loading: 'Загрузка...',
  TranslationKeys.error: 'Ошибка',
  TranslationKeys.success: 'Успешно',
  TranslationKeys.retry: 'Повторить',

  // Authentication - Core Actions
  TranslationKeys.login: 'Вход',
  TranslationKeys.register: 'Регистрация',
  TranslationKeys.signUp: 'Зарегистрироваться',
  TranslationKeys.signIn: 'Войти',
  TranslationKeys.signOut: 'Выйти',
  TranslationKeys.forgotPassword: 'Забыли пароль?',
  TranslationKeys.resetPassword: 'Сбросить пароль',
  TranslationKeys.changePassword: 'Изменить пароль',

  // Authentication - Form Fields
  TranslationKeys.email: 'Электронная почта',
  TranslationKeys.password: 'Пароль',
  TranslationKeys.confirmPassword: 'Подтвердите пароль',
  TranslationKeys.currentPassword: 'Текущий пароль',
  TranslationKeys.newPassword: 'Новый пароль',
  TranslationKeys.firstName: 'Имя',
  TranslationKeys.lastName: 'Фамилия',
  TranslationKeys.fullName: 'Полное имя',
  TranslationKeys.username: 'Имя пользователя',
  TranslationKeys.phoneNumber: 'Номер телефона',
  TranslationKeys.dateOfBirth: 'Дата рождения',
  TranslationKeys.rememberMe: 'Запомнить меня',

  // Social Authentication
  TranslationKeys.signInWithGoogle: 'Войти через Google',
  TranslationKeys.signInWithFacebook: 'Войти через Facebook',
  TranslationKeys.signInWithApple: 'Войти через Apple',
  TranslationKeys.or: 'ИЛИ',

  // Validation Messages
  TranslationKeys.fieldRequired: 'Это поле обязательно для заполнения',
  TranslationKeys.invalidEmail: 'Пожалуйста, введите корректный email адрес',
  TranslationKeys.invalidPhone: 'Пожалуйста, введите корректный номер телефона',
  TranslationKeys.passwordTooShort: 'Пароль должен содержать минимум 8 символов',
  TranslationKeys.passwordsDontMatch: 'Пароли не совпадают',
  TranslationKeys.invalidUsername: 'Имя пользователя может содержать только буквы, цифры и знак подчёркивания',
  TranslationKeys.usernameTooShort: 'Имя пользователя должно содержать минимум 3 символа',
  TranslationKeys.nameTooShort: 'Имя должно содержать минимум 2 символа',

  // Authentication Success Messages
  TranslationKeys.loginSuccessful: 'Вход выполнен успешно',
  TranslationKeys.registrationSuccessful: 'Регистрация прошла успешно',
  TranslationKeys.passwordChanged: 'Пароль успешно изменён',
  TranslationKeys.passwordResetSent: 'Письмо для сброса пароля отправлено',
  TranslationKeys.emailVerified: 'Email успешно подтверждён',
  TranslationKeys.phoneVerified: 'Телефон успешно подтверждён',

  // Authentication Error Messages
  TranslationKeys.loginFailed: 'Ошибка входа. Проверьте свои данные.',
  TranslationKeys.registrationFailed: 'Ошибка регистрации. Попробуйте ещё раз.',
  TranslationKeys.networkError: 'Нет подключения к интернету. Проверьте соединение.',
  TranslationKeys.serverError: 'Ошибка сервера. Попробуйте позже.',
  TranslationKeys.unknownError: 'Что-то пошло не так. Попробуйте ещё раз.',
  TranslationKeys.sessionExpired: 'Сессия истекла. Войдите заново.',
  TranslationKeys.unauthorized: 'У вас нет прав для выполнения этого действия.',
  TranslationKeys.validationError: 'Исправьте ошибки и попробуйте снова.',

  // PIN & OTP
  TranslationKeys.enterPin: 'Введите PIN',
  TranslationKeys.verifyPin: 'Подтвердите PIN',
  TranslationKeys.enterOtp: 'Введите код',
  TranslationKeys.verifyOtp: 'Подтвердите код',
  TranslationKeys.resendOtp: 'Отправить код повторно',
  TranslationKeys.otpSent: 'Код успешно отправлен',
  TranslationKeys.invalidOtp: 'Неверный код. Попробуйте ещё раз.',
  TranslationKeys.otpExpired: 'Код истёк. Запросите новый.',

  // Biometric Authentication
  TranslationKeys.biometricLogin: 'Биометрический вход',
  TranslationKeys.fingerprint: 'Отпечаток пальца',
  TranslationKeys.faceId: 'Face ID',
  TranslationKeys.biometricPrompt: 'Используйте отпечаток пальца или лицо для аутентификации',
  TranslationKeys.biometricError: 'Ошибка биометрической аутентификации',
  TranslationKeys.biometricNotAvailable: 'Биометрическая аутентификация недоступна',

  // Account Setup
  TranslationKeys.createAccount: 'Создать аккаунт',
  TranslationKeys.alreadyHaveAccount: 'Уже есть аккаунт?',
  TranslationKeys.dontHaveAccount: 'Нет аккаунта?',
  TranslationKeys.agreeToTerms: 'Я согласен с Условиями использования и Политикой конфиденциальности',
  TranslationKeys.termsOfService: 'Условия использования',
  TranslationKeys.privacyPolicy: 'Политика конфиденциальности',
  TranslationKeys.and: 'и',

  // Welcome & Onboarding
  TranslationKeys.welcome: 'Добро пожаловать',
  TranslationKeys.welcomeBack: 'С возвращением!',
  TranslationKeys.getStarted: 'Начать',
  TranslationKeys.continueAsGuest: 'Продолжить как гость',

  // Common Phrases for Auth
  TranslationKeys.pleaseWait: 'Пожалуйста, подождите...',
  TranslationKeys.tryAgain: 'Попробовать снова',
  TranslationKeys.checkConnection: 'Пожалуйста, проверьте подключение к интернету',

  // Language-related keys
  TranslationKeys.language: 'Язык',
  TranslationKeys.selectLanguage: 'Выберите язык',
  TranslationKeys.changingLanguage: 'Смена языка...',
  TranslationKeys.languageChanged: 'Язык успешно изменён',
  TranslationKeys.languageChangeFailed: 'Не удалось изменить язык',
  TranslationKeys.systemLanguageNotSupported: 'Язык системы не поддерживается',
  TranslationKeys.resetToSystemLanguage: 'Сбросить на язык системы',
  TranslationKeys.resetToDefaultLanguage: 'Сбросить на язык по умолчанию',
  TranslationKeys.failedToResetLanguage: 'Не удалось сбросить язык',
};