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
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterSubmitted(
              name: _nameController.text.trim(),
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
              content: Text(state.errorMessage ?? 'Registration failed'),
            ),
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
              top: -40,
              left: -50,
              child: CircleAvatar(
                radius: 130,
                backgroundColor: AppColors.navy.withOpacity(0.06),
              ),
            ),
            Positioned(
              top: size.height * 0.35,
              right: -70,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: AppColors.navy.withOpacity(0.04),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -40,
              child: CircleAvatar(
                radius: 150,
                backgroundColor: AppColors.navy.withOpacity(0.05),
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

                    // "Sign up" heading
                    Text(
                      AppStrings.signUp,
                      style: GoogleFonts.baloo2(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Form fields
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Full Name field
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _inputDecoration(
                              AppStrings.fullName,
                            ),
                            validator: (v) => Validators.required(v, 'Name'),
                          ),

                          const SizedBox(height: 16),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _inputDecoration(
                              AppStrings.email,
                            ),
                            validator: Validators.email,
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _inputDecoration(
                              AppStrings.password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            validator: Validators.password,
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password field
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSubmit(),
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _inputDecoration(
                              AppStrings.confirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      _obscureConfirm = !_obscureConfirm);
                                },
                              ),
                            ),
                            validator: (value) => Validators.confirmPassword(
                              value,
                              _passwordController.text,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Sign Up button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: AppColors.textOnPrimary,
                                disabledBackgroundColor:
                                    AppColors.navy.withOpacity(0.6),
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
                                      AppStrings.createAccount,
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Already have account? Login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.alreadyHaveAccount,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(
                                          AppRoutes.login);
                                },
                                child: Text(
                                  AppStrings.loginHere,
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

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
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
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
