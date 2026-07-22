import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../features/provider/presentation/pages/provider_shell.dart';
import '../../../../routes/app_routes.dart';

import '../../../provider/presentation/pages/calendar_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // --- Layer 1: Vector silhouettes (visible through overlay) ---
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.3),
                // City skyline at center
                SizedBox(
                  height: 350, // optional
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/city_skyline.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),

                // Electrician at bottom
                SizedBox(
                  height: 150, // optional
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/electrician.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // --- Layer 2: Semi-transparent mustard yellow overlay ---
          Positioned.fill(
            child: Container(
              color: AppColors.primary.withValues(alpha: 0.9),
            ),
          ),

          // --- Layer 3: Content ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),

                  // "Sign Up as" - top right
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select your what describes you best',
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),

                  // --- Role buttons ---
                  // "Client" button - white bg, navy outline
                  SizedBox(
                    width: 200,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.register);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.navy,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppStrings.client,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Separator line
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.navy, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.navy, thickness: 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // "Service Provider" button - navy bg, white outline
                  SizedBox(
                    width: 200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const ProviderShell()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: AppColors.textOnPrimary,
                        side: const BorderSide(
                          color: AppColors.textOnPrimary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppStrings.serviceProvider,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
