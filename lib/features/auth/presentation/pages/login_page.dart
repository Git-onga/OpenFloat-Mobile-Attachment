import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_link/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:home_link/features/auth/presentation/bloc/auth_event.dart';
import 'package:home_link/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading =
        context.watch<AuthBloc>().state.status == AuthStatus.loading;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.status == AuthStatus.error) {
          context.scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Login failed'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // ── White background ──
            Positioned.fill(
              child: Container(color: Theme.of(context).colorScheme.surface),
            ),

            // ── Decorative circles ──
            _buildDecorativeCircles(size),

            // ── Mustard yellow container (bottom 70%) ──
            Positioned(
              top: size.height * 0.20,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(56),
                  ),
                ),
              ),
            ),

            // ── Subtle divider line between white & yellow ──
            // Positioned(
            //   top: size.height * 0.195,
            //   left: 0,
            //   right: size.width * 0.01,
            //   child: Container(
            //     height: 4,
            //     color: AppColors.navy.withValues(alpha: 0.9),
            //   ),
            // ),

            // ── Content ──
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingLg + 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Back button ──
                    _buildBackButton(),

                    const SizedBox(height: 120),

                    // ── Welcome heading ──
                    Text(
                      'Welcome back',
                      style: GoogleFonts.baloo2(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Log in to your account to continue',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Form ──
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          _buildInputField(
                            controller: _emailController,
                            hint: AppStrings.email,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          _buildInputField(
                            controller: _passwordController,
                            hint: AppStrings.password,
                            icon: Icons.lock_outlined,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSubmit(),
                            validator: Validators.password,
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Forgot password flow
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 36),
                              ),
                              child: Text(
                                AppStrings.forgotPassword,
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Login button ──
                          _buildPrimaryButton(
                            label: AppStrings.loginButton,
                            isLoading: isLoading,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.home);
                            },
                          ),

                          const SizedBox(height: 28),

                          // ── Or divider ──
                          _buildOrDivider(),

                          const SizedBox(height: 28),

                          // ── Social buttons ──
                          _buildSocialButtons(),

                          const SizedBox(height: 36),

                          // ── Register link ──
                          _buildBottomLink(
                            text: AppStrings.dontHaveAccount,
                            linkText: AppStrings.registerHere,
                            onTap: () => Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.register),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  //  Building methods
  // ────────────────────────────────────────────

  Widget _buildDecorativeCircles(Size size) {
    return Stack(
      children: [
        // Top-right large circle
        Positioned(
          top: -80,
          right: -60,
          child: CircleAvatar(
            radius: 140,
            backgroundColor: AppColors.textPrimary.withValues(alpha: 0.9),
          ),
        ),
        // Mid-left medium circle
        Positioned(
          top: size.height * 0.42,
          left: -70,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: AppColors.textPrimary.withValues(alpha: 0.9),
          ),
        ),
        // Bottom-right small circle
        Positioned(
          bottom: -50,
          right: -30,
          child: CircleAvatar(
            radius: 90,
            backgroundColor: AppColors.textPrimary.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.navy,
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 30),

        Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                'K',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kazi',
                style: GoogleFonts.baloo2(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  height: 1,
                ),
              ),
              Text(
                'Connect',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                  letterSpacing: 2,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      )
      ]
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
          fontSize: 15,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 10),
          child: Icon(icon, color: AppColors.navy.withValues(alpha: 0.5), size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.navy.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.textOnPrimary,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(child: _buildSocialButton(Icons.g_mobiledata_rounded, 'Google')),
        const SizedBox(width: 14),
        Expanded(child: _buildSocialButton(Icons.apple, 'Apple')),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Social sign-in
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(
            color: AppColors.navy.withValues(alpha: 0.15),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: icon == Icons.g_mobiledata_rounded ? 28 : 22,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomLink({
    required String text,
    required String linkText,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}
