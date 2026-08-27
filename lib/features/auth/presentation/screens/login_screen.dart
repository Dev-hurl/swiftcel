import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/features/auth/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _keepSignedIn = true;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isSubmitting) return;

    final success = await authProvider.login(
      email: _identifierController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      final message = authProvider.errorMessage ?? 'Unable to log in';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg image.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.33,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icons/white transparent logo only.png',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Welcome Back!',
                        style: textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        'Sign in to pickup from where you left off',
                        style: textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _identifierController,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        prefixIcon: const Icon(Icons.mail_outline, size: 20),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
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
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _keepSignedIn,
                          activeColor: colorScheme.secondary,
                          onChanged: (v) =>
                              setState(() => _keepSignedIn = v ?? true),
                        ),
                        Text(
                          'Keep me signed in',
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go('/forgot-password'),
                          child: Text(
                            'Forgot Password?',
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.orangeSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: authProvider.isSubmitting ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                                  color: colorScheme.surfaceBright,
                                ),
                              )
                            : Text(
                                'Log In',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.surfaceBright,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Or Continue With',
                            style: textTheme.labelSmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SocialButton(
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _SocialButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: textTheme.labelSmall?.copyWith(),
                          children: [
                            const TextSpan(text: "Don't have any account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.secondary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.push('/signup'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: guest tracking flow
                        },
                        child: Text(
                          'Quick Track as Guest →',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: textTheme.labelMedium),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerLowest,
          foregroundColor: colorScheme.onSurfaceVariant,
          padding: EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: colorScheme.surfaceContainerLow),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
