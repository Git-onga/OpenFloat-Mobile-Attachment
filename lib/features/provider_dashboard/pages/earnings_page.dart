import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../theme_adapter.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

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
            'Earnings',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your earnings and payment history',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _EarningSummaryCard(
                  title: 'Today',
                  amount: 'KES 4,500',
                  icon: Icons.today,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _EarningSummaryCard(
                  title: 'This Week',
                  amount: 'KES 18,200',
                  icon: Icons.weekend,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _EarningSummaryCard(
                  title: 'This Month',
                  amount: 'KES 125,400',
                  icon: Icons.calendar_month,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Withdrawals',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 4,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.success.withOpacity(
                                0.1,
                              ),
                              child: Icon(
                                Icons.arrow_upward,
                                color: AppColors.success,
                              ),
                            ),
                            title: Text(
                              'KES ${(index + 1) * 5000}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Withdrawn to M-Pesa - ${DateTime.now().subtract(Duration(days: (index + 1) * 2)).toString().substring(0, 10)}',
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: Chip(
                              label: Text(
                                'Completed',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                              backgroundColor: AppColors.success.withOpacity(
                                0.1,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _EarningSummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: ThemeAdapter.theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Icon(icon, size: 20, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: ThemeAdapter.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
