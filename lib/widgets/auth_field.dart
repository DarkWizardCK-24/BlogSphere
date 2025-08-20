import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthField extends StatefulWidget {
  final String hinttext;
  final TextEditingController controller;
  final bool isObscureText;
  final Icon prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? customValidator;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final String? label;

  const AuthField({
    super.key,
    required this.hinttext,
    required this.controller,
    required this.prefixIcon,
    this.isObscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.customValidator,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.label,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isFocused = false;
  bool _isHovered = false;
  bool _showPassword = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      _animationController.forward();
      HapticFeedback.lightImpact();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "${widget.hinttext} is required!";
    }
    
    // Email validation
    if (widget.keyboardType == TextInputType.emailAddress) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return "Please enter a valid email address";
      }
    }
    
    // Password validation
    if (widget.isObscureText && widget.hinttext.toLowerCase().contains('password')) {
      if (value.length < 6) {
        return "Password must be at least 6 characters";
      }
      if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
        return "Password must contain both letters and numbers";
      }
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (_isFocused || _isHovered) ...[
                    BoxShadow(
                      color: AppPallete.gradient5.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppPallete.gradient5.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 5,
                      offset: const Offset(0, 16),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: AppPallete.shadowLight,
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label (if provided)
                  if (widget.label != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 4),
                      child: Text(
                        widget.label!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _isFocused 
                              ? AppPallete.gradient5 
                              : AppPallete.greyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  
                  // Text Field Container
                  Container(
                    decoration: BoxDecoration(
                      color: AppPallete.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isFocused 
                            ? AppPallete.gradient5 
                            : AppPallete.borderColor.withOpacity(0.5),
                        width: _isFocused ? 2 : 1,
                      ),
                      gradient: _isFocused
                          ? LinearGradient(
                              colors: [
                                AppPallete.gradient5.withOpacity(0.05),
                                AppPallete.backgroundColor,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                    ),
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      onTap: widget.onTap,
                      readOnly: widget.readOnly,
                      obscureText: widget.isObscureText && !_showPassword,
                      keyboardType: widget.keyboardType,
                      inputFormatters: widget.inputFormatters,
                      maxLines: widget.isObscureText ? 1 : widget.maxLines,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppPallete.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: AppPallete.gradient5,
                      validator: widget.customValidator ?? _defaultValidator,
                      decoration: InputDecoration(
                        hintText: widget.hinttext,
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppPallete.greyColor.withOpacity(0.7),
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isFocused 
                                  ? AppPallete.gradient5.withOpacity(0.1)
                                  : AppPallete.borderColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.prefixIcon.icon,
                              color: _isFocused 
                                  ? AppPallete.gradient5 
                                  : AppPallete.greyColor,
                              size: 20,
                            ),
                          ),
                        ),
                        suffixIcon: widget.isObscureText
                            ? Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _isFocused 
                                        ? AppPallete.gradient5.withOpacity(0.1)
                                        : AppPallete.borderColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => _showPassword = !_showPassword);
                                      HapticFeedback.lightImpact();
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Icon(
                                      _showPassword 
                                          ? Icons.visibility_off_outlined 
                                          : Icons.visibility_outlined,
                                      color: _isFocused 
                                          ? AppPallete.gradient5 
                                          : AppPallete.greyColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        filled: false,
                      ),
                    ),
                  ),
                  
                  // Character count (for multiline fields)
                  if (widget.maxLines != null && widget.maxLines! > 1) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedOpacity(
                          opacity: _isFocused ? 1.0 : 0.6,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            '${widget.controller.text.length}/500',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.controller.text.length > 500
                                  ? AppPallete.errorColor
                                  : AppPallete.greyColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  // Helper text or validation message
                  if (_getHelperText() != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          children: [
                            Icon(
                              _getHelperIcon(),
                              size: 14,
                              color: _getHelperColor(),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _getHelperText()!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: _getHelperColor(),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  // Progress indicator for password strength
                  if (widget.isObscureText && 
                      widget.hinttext.toLowerCase().contains('password') && 
                      widget.controller.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildPasswordStrengthIndicator(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _getHelperText() {
    if (widget.keyboardType == TextInputType.emailAddress && _isFocused) {
      return "We'll never share your email with anyone else";
    }
    if (widget.isObscureText && _isFocused && widget.hinttext.toLowerCase().contains('password')) {
      return "Password must be at least 6 characters with letters and numbers";
    }
    if (widget.maxLines != null && widget.maxLines! > 1 && _isFocused) {
      return "Share your thoughts and ideas";
    }
    return null;
  }

  IconData _getHelperIcon() {
    if (widget.keyboardType == TextInputType.emailAddress) {
      return Icons.info_outline;
    }
    if (widget.isObscureText) {
      return Icons.security_outlined;
    }
    return Icons.lightbulb_outline;
  }

  Color _getHelperColor() {
    return AppPallete.gradient5.withOpacity(0.8);
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = widget.controller.text;
    final strength = _calculatePasswordStrength(password);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppPallete.borderColor.withOpacity(0.3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: strength / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _getStrengthColor(strength),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getStrengthText(strength),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStrengthColor(strength),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildPasswordCriteria(
              "6+ characters", 
              password.length >= 6,
            ),
            _buildPasswordCriteria(
              "Letters & numbers", 
              RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password),
            ),
            _buildPasswordCriteria(
              "Special character", 
              RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordCriteria(String text, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isMet ? AppPallete.gradient5 : AppPallete.borderColor.withOpacity(0.3),
          ),
          child: isMet
              ? Icon(
                  Icons.check,
                  size: 8,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isMet ? AppPallete.gradient5 : AppPallete.greyColor.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 6) strength++;
    if (RegExp(r'[a-zA-Z]').hasMatch(password)) strength++;
    if (RegExp(r'\d').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    return strength;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return "Weak";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Strong";
      default:
        return "Weak";
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppPallete.errorColor;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return AppPallete.gradient5;
      default:
        return AppPallete.errorColor;
    }
  }
}