import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../widgets/job_card.dart';
import '../theme_adapter.dart';

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeAdapter.theme;

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Jobs',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'View all your active, completed, and cancelled jobs',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Active'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Cancelled'),
                    ],
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Active Jobs
                        ListView.separated(
                          itemCount: 2,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return const JobCard(
                              customerName: 'John Kamau',
                              category: 'Electrical',
                              location: 'Westlands',
                              date: 'Tomorrow, 10:00 AM',
                              status: 'Accepted',
                              amount: 'KES 3,000',
                            );
                          },
                        ),
                        // Completed Jobs
                        ListView.separated(
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return const JobCard(
                              customerName: 'Sarah Wanjiku',
                              category: 'Cleaning',
                              location: 'Kilimani',
                              date: 'Yesterday, 3:00 PM',
                              status: 'Completed',
                              amount: 'KES 1,800',
                            );
                          },
                        ),
                        // Cancelled Jobs
                        ListView.separated(
                          itemCount: 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return const JobCard(
                              customerName: 'Peter Ochieng',
                              category: 'Plumbing',
                              location: 'Kasarani',
                              date: '2 days ago',
                              status: 'Cancelled',
                              amount: 'KES 0',
                            );
                          },
                        ),
                      ],
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
