import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart' show AppColors;
import 'package:swiftcel/core/constants/app_fonts.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

enum UserRole { sender, rider }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.sender;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isSubmitting) return;

    final formValid = _formKey.currentState!.validate();
    setState(() => _showTermsError = !_agreedToTerms);
    if (!formValid || !_agreedToTerms) return;

    final email = _emailController.text.trim();
    final success = await authProvider.signup(
      name: _nameController.text.trim(),
      email: email,
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole.name,
    );

    if (!mounted) return;

    if (success) {
      context.push('/verify-email', extra: email);
      return;
    }

    final message = authProvider.errorMessage ?? 'Unable to create account';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Account', style: AppFonts.displayMedium),
                          SizedBox(height: 6),
                          Text(
                            'Join the fastest logistics network today.',
                            style: AppFonts.labelMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Sender / Rider toggle
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.greyBg,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _RoleToggleButton(
                                    icon: Icons.person,
                                    label: 'Sender',
                                    isSelected:
                                        _selectedRole == UserRole.sender,
                                    onTap: () => setState(
                                      () => _selectedRole = UserRole.sender,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _RoleToggleButton(
                                    icon: Icons.pedal_bike,
                                    label: 'Rider',
                                    isSelected: _selectedRole == UserRole.rider,
                                    onTap: () => setState(
                                      () => _selectedRole = UserRole.rider,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          _FieldLabel('Full Name'),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Full name is required';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              hint: 'John Doe',
                              icon: Icons.badge_outlined,
                            ),
                          ),
                          SizedBox(height: 18),

                          _FieldLabel('Email Address'),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[\w.\-]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              hint: 'john@example.com',
                              icon: Icons.mail_outline,
                            ),
                          ),
                          SizedBox(height: 18),

                          _FieldLabel('Phone Number'),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              if (value.trim().length < 7) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              hint: '+1 (555) 000-0000',
                              icon: Icons.phone_iphone,
                            ),
                          ),
                          SizedBox(height: 18),

                          _FieldLabel('Password'),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  activeColor: AppColors.orangePrimary,
                                  onChanged: (v) => setState(() {
                                    _agreedToTerms = v ?? false;
                                    if (_agreedToTerms) _showTermsError = false;
                                  }),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: AppFonts.labelMedium.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                    children: [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: AppFonts.labelMedium.copyWith(
                                          color: AppColors.orangeSecondary,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // TODO: open Terms of Service
                                          },
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: AppFonts.labelMedium.copyWith(
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: AppFonts.labelMedium.copyWith(
                                          color: AppColors.orangeSecondary,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // TODO: open Privacy Policy
                                          },
                                      ),
                                      TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_showTermsError) ...[
                            SizedBox(height: 6),
                            Padding(
                              padding: EdgeInsets.only(left: 34),
                              child: Text(
                                'You must agree to continue',
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 22),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authProvider.isSubmitting
                                  ? null
                                  : _createAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orangePrimary,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: authProvider.isSubmitting
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Create Account',
                                          style: AppFonts.labelLarge.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: AppColors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                children: [
                                  TextSpan(text: 'Already have an account? '),
                                  TextSpan(
                                    text: 'Log In',
                                    style: AppFonts.labelMedium.copyWith(
                                      color: AppColors.orangePrimary,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.push('/login'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.greyBg,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.orangePrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
    );
  }
}

class _RoleToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleToggleButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.surface : AppColors.onSurface,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.surface : AppColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    );
  }
}
