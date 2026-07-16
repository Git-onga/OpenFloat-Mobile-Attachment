import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../theme_adapter.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
                    'Notifications',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay updated with your latest activity',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Mark all as read'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: 6,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notifications = [
                  {
                    'icon': Icons.assignment,
                    'color': AppColors.primary,
                    'title': 'New job request',
                    'description': 'Jane Muthoni requested plumbing service',
                    'time': '2 minutes ago',
                    'read': false,
                  },
                  {
                    'icon': Icons.payment,
                    'color': AppColors.success,
                    'title': 'Payment received',
                    'description': 'KES 2,500 received from John Kamau',
                    'time': '1 hour ago',
                    'read': false,
                  },
                  {
                    'icon': Icons.star,
                    'color': AppColors.warning,
                    'title': 'New review',
                    'description': 'Sarah Wanjiku left a 5-star review',
                    'time': '3 hours ago',
                    'read': true,
                  },
                  {
                    'icon': Icons.message,
                    'color': AppColors.info,
                    'title': 'New message',
                    'description': 'Peter Ochieng sent you a message',
                    'time': '5 hours ago',
                    'read': true,
                  },
                  {
                    'icon': Icons.cancel,
                    'color': AppColors.error,
                    'title': 'Job cancelled',
                    'description': 'Job #1234 was cancelled by customer',
                    'time': '1 day ago',
                    'read': true,
                  },
                  {
                    'icon': Icons.calendar_today,
                    'color': AppColors.navy,
                    'title': 'Upcoming job',
                    'description':
                        'Plumbing job scheduled for tomorrow at 10am',
                    'time': '2 days ago',
                    'read': true,
                  },
                ];

                final notif = notifications[index];
                final isRead = notif['read'] as bool;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (notif['color'] as Color).withOpacity(0.1),
                    child: Icon(
                      notif['icon'] as IconData,
                      color: notif['color'] as Color,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    notif['title'] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    notif['description'] as String,
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        notif['time'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                      if (!isRead) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
