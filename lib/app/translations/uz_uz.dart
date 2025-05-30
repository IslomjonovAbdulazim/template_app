import 'keys.dart';

/// Uzbek translations - Updated with all features
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

  // Terms of Service Keys
  'terms_effective_date': 'Kuchga kirish sanasi: 2025 yil 1 yanvar',
  'terms_introduction': 'Iltimos, ilovamizdan foydalanishdan oldin ushbu Foydalanish shartlarini diqqat bilan o\'qing. Xizmatimizga kirish yoki foydalanish orqali siz ushbu shartlarga rioya qilishga rozilik bildirasiz.',
  'terms_acceptance': 'Shartlarni qabul qilish',
  'terms_acceptance_content': 'Ushbu ilovani yuklab olish, o\'rnatish yoki ishlatish orqali siz ushbu Foydalanish shartlari va Maxfiylik siyosatimizni o\'qib, tushunganingizni va ularga rioya qilishga rozilik bildirasiz. Agar siz ushbu shartlarga rozi bo\'lmasangiz, iltimos, xizmatimizdan foydalanmang.',
  'terms_service_description': 'Xizmat tavsifi',
  'terms_service_description_content': 'Bizning ilovamiz raqamli xizmatlarni taqdim etadi, jumladan foydalanuvchi autentifikatsiyasi, ma\'lumotlarni boshqarish va interaktiv funksiyalar. Biz xizmatning har qanday jihatini istalgan vaqtda o\'zgartirish, to\'xtatish yoki tugatish huquqini saqlab qolamiz.',
  'terms_user_accounts': 'Foydalanuvchi hisoblari',
  'terms_user_accounts_content': 'Siz hisobingiz ma\'lumotlarining maxfiyligini saqlash va hisobingiz ostida sodir bo\'ladigan barcha harakatlar uchun javobgarsiz. Hisobingizni yaratishda aniq va to\'liq ma\'lumot berish va ma\'lumotlaringizni yangilab turish kerak.',
  'terms_user_conduct': 'Foydalanuvchi xulqi',
  'terms_user_conduct_content': 'Siz xizmatdan har qanday noqonuniy maqsadlarda yoki serverlarimiz yoki tarmoqlarimizga zarar etkazish, o\'chirish, ortiqcha yuklanish yoki buzilishiga olib kelishi mumkin bo\'lgan usullarda foydalanmaslikka rozilik bildirasiz. Xizmatning biror qismiga ruxsatsiz kirish uchun harakat qilmasligingiz kerak.',
  'terms_privacy_policy': 'Maxfiylik siyosati',
  'terms_privacy_policy_content': 'Sizning maxfiyligingiz biz uchun muhim. Bizning Maxfiylik siyosatimiz xizmatimizdan foydalanganda ma\'lumotlaringizni qanday to\'plash, ishlatish va himoya qilishimizni tushuntiradi. Xizmatimizdan foydalanish orqali siz Maxfiylik siyosatimizga ham rozilik bildirasiz.',
  'terms_intellectual_property': 'Intellektual mulk',
  'terms_intellectual_property_content': 'Xizmat va uning original kontenti, xususiyatlari va funksionalligi bizga tegishli va xalqaro mualliflik huquqi, savdo belgisi, patent, tijorat sirlari va boshqa intellektual mulk qonunlari bilan himoyalangan.',
  'terms_disclaimers': 'Javobgarlikdan voz kechish',
  'terms_disclaimers_content': 'Xizmat "bor holicha" va "mavjud holicha" asosida taqdim etiladi. Biz xizmat bo\'yicha hech qanday kafolat bermaymiz, jumladan sotuvga yaroqlilik, ma\'lum maqsad uchun mosligi yoki huquqbuzarlik bo\'lmasligi kafolatlari.',
  'terms_limitation_liability': 'Javobgarlik cheklovi',
  'terms_limitation_liability_content': 'Hech qanday holatda biz bilvosita, tasodifiy, maxsus, keyingi yoki jazo zararlaridan, jumladan foyda, ma\'lumotlar yoki foydalanishni yo\'qotishdan, xizmatdan foydalanishingiz bilan bog\'liq yoki undan kelib chiqadigan zararlar uchun javobgar bo\'lmaymiz.',
  'terms_termination': 'Tugatish',
  'terms_termination_content': 'Biz ushbu Foydalanish shartlarining har qanday buzilishi uchun oldindan ogohlantirmasdan hisobingizni va xizmatga kirishni darhol tugatishimiz yoki to\'xtatishimiz mumkin. Tugatishda xizmatdan foydalanish huquqingiz darhol to\'xtaydi.',
  'terms_governing_law': 'Qo\'llaniladigan qonun',
  'terms_governing_law_content': 'Ushbu Shartlar kompaniyamiz ro\'yxatdan o\'tgan yurisdiktsiya qonunlari bilan tartibga solinadi va talqin qilinadi, qonunlar to\'qnashuvi qoidalarini hisobga olmasdan.',
  'terms_changes': 'Shartlardagi o\'zgarishlar',
  'terms_changes_content': 'Biz ushbu Foydalanish shartlarini istalgan vaqtda o\'zgartirish huquqini saqlab qolamiz. Biz foydalanuvchilarni har qanday muhim o\'zgarishlar haqida elektron pochta orqali yoki ilova orqali xabardor qilamiz. Bunday o\'zgarishlardan keyin xizmatdan foydalanishni davom ettirish yangilangan shartlarni qabul qilishni anglatadi.',
  'terms_contact_info': 'Aloqa ma\'lumotlari',
  'terms_contact_info_content': 'Agar ushbu Foydalanish shartlari haqida savollaringiz bo\'lsa, iltimos, support@yourapp.com manziliga yoki ilovada berilgan aloqa ma\'lumotlari orqali murojaat qiling.',
  'terms_last_updated': 'Oxirgi yangilanish',
  'terms_last_updated_date': 'Ushbu shartlar oxirgi marta 2025 yil 1 yanvarda yangilangan. Biz amaliyotimizdagi yoki qo\'llaniladigan qonundagi o\'zgarishlarni aks ettirish uchun vaqti-vaqti bilan ushbu shartlarni yangilashimiz mumkin.',

  // Email Verification Keys
  'email_verified_success': 'Elektron pochta muvaffaqiyatli tasdiqlandi',
  'verify_email': 'Elektron pochtani tasdiqlash',
  'enter_verification_code': 'Tasdiqlash kodini kiriting',
  'verification_code_sent_to': 'Biz 6 xonali tasdiqlash kodini yuborgan manzig',
  'email_verified_successfully': 'Elektron pochta muvaffaqiyatli tasdiqlandi!',
  'email_verification_success_description': 'Sizning elektron pochtangiz muvaffaqiyatli tasdiqlandi. Endi siz hisobingizning barcha funksiyalaridan foydalanishingiz mumkin.',
  'welcome_aboard': 'Xush kelibsiz!',
  'welcome_message_description': 'Sizning hisobingiz to\'liq faollashtirildi. Kashf qilishni boshlang va biz taklif qiladigan barcha ajoyib funksiyalardan bahramand bo\'ling.',
  'continue_to_app': 'Ilovaga o\'tish',
  'didnt_receive_code': 'Kodni olmadingizmi?',
  'resend_verification_code': 'Tasdiqlash kodini qayta yuborish',
  'resend_in_seconds': '{seconds} soniyada qayta yuborish',
  'verification_tips': 'Tasdiqlash maslahatlari',
  'verification_tips_description': 'Agar xatni ko\'rmagan bo\'lsangiz, spam papkasini tekshiring. Kod 15 daqiqa davomida amal qiladi.',
  'wrong_email_address': 'Noto\'g\'ri elektron pochta manzili?',
  'change_email': 'Elektron pochtani o\'zgartirish',
  'internet_required_for_verification': 'Tasdiqlash uchun internet aloqasi kerak',
  'internet_required_for_resend': 'Kodni qayta yuborish uchun internet aloqasi kerak',
  'verification_code_sent': 'Tasdiqlash kodi yuborildi',
  'new_verification_code_sent': 'Yangi tasdiqlash kodi elektron pochtangizga yuborildi',
};