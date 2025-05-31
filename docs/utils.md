# Flutter Helper Utilities - Complete Reference Guide

## 📋 Overview
A comprehensive collection of Flutter utility files providing reusable functions, extensions, validation, and theming for financial/business applications. Built with GetX state management and Material 3 design system.

## 📁 File Structure
```
lib/utils/
├── extensions.dart      # Dart type extensions
├── validators.dart      # Form validation logic
├── app_theme.dart      # Theme configuration
└── helpers.dart        # General utility functions
```

---

## 🔧 extensions.dart

### Purpose
Extends built-in Dart/Flutter types with convenient methods for common operations.

### Imports Required
```dart
import 'dart:math' show pow;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
```

### String Extensions

#### Validation Methods
```dart
String email = "user@example.com";
bool isValid = email.isValidEmail;           // true
bool isPhone = "123-456-7890".isValidPhone;  // true
bool isNumeric = "12345".isNumeric;          // true
```

#### Text Formatting
```dart
String text = "hello world";
String capitalized = text.capitalizeFirstLetter;  // "Hello world"
String titleCase = text.capitalizeWords;          // "Hello World"
String cleaned = "  extra   spaces  ".removeExtraSpaces; // "extra spaces"
```

#### Case Conversion
```dart
String camelCase = "user_name".toCamelCase;     // "userName"
String snakeCase = "userName".toSnakeCase;      // "user_name"
String pascalCase = "user_name".toPascalCase;   // "UserName"
```

#### Data Conversion
```dart
String numberStr = "123";
int? number = numberStr.toIntOrNull;            // 123
double? decimal = "123.45".toDoubleOrNull;      // 123.45
DateTime? date = "2024-01-01".toDateTimeOrNull; // DateTime object
```

#### String Manipulation
```dart
String long = "This is a very long text";
String truncated = long.truncate(10);           // "This is..."
String masked = "1234567890".mask(2, 2);       // "12****7890"
String reversed = "hello".reverse;              // "olleh"
```

#### Phone & Currency Formatting
```dart
String phone = "1234567890".formatAsPhone;     // "(123) 456-7890"
String currency = "123.45".formatAsCurrency(); // "$123.45"
```

### Nullable String Extensions
```dart
String? nullableString = null;
bool isEmpty = nullableString.isNullOrEmpty;     // true
String safe = nullableString.orEmpty();         // ""
String withDefault = nullableString.orDefault("N/A"); // "N/A"
```

### DateTime Extensions

#### Date Checks
```dart
DateTime now = DateTime.now();
bool today = now.isToday;                       // true
bool thisWeek = now.isThisWeek;                 // true
bool weekend = now.isWeekend;                   // depends on day
```

#### Date Formatting
```dart
DateTime date = DateTime.now();
String formatted = date.formatDefault;          // "2024-01-01"
String timeAgo = date.timeAgo;                  // "2h ago"
String apiFormat = date.formatForApi;           // ISO format
```

#### Date Calculations
```dart
DateTime start = DateTime.now();
DateTime endOfDay = start.endOfDay;             // 23:59:59.999
DateTime nextBusinessDay = start.addBusinessDays(5); // Skip weekends
DateTime monthStart = start.startOfMonth;        // First day of month
```

### BuildContext Extensions

#### Screen Information
```dart
// In a Widget build method:
double width = context.screenWidth;             // Screen width
double height = context.screenHeight;           // Screen height
bool isTablet = context.isTablet;               // true if width >= 768
bool keyboardVisible = context.isKeyboardVisible; // Keyboard state
```

#### Theme Access
```dart
ThemeData theme = context.theme;                // Current theme
ColorScheme colors = context.colorScheme;       // Color scheme
bool isDark = context.isDarkMode;               // Dark mode check
```

#### UI Helpers
```dart
// Show snackbar
context.showSnackBar("Success!", backgroundColor: Colors.green);

// Hide keyboard
context.hideKeyboard();

// Request focus
FocusNode focusNode = FocusNode();
context.requestFocus(focusNode);
```

### List Extensions
```dart
List<int> numbers = [1, 2, 3, 2, 1];
int? safe = numbers.elementAtOrNull(10);        // null (safe access)
List<int> unique = numbers.unique;              // [1, 2, 3]
List<List<int>> chunks = numbers.chunk(2);     // [[1, 2], [3, 2], [1]]
int? random = numbers.randomElement;            // Random element
```

