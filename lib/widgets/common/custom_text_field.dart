import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Custom text field widget with enhanced styling and validation
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool isEnabled;
  final bool isRequired;
  final bool autofocus;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final bool filled;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.isEnabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.inputFormatters,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.filled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Email text field constructor
  const CustomTextField.email({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
  }) : keyboardType = TextInputType.emailAddress,
        textInputAction = TextInputAction.next,
        isPassword = false,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        prefixIcon = const Icon(Icons.email_outlined),
        suffixIcon = null,
        onTap = null,
        inputFormatters = null,
        textAlign = TextAlign.start,
        borderColor = null,
        focusedBorderColor = null,
        errorBorderColor = null,
        filled = true,
        textCapitalization = TextCapitalization.none;

  /// Password text field constructor
  const CustomTextField.password({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
  }) : keyboardType = TextInputType.visiblePassword,
        textInputAction = TextInputAction.done,
        isPassword = true,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        prefixIcon = const Icon(Icons.lock_outlined),
        suffixIcon = null,
        onTap = null,
        inputFormatters = null,
        textAlign = TextAlign.start,
        borderColor = null,
        focusedBorderColor = null,
        errorBorderColor = null,
        filled = true,
        textCapitalization = TextCapitalization.none;

  /// Phone text field constructor
  const CustomTextField.phone({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
  }) : keyboardType = TextInputType.phone,
        textInputAction = TextInputAction.next,
        isPassword = false,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        prefixIcon = const Icon(Icons.phone_outlined),
        suffixIcon = null,
        onTap = null,
        inputFormatters = null,
        textAlign = TextAlign.start,
        borderColor = null,
        focusedBorderColor = null,
        errorBorderColor = null,
        filled = true,
        textCapitalization = TextCapitalization.none;

  /// Search text field constructor
  const CustomTextField.search({
    super.key,
    this.hint,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
  }) : keyboardType = TextInputType.text,
        textInputAction = TextInputAction.search,
        isPassword = false,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        prefixIcon = const Icon(Icons.search),
        suffixIcon = null,
        onTap = null,
        inputFormatters = null,
        textAlign = TextAlign.start,
        borderColor = null,
        focusedBorderColor = null,
        errorBorderColor = null,
        filled = true,
        textCapitalization = TextCapitalization.none,
        label = null,
        helperText = null,
        errorText = null,
        isRequired = false,
        validator = null,
        labelStyle = null;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _buildLabel(theme, hasError),
          const SizedBox(height: 8),
        ],
        _buildTextField(theme, hasError),
        if (widget.helperText != null || hasError) ...[
          const SizedBox(height: 4),
          _buildHelperText(theme, hasError),
        ],
      ],
    );
  }

  Widget _buildLabel(ThemeData theme, bool hasError) {
    return RichText(
      text: TextSpan(
        style: widget.labelStyle ?? AppTextStyles.labelMedium.copyWith(
          color: hasError
              ? AppColors.error
              : _isFocused
              ? AppColors.primary
              : theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        children: [
          TextSpan(text: widget.label),
          if (widget.isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.error),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(ThemeData theme, bool hasError) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      style: widget.textStyle ?? AppTextStyles.bodyMedium,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword && !_isPasswordVisible,
      enabled: widget.isEnabled,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? AppTextStyles.bodyMedium.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        prefixIcon: widget.prefixIcon != null
            ? IconTheme(
          data: IconThemeData(
            color: hasError
                ? AppColors.error
                : _isFocused
                ? AppColors.primary
                : theme.colorScheme.onSurface.withOpacity(0.5),
            size: 20,
          ),
          child: widget.prefixIcon!,
        )
            : null,
        suffixIcon: _buildSuffixIcon(theme, hasError),
        filled: widget.filled,
        fillColor: widget.fillColor ??
            (widget.isEnabled
                ? theme.colorScheme.surface
                : theme.colorScheme.onSurface.withOpacity(0.05)),
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _buildBorder(theme.colorScheme.outline),
        enabledBorder: _buildBorder(widget.borderColor ?? theme.colorScheme.outline),
        focusedBorder: _buildBorder(
          widget.focusedBorderColor ?? AppColors.primary,
          width: 2,
        ),
        errorBorder: _buildBorder(widget.errorBorderColor ?? AppColors.error),
        focusedErrorBorder: _buildBorder(
          widget.errorBorderColor ?? AppColors.error,
          width: 2,
        ),
        disabledBorder: _buildBorder(theme.colorScheme.outline.withOpacity(0.3)),
        errorText: null, // We handle error text separately
        counterText: '', // Hide character counter
      ),
    );
  }

  Widget? _buildSuffixIcon(ThemeData theme, bool hasError) {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: hasError
              ? AppColors.error
              : _isFocused
              ? AppColors.primary
              : theme.colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
        onPressed: _togglePasswordVisibility,
        splashRadius: 20,
      );
    }

    if (widget.suffixIcon != null) {
      return IconTheme(
        data: IconThemeData(
          color: hasError
              ? AppColors.error
              : _isFocused
              ? AppColors.primary
              : theme.colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
        child: widget.suffixIcon!,
      );
    }

    return null;
  }

  Widget _buildHelperText(ThemeData theme, bool hasError) {
    final text = hasError ? widget.errorText : widget.helperText;
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: hasError
              ? AppColors.error
              : theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}