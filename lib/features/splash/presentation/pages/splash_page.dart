import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/provider/presentation/pages/provider_shell.dart';
import '../../../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    context.read<AuthBloc>().add(AuthCheckRequested());

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final authState = context.read<AuthBloc>().state;
        if (authState.status == AuthStatus.authenticated &&
            authState.user != null) {
          if (authState.user!.isProvider) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ProviderShell()),
            );
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          }
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelection);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              color: AppColors.primary.withValues(alpha: 0.85),
            ),
          ),

          // --- Layer 3: Kazi | Connect text ---
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // "Kazi"
                  Text(
                    'Kazi',
                    style: GoogleFonts.baloo2(
                      fontSize: 60,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      letterSpacing: -1,
                    ),
                  ),

                  // const SizedBox(height: 6),

                  // Separator line
                  Container(width: 50, height: 2, color: AppColors.navy),

                  // const SizedBox(height: 6),

                  // "Connect"
                  Text(
                    AppStrings.appNameConnect,
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