### Number Extensions

#### Double Extensions
```dart
double amount = 123.456;
String currency = amount.toCurrency();          // "$123.46"
String percent = 0.75.toPercentage();           // "75.0%"
double rounded = amount.roundToDecimalPlaces(2); // 123.46
```

#### Integer Extensions
```dart
int size = 1024000;
String fileSize = size.formatAsFileSize;        // "1000.0KB"
bool even = 4.isEven;                          // true
Duration delay = 5.seconds;                     // 5 second duration
```

---

## ✅ validators.dart

### Purpose
Centralized validation logic for all form inputs with consistent error messages.

### Imports Required
```dart
import '../constants/app_constants.dart';
```

### Basic Validation

#### Required Fields
```dart
String? error = Validators.required(value, 'Username');
// Returns: "Username is required" if empty, null if valid
```

#### Email Validation
```dart
String? emailError = Validators.email("user@example.com");
// Returns: null if valid, error message if invalid
```

#### Password Validation
```dart
String? passwordError = Validators.password("MyPass123!");
// Checks: length, uppercase, lowercase, numbers, special chars
```

### Authentication Validators
```dart
// Confirm password
String? confirmError = Validators.confirmPassword(
  confirmValue, 
  originalPassword
);

// Username validation
String? usernameError = Validators.username("john_doe123");
```

### Financial Validators
```dart
// Credit card validation (includes Luhn algorithm)
String? cardError = Validators.creditCard("4532015112830366");

// CVV validation
String? cvvError = Validators.cvv("123");

// Expiry date (MM/YY format)
String? expiryError = Validators.expiryDate("12/25");
```

### Security Validators
```dart
// PIN validation
String? pinError = Validators.pin("1234");

// OTP validation
String? otpError = Validators.otp("123456");
```

### Advanced Validation

#### Length Constraints
```dart
String? lengthError = Validators.length(value, 5, 20, 'Description');
String? minError = Validators.minLength(value, 3, 'Name');
String? maxError = Validators.maxLength(value, 100, 'Bio');
```

#### Combining Validators
```dart
String? result = Validators.combine(emailInput, [
  (v) => Validators.required(v, 'Email'),
  Validators.email,
  (v) => Validators.maxLength(v, 255, 'Email'),
]);
```

#### Custom Validation
```dart
String? customError = Validators.custom(
  value,
  (v) => v?.contains('@company.com') ?? false,
  'Must be a company email'
);
```

### Validation Utilities

#### Password Strength
```dart
int strength = ValidationUtils.getPasswordStrength("MyPass123!");
// Returns: 0-5 (strength level)

String strengthText = ValidationUtils.getPasswordStrengthText(strength);
// Returns: "Very Weak", "Weak", "Good", "Strong", "Very Strong"
```

#### Format Checks
```dart
bool isEmail = ValidationUtils.isValidEmail("test@example.com");
bool isPhone = ValidationUtils.isValidPhone("+1-234-567-8900");
bool isStrong = ValidationUtils.isStrongPassword("MyPass123!");
```

---

## 🎨 app_theme.dart

### Purpose
Complete Material 3 theme configuration with financial app-specific colors and components.

### Imports Required
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'dart:math' as math;
```

### Basic Usage

#### Apply Theme
```dart
// In main.dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ... other properties
)
```

### Financial Colors Extension

#### Access Financial Colors
```dart
// In any widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final financialColors = Theme.of(context).extension<FinancialColors>()!;
    
    return Container(
      color: financialColors.debt,          // Red for debts
      child: Text(
        'Debt Amount',
        style: TextStyle(color: financialColors.credit), // Green for credits
      ),
    );
  }
}
```

#### Available Financial Colors
```dart
final colors = FinancialColors.light; // or FinancialColors.dark

