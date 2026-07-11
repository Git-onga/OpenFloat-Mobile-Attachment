import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/provider/presentation/pages/booking_requests_page.dart';
import '../../../../features/provider/presentation/pages/job_manager_page.dart';
import '../../../../features/provider/presentation/pages/provider_home_page.dart';
import '../../../../features/provider/presentation/pages/provider_profile_page.dart';

class ProviderShell extends StatefulWidget {
  const ProviderShell({super.key});

  @override
  State<ProviderShell> createState() => _ProviderShellState();
}

class _ProviderShellState extends State<ProviderShell> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? Theme.of(context).colorScheme.surface : AppColors.navy;
    final navInactive = isDark ? AppColors.textSecondary : AppColors.textOnPrimary;
    final activeColor = AppColors.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: IndexedStack(
          index: _currentTab,
          children: const [
            ProviderHomePage(),
            BookingRequestsPage(),
            JobManagerPage(),
            ProviderProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0, activeColor, navInactive),
                _navItem(Icons.calendar_today, Icons.calendar_month_rounded, 'Bookings', 1, activeColor, navInactive),
                _navItem(Icons.work_outline, Icons.work_rounded, 'Jobs', 2, activeColor, navInactive),
                _navItem(Icons.person_outline, Icons.person_rounded, 'Profile', 3, activeColor, navInactive),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label,
      int index, Color activeColor, Color inactiveColor) {
    final isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, size: 22,
                color: isActive ? activeColor : inactiveColor),
            const SizedBox(height: 3),
            Text(label,
              style: GoogleFonts.nunito(fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor),
            ),
          ],
        ),
      ),
    );
  }
}
