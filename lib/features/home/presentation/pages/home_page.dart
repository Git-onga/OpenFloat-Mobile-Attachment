import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../../../chat/presentation/pages/chat_list_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/job_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    // Fetch home data on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(HomeDataRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // === Top Header ===
            _buildHeader(),

            // === Location Section ===
            _buildLocationSection(),

            // === Content Area ===
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),

      // === Bottom Navigation ===
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Header ──────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App name
          Text(
            'KaziConnect',
            style: GoogleFonts.baloo2(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),

          // Action icons
          Row(
            children: [
              // Notifications
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.notifications);
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.navy,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Chats
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChatListPage(),
                    ),
                  );
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.navy,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Location Section ────────────────────────────────
  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Current Location" label
          Text(
            'Current Location',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 2),

          // Pin icon + location name
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.navy,
              ),
              const SizedBox(width: 4),
              Text(
                'WestLands, Nairobi',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Main Content ────────────────────────────────────
  Widget _buildContent() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case HomeStatus.initial:
          case HomeStatus.loading:
            return const Center(
              child: CircularProgressIndicator(color: AppColors.navy),
            );

          case HomeStatus.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(HomeDataRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );

          case HomeStatus.loaded:
            final ongoingJobs = state.items
                .where((item) => item.category == 'ongoing')
                .toList();

            final bookings = state.items
                .where((item) => item.category == 'booking')
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ongoingJobs.isNotEmpty) ...[
                    _buildSectionHeader('Ongoing Jobs'),
                    ...ongoingJobs.map((job) => JobCard(item: job)),
                  ],
                  if (bookings.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSectionHeader('Bookings'),
                    ...bookings.map((job) => JobCard(item: job)),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            );
        }
      },
    );
  }

  // ─── Section Header ──────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
    );
  }

  // ─── Bottom Navigation ───────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy,
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
              _navItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0),
              _navItem(
                  Icons.build_outlined, Icons.build_rounded, 'Service', 1),
              _navItem(Icons.bookmark_outline, Icons.bookmark_rounded,
                  'Booking', 2),
              _navItem(
                  Icons.person_outline, Icons.person_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      IconData icon, IconData activeIcon, String label, int index) {
    final isActive = _currentTab == index;

    return GestureDetector(
      onTap: () {
        setState(() => _currentTab = index);
        // TODO: Navigate or switch tab content
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textOnPrimary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


