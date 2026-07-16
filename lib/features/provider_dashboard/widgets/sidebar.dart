import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../theme_adapter.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.dashboard, 'label': 'Dashboard'},
    {'icon': Icons.assignment, 'label': 'Job Requests'},
    {'icon': Icons.work, 'label': 'My Jobs'},
    {'icon': Icons.calendar_today, 'label': 'Calendar'},
    {'icon': Icons.attach_money, 'label': 'Earnings'},
    {'icon': Icons.star, 'label': 'Reviews'},
    {'icon': Icons.message, 'label': 'Messages'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.person, 'label': 'Profile'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ThemeAdapter.theme;

    return Container(
      width: 250,
      color: AppColors.navy,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.build_circle,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'KaziLink',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Provider Dashboard',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = selectedIndex == index;

                return ListTile(
                  leading: Icon(
                    item['icon'],
                    color: isSelected ? AppColors.primary : Colors.white70,
                    size: 22,
                  ),
                  title: Text(
                    item['label'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? AppColors.primary : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () => onItemSelected(index),
                  tileColor: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: Text(
              'Logout',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
