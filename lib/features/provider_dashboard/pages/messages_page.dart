import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../theme_adapter.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

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
            'Messages',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chat with your customers',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final names = [
                  'Jane Muthoni',
                  'John Kamau',
                  'Sarah Wanjiku',
                  'Peter Ochieng',
                ];
                final messages = [
                  'Can you come tomorrow at 10am?',
                  'Thanks for the great work!',
                  'How much will it cost?',
                  'I need help with my pipes',
                ];
                final times = ['10:30 AM', '9:15 AM', 'Yesterday', 'Yesterday'];
                final unread = [true, false, true, false];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      names[index][0],
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        names[index],
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (unread[index]) ...[
                        const SizedBox(width: 8),
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
                  subtitle: Text(
                    messages[index],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: unread[index]
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    times[index],
                    style: theme.textTheme.bodySmall,
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