Color debtColor = colors.debt!;                    // Red
Color creditColor = colors.credit!;                // Green
Color pendingColor = colors.pending!;              // Orange
Color debtBg = colors.debtBackground!;             // Light red
Color creditBg = colors.creditBackground!;         // Light green
Color positiveAmount = colors.positiveAmount!;     // For positive numbers
Color negativeAmount = colors.negativeAmount!;     // For negative numbers
```

### Theme Utilities

#### Get Financial Colors
```dart
FinancialColors colors = DebtThemeUtils.getFinancialColors(context);
```

#### Amount Color Based on Value
```dart
double amount = -150.50;
Color amountColor = DebtThemeUtils.getAmountColor(context, amount);
// Returns red for negative, green for positive, grey for zero
```

#### Check Theme Mode
```dart
bool isDarkMode = DebtThemeUtils.isDark(context);
```

#### Get Financial Card Decoration
```dart
BoxDecoration cardDecoration = DebtThemeUtils.getFinancialCardDecoration(
  context,
  backgroundColor: Colors.white,
  elevation: 4,
  borderRadius: 12,
);
```

#### Amount Gradient
```dart
LinearGradient gradient = DebtThemeUtils.getAmountGradient(-250.0);
// Returns debt gradient for negative amounts
```

---

## 🛠️ helpers.dart

### Purpose
General utility functions for common operations throughout the application.

### Imports Required
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
```

### Random Generation

#### Strings and Numbers
```dart
String randomStr = Helpers.generateRandomString(10); // Random 10-char string
String withNumbers = Helpers.generateRandomString(8, includeNumbers: true);
String withSpecial = Helpers.generateRandomString(12, includeSpecialChars: true);

int randomInt = Helpers.generateRandomNumber(1, 100);     // 1-100
double randomDouble = Helpers.generateRandomDouble(0.0, 1.0); // 0.0-1.0
```

#### UUID and Colors
```dart
String uuid = Helpers.generateUuid();                    // UUID v4
Color randomColor = Helpers.generateRandomColor();       // Random RGB
Color nameColor = Helpers.generateColorFromString("John"); // Consistent color for name
```

### Performance Helpers

#### Debounce and Throttle
```dart
// Debounce: Execute only after delay with no new calls
Helpers.debounce(() {
  print('Search executed');
}, delay: Duration(milliseconds: 300));

// Throttle: Execute at most once per duration
Helpers.throttle(() {
  print('API call');
}, duration: Duration(seconds: 1));
```

#### Retry Mechanism
```dart
Future<String> result = await Helpers.retry<String>(
  () async => await apiCall(),
  maxAttempts: 3,
  delay: Duration(seconds: 2),
);
```

### Formatting

#### Currency and Numbers
```dart
String currency = Helpers.formatCurrency(1234.56);       // "$1,234.56"
String number = Helpers.formatNumber(1234567);           // "1,234,567"
String percentage = Helpers.formatPercentage(0.1567);    // "15.7%"
String fileSize = Helpers.formatFileSize(1048576);       // "1.0MB"
```

#### Calculations
```dart
double percent = Helpers.calculatePercentage(25, 100);    // 25.0
double change = Helpers.calculatePercentageChange(100, 120); // 20.0
double rounded = Helpers.roundToDecimalPlaces(3.14159, 2); // 3.14
```

### Device Interaction

#### Clipboard Operations
```dart
await Helpers.copyToClipboard("Hello World");
String? clipboardText = await Helpers.getFromClipboard();
```

#### Haptic Feedback
```dart
await Helpers.vibrate(duration: Duration(milliseconds: 200));
```

#### Keyboard Management
```dart
Helpers.hideKeyboard(context);
```

### Dialogs and UI

#### Loading Dialog
```dart
Helpers.showLoadingDialog(context, message: "Processing...");
// Later...
Helpers.hideLoadingDialog(context);
```

#### Confirmation Dialog
```dart
bool confirmed = await Helpers.showConfirmationDialog(
  context,
  title: "Delete Item",
  message: "Are you sure you want to delete this item?",
  confirmText: "Delete",
  cancelText: "Cancel",
);
```

### External App Integration

#### URL Launching
```dart
bool success = await Helpers.launchURL("https://example.com");
bool emailSent = await Helpers.launchEmail(
  "support@example.com",
  subject: "Help Request",
  body: "I need help with...",
);
bool callMade = await Helpers.launchPhone("+1234567890");
bool smsSent = await Helpers.launchSMS("+1234567890", message: "Hello!");
```

### File Operations

#### File Management
```dart
String docsPath = await Helpers.getAppDocumentsDirectory();
String cachePath = await Helpers.getAppCacheDirectory();

bool saved = await Helpers.saveStringToFile("content", "myfile.txt");
String? content = await Helpers.readStringFromFile("myfile.txt");
bool exists = await Helpers.fileExists("myfile.txt");
bool deleted = await Helpers.deleteFile("myfile.txt");
int size = await Helpers.getFileSize("myfile.txt");
```

