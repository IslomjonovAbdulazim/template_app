import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Simple, flexible text field with validation and consistent styling
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.inputFormatters,
    this.focusNode,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.inputLabel.copyWith(
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: widget.focusNode,
          autofocus: widget.autoFocus,
          decoration: _buildInputDecoration(isDark),
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          style: AppTextStyles.inputText.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
          validator: (value) {
            final error = widget.validator?.call(value);
            setState(() {
              _errorText = error;
            });
            return error;
          },
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(bool isDark) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.inputHint.copyWith(
        color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
        widget.prefixIcon,
        color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
      )
          : null,
      suffixIcon: _buildSuffixIcon(isDark),
      filled: true,
      fillColor: isDark ? DarkColors.inputFill : LightColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? DarkColors.inputBorder : LightColors.inputBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? DarkColors.inputBorder : LightColors.inputBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? DarkColors.inputFocusBorder : LightColors.inputFocusBorder,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? DarkColors.inputErrorBorder : LightColors.inputErrorBorder,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? DarkColors.inputErrorBorder : LightColors.inputErrorBorder,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      counterText: '', // Hide character counter
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
        ),
        onPressed: widget.onSuffixTap,
      );
    }

    return null;
  }
}

/// Specialized text fields for common use cases
class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final bool autoFocus;
  final List<String>? autofillHints;

  const EmailTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoFocus = false,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'email'.tr,
      hint: 'enter_email'.tr,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autoFocus: autoFocus,
      textCapitalization: TextCapitalization.none,
      autofillHints: autofillHints ?? const [AutofillHints.email],
      textInputAction: TextInputAction.next,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? label;
  final String? hint;
  final bool enabled;
  final bool autoFocus;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.label,
    this.hint,
    this.enabled = true,
    this.autoFocus = false,
    this.autofillHints,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label ?? 'password'.tr,
      hint: hint ?? 'enter_password'.tr,
      controller: controller,
      obscureText: true,
      prefixIcon: Icons.lock_outline,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autoFocus: autoFocus,
      autofillHints: autofillHints ?? const [AutofillHints.password],
      textInputAction: textInputAction ?? TextInputAction.done,
    );
  }
}

class NameTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final bool autoFocus;
  final List<String>? autofillHints;

  const NameTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoFocus = false,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: 'enter_$label'.tr.toLowerCase(),
      controller: controller,
      keyboardType: TextInputType.name,
      prefixIcon: Icons.person_outline,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autoFocus: autoFocus,
      textCapitalization: TextCapitalization.words,
      autofillHints: autofillHints,
      textInputAction: TextInputAction.next,
    );
  }
}

class PhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final bool autoFocus;

  const PhoneTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'phone'.tr,
      hint: 'enter_phone'.tr,
      controller: controller,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autoFocus: autoFocus,
      autofillHints: const [AutofillHints.telephoneNumber],
      textInputAction: TextInputAction.next,
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? hint;
  final bool enabled;
  final bool autoFocus;

  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint,
    this.enabled = true,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint ?? 'search'.tr,
      controller: controller,
      keyboardType: TextInputType.text,
      prefixIcon: Icons.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autoFocus: autoFocus,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.search,
    );
  }
}

class OtpTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final bool autoFocus;
  final int length;

  const OtpTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoFocus = true,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'verification_code'.tr,
      hint: 'enter_verification_code'.tr,
      controller: controller,
      keyboardType: TextInputType.number,
      prefixIcon: Icons.confirmation_number_outlined,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autoFocus: autoFocus,
      maxLength: length,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofillHints: const [AutofillHints.oneTimeCode],
      textInputAction: TextInputAction.done,
    );
  }
}