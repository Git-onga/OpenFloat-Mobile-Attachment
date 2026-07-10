import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_link/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:home_link/features/auth/presentation/bloc/auth_event.dart';
import 'package:home_link/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/constants/app_colors.dart';
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
            SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // --- White background ---
            Positioned.fill(child: Container(color: AppColors.background)),

            // --- Decorative navy circles with reduced opacity ---
            Positioned(
              top: -60,
              right: -40,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: AppColors.navy.withValues(alpha: 0.06),
              ),
            ),
            Positioned(
              top: size.height * 0.3,
              left: -80,
              child: CircleAvatar(
                radius: 140,
                backgroundColor: AppColors.navy.withValues(alpha: 0.04),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -60,
              child: CircleAvatar(
                radius: 160,
                backgroundColor: AppColors.navy.withValues(alpha: 0.05),
              ),
            ),

            // --- Yellow container (bottom 3/4 of screen) ---
            Positioned(
              top: size.height * 0.25,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x26FFB84D), // mustard yellow ~15% opacity
                  border: Border(
                    top: BorderSide(color: AppColors.navy, width: 2),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(48),
                  ),
                ),
              ),
            ),

            // --- Content ---
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // "Log in" heading
                    Text(
                      AppStrings.login,
                      style: GoogleFonts.baloo2(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Form fields
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: AppStrings.email,
                              filled: true,
                              fillColor: AppColors.inputFill,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.navy,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                            validator: Validators.email,
                          ),

                          const SizedBox(height: 20),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSubmit(),
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: AppStrings.password,
                              filled: true,
                              fillColor: AppColors.inputFill,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.navy,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(
                                      () => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            validator: Validators.password,
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

                          const SizedBox(height: 24),

                          // Login button - navy bg
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              // replace the logic with Authentication process when you set up the backend
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: AppColors.textOnPrimary,
                                disabledBackgroundColor:
                                    AppColors.navy.withValues(alpha: 0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.textOnPrimary,
                                      ),
                                    )
                                  : Text(
                                      AppStrings.loginButton,
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Don't have account? Register
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.dontHaveAccount,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(
                                          AppRoutes.register);
                                },
                                child: Text(
                                  AppStrings.registerHere,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
