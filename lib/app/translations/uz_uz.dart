import 'keys.dart';

/// Uzbek translations for authentication
const Map<String, String> uzUZ = {
  // General Actions
  TranslationKeys.ok: 'OK',
  TranslationKeys.cancel: 'Bekor qilish',
  TranslationKeys.confirm: 'Tasdiqlash',
  TranslationKeys.save: 'Saqlash',
  TranslationKeys.loading: 'Yuklanmoqda...',
  TranslationKeys.error: 'Xato',
  TranslationKeys.success: 'Muvaffaqiyatli',
  TranslationKeys.retry: 'Qayta urinish',

  // Authentication - Core Actions
  TranslationKeys.login: 'Kirish',
  TranslationKeys.register: 'Ro\'yxatdan o\'tish',
  TranslationKeys.signUp: 'Ro\'yxatdan o\'tish',
  TranslationKeys.signIn: 'Kirish',
  TranslationKeys.signOut: 'Chiqish',
  TranslationKeys.forgotPassword: 'Parolni unutdingizmi?',
  TranslationKeys.resetPassword: 'Parolni tiklash',
  TranslationKeys.changePassword: 'Parolni o\'zgartirish',

  // Authentication - Form Fields
  TranslationKeys.email: 'Elektron pochta',
  TranslationKeys.password: 'Parol',
  TranslationKeys.confirmPassword: 'Parolni tasdiqlang',
  TranslationKeys.currentPassword: 'Joriy parol',
  TranslationKeys.newPassword: 'Yangi parol',
  TranslationKeys.firstName: 'Ism',
  TranslationKeys.lastName: 'Familiya',
  TranslationKeys.fullName: 'To\'liq ism',
  TranslationKeys.username: 'Foydalanuvchi nomi',
  TranslationKeys.phoneNumber: 'Telefon raqami',
  TranslationKeys.dateOfBirth: 'Tug\'ilgan sana',
  TranslationKeys.rememberMe: 'Meni eslab qoling',

  // Social Authentication
  TranslationKeys.signInWithGoogle: 'Google orqali kirish',
  TranslationKeys.signInWithFacebook: 'Facebook orqali kirish',
  TranslationKeys.signInWithApple: 'Apple orqali kirish',
  TranslationKeys.or: 'YOKI',

  // Validation Messages
  TranslationKeys.fieldRequired: 'Bu maydon to\'ldirilishi shart',
  TranslationKeys.invalidEmail: 'Iltimos, to\'g\'ri elektron pochta manzilini kiriting',
  TranslationKeys.invalidPhone: 'Iltimos, to\'g\'ri telefon raqamini kiriting',
  TranslationKeys.passwordTooShort: 'Parol kamida 8 ta belgidan iborat bo\'lishi kerak',
  TranslationKeys.passwordsDontMatch: 'Parollar mos kelmaydi',
  TranslationKeys.invalidUsername: 'Foydalanuvchi nomi faqat harflar, raqamlar va ostki chiziqdan iborat bo\'lishi mumkin',
  TranslationKeys.usernameTooShort: 'Foydalanuvchi nomi kamida 3 ta belgidan iborat bo\'lishi kerak',
  TranslationKeys.nameTooShort: 'Ism kamida 2 ta belgidan iborat bo\'lishi kerak',

  // Authentication Success Messages
  TranslationKeys.loginSuccessful: 'Kirish muvaffaqiyatli amalga oshirildi',
  TranslationKeys.registrationSuccessful: 'Ro\'yxatdan o\'tish muvaffaqiyatli tugallandi',
  TranslationKeys.passwordChanged: 'Parol muvaffaqiyatli o\'zgartirildi',
  TranslationKeys.passwordResetSent: 'Parolni tiklash xati yuborildi',
  TranslationKeys.emailVerified: 'Elektron pochta muvaffaqiyatli tasdiqlandi',
  TranslationKeys.phoneVerified: 'Telefon raqami muvaffaqiyatli tasdiqlandi',

  // Authentication Error Messages
  TranslationKeys.loginFailed: 'Kirish amalga oshmadi. Ma\'lumotlaringizni tekshiring.',
  TranslationKeys.registrationFailed: 'Ro\'yxatdan o\'tish amalga oshmadi. Qayta urinib ko\'ring.',
  TranslationKeys.networkError: 'Internet aloqasi yo\'q. Ulanishni tekshiring.',
  TranslationKeys.serverError: 'Server xatosi. Keyinroq urinib ko\'ring.',
  TranslationKeys.unknownError: 'Nimadir noto\'g\'ri ketdi. Qayta urinib ko\'ring.',
  TranslationKeys.sessionExpired: 'Sessiya tugadi. Qaytadan kiring.',
  TranslationKeys.unauthorized: 'Sizda bu amalni bajarish uchun ruxsat yo\'q.',
  TranslationKeys.validationError: 'Xatolarni tuzating va qayta urinib ko\'ring.',

  // PIN & OTP
  TranslationKeys.enterPin: 'PIN ni kiriting',
  TranslationKeys.verifyPin: 'PIN ni tasdiqlang',
  TranslationKeys.enterOtp: 'Kodni kiriting',
  TranslationKeys.verifyOtp: 'Kodni tasdiqlang',
  TranslationKeys.resendOtp: 'Kodni qayta yuborish',
  TranslationKeys.otpSent: 'Kod muvaffaqiyatli yuborildi',
  TranslationKeys.invalidOtp: 'Noto\'g\'ri kod. Qayta urinib ko\'ring.',
  TranslationKeys.otpExpired: 'Kod muddati tugagan. Yangisini so\'rang.',

  // Biometric Authentication
  TranslationKeys.biometricLogin: 'Biometrik kirish',
  TranslationKeys.fingerprint: 'Barmoq izi',
  TranslationKeys.faceId: 'Yuz ID',
  TranslationKeys.biometricPrompt: 'Autentifikatsiya uchun barmoq izi yoki yuzingizni ishlating',
  TranslationKeys.biometricError: 'Biometrik autentifikatsiya xatosi',
  TranslationKeys.biometricNotAvailable: 'Biometrik autentifikatsiya mavjud emas',

  // Account Setup
  TranslationKeys.createAccount: 'Hisob yaratish',
  TranslationKeys.alreadyHaveAccount: 'Hisobingiz bormi?',
  TranslationKeys.dontHaveAccount: 'Hisobingiz yo\'qmi?',
  TranslationKeys.agreeToTerms: 'Men Foydalanish shartlari va Maxfiylik siyosati bilan roziman',
  TranslationKeys.termsOfService: 'Foydalanish shartlari',
  TranslationKeys.privacyPolicy: 'Maxfiylik siyosati',
  TranslationKeys.and: 'va',

  // Welcome & Onboarding
  TranslationKeys.welcome: 'Xush kelibsiz',
  TranslationKeys.welcomeBack: 'Qaytganingiz bilan!',
  TranslationKeys.getStarted: 'Boshlash',
  TranslationKeys.continueAsGuest: 'Mehmon sifatida davom etish',

  // Common Phrases for Auth
  TranslationKeys.pleaseWait: 'Iltimos, kuting...',
  TranslationKeys.tryAgain: 'Qayta urinish',
  TranslationKeys.checkConnection: 'Iltimos, internet ulanishini tekshiring',

  // Language-related keys
  TranslationKeys.language: 'Til',
  TranslationKeys.selectLanguage: 'Tilni tanlang',
  TranslationKeys.changingLanguage: 'Til o\'zgartirilmoqda...',
  TranslationKeys.languageChanged: 'Til muvaffaqiyatli o\'zgartirildi',
  TranslationKeys.languageChangeFailed: 'Tilni o\'zgartirib bo\'lmadi',
  TranslationKeys.systemLanguageNotSupported: 'Tizim tili qo\'llab-quvvatlanmaydi',
  TranslationKeys.resetToSystemLanguage: 'Tizim tiliga qaytarish',
  TranslationKeys.resetToDefaultLanguage: 'Standart tilga qaytarish',
  TranslationKeys.failedToResetLanguage: 'Tilni qaytarib bo\'lmadi',
};