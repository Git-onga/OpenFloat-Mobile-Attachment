import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../widgets/job_card.dart';
import '../theme_adapter.dart';

class JobRequestsPage extends StatelessWidget {
  const JobRequestsPage({super.key});

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
            'Job Requests',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage incoming job requests from customers',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
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
    );
  }
}