#### JSON Operations
```dart
Map<String, dynamic>? map = Helpers.jsonStringToMap('{"key": "value"}');
String? jsonStr = Helpers.mapToJsonString({"key": "value"});
bool isValid = Helpers.isValidJson('{"valid": true}');
```

### Platform Detection

#### Device Information
```dart
String deviceType = Helpers.getDeviceType();    // "phone", "tablet", "desktop"
bool isTablet = Helpers.isTablet();
bool isPhone = Helpers.isPhone();
bool isDesktop = Helpers.isDesktop();

String platform = Helpers.getPlatformName();    // "Android", "iOS", etc.
bool isMobile = Helpers.isMobile();
bool isDesktopPlatform = Helpers.isDesktopPlatform();
```

### Text Utilities

#### Name Processing
```dart
String initials = Helpers.getInitials("John Doe");        // "JD"
String cleanPhone = Helpers.cleanPhoneNumber("(123) 456-7890"); // "1234567890"
String formattedPhone = Helpers.formatPhoneNumber("1234567890"); // "(123) 456-7890"
```

### Date and Location

#### Date Utilities
```dart
bool sameDay = Helpers.isSameDay(date1, date2);
int age = Helpers.calculateAge(DateTime(1990, 1, 1));
await Helpers.delay(Duration(seconds: 2));              // Async delay
```

#### Distance Calculation
```dart
double distance = Helpers.calculateDistance(
  40.7128, -74.0060,  // New York
  34.0522, -118.2437,  // Los Angeles
);
String formatted = Helpers.formatDistance(distance);     // "3944.4km"
```

---

## 🚀 Usage Examples

### Complete Form Validation
```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => Validators.combine(value, [
              (v) => Validators.required(v, 'Email'),
              Validators.email,
            ]),
            onSaved: (value) => email = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: Validators.password,
            onSaved: (value) => password = value,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Process login
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Financial Amount Display
```dart
class AmountDisplay extends StatelessWidget {
  final double amount;
  
  const AmountDisplay({required this.amount});

  @override
  Widget build(BuildContext context) {
    final financialColors = Theme.of(context).extension<FinancialColors>()!;
    final amountColor = DebtThemeUtils.getAmountColor(context, amount);
    
    return Container(
      decoration: DebtThemeUtils.getFinancialCardDecoration(context),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            amount.formatAsCurrency(),
            style: context.textTheme.headlineMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            amount > 0 ? 'Credit' : 'Debt',
            style: TextStyle(color: amountColor),
          ),
        ],
      ),
    );
  }
}
```

### Responsive Layout with Extensions
```dart
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.isTablet ? context.screenWidth * 0.6 : context.screenWidth,
      child: Column(
        children: [
          if (context.isPhone) PhoneLayout(),
          if (context.isTablet) TabletLayout(),
          ElevatedButton(
            onPressed: () {
              context.showSnackBar('Success!');
              context.hideKeyboard();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

---

## 📦 Required Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                    # State management
  google_fonts: ^6.2.1           # Typography
  intl: ^0.19.0                  # Internationalization
  path_provider: ^2.1.5          # File system access
  url_launcher: ^6.3.1           # External URLs
  shared_preferences: ^2.3.3     # Simple storage
```

---

## 🎯 Best Practices

### 1. Extension Usage
- Use extensions for frequently used operations
- Keep extension methods focused and single-purpose
- Prefer extensions over static utility classes

### 2. Validation Strategy
- Combine validators for complex validation logic
- Use consistent error messages across the app
- Implement client-side validation for better UX

### 3. Theme Integration
- Use financial colors extension for money-related UI
- Leverage theme utilities for consistent styling
- Support both light and dark themes

### 4. Performance Optimization
- Use debounce for search inputs
- Use throttle for API calls
- Implement retry logic for network operations

### 5. Error Handling
- Always handle null cases in utility functions
- Provide fallback values for critical operations
- Use try-catch blocks for file and network operations

---

## 🔧 Constants Required

Create `app_constants.dart` with:

```dart
class AppConstants {
  // Validation regex patterns
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]';
  
  // Length constraints
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxNameLength = 50;
  static const int pinLength = 4;
  static const int otpLength = 6;
  
  // Formatting
  static const String currencySymbol = '\$';
  static const int decimalPlaces = 2;
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  
  // UI
  static const Duration snackBarDuration = Duration(seconds: 3);
}
```

This comprehensive reference provides everything needed to understand and implement the Flutter helper utilities in any project.