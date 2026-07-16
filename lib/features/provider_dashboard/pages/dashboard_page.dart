import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/job_card.dart';
import '../theme_adapter.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeAdapter.theme;

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, John 👋',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Here's what's happening with your jobs today",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined, size: 30),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              StatCard(
                title: 'Total Jobs',
                value: '120',
                icon: Icons.work,
                color: AppColors.primary,
              ),
              StatCard(
                title: 'Pending',
                value: '8',
                icon: Icons.pending_actions,
                color: AppColors.warning,
              ),
              StatCard(
                title: 'Completed',
                value: '112',
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
              StatCard(
                title: 'Earnings',
                value: 'KES 125,400',
                icon: Icons.attach_money,
                color: AppColors.navy,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Job Requests',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return const JobCard(
                        customerName: 'Jane Muthoni',
                        category: 'Plumbing',
                        location: 'Nairobi CBD',
                        date: 'Today, 2:30 PM',
                        status: 'Pending',
                        amount: 'KES 2,500',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
