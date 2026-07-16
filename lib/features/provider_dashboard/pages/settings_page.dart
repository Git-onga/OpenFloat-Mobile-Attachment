import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';
import '../theme_adapter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            'Settings',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your app preferences and account settings',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _SettingsSection(
                  title: 'Account',
                  children: [
                    _SettingsTile(
                      icon: Icons.security,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.notifications,
                      title: 'Notification Preferences',
                      subtitle: 'Manage your notification settings',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsSection(
                  title: 'Appearance',
                  children: [
                    _SettingsTile(
                      icon: Icons.brightness_4,
                      title: 'Dark Mode',
                      subtitle: 'Toggle dark mode theme',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsSection(
                  title: 'Notifications',
                  children: [
                    _SettingsTile(
                      icon: Icons.assignment,
                      title: 'Job Requests',
                      subtitle: 'Get notified about new job requests',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.message,
                      title: 'Messages',
                      subtitle: 'Get notified about new messages',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.payment,
                      title: 'Payments',
                      subtitle: 'Get notified about payments',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsSection(
                  title: 'Support',
                  children: [
                    _SettingsTile(
                      icon: Icons.help,
                      title: 'Help Center',
                      subtitle: 'Get help with using the app',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.feedback,
                      title: 'Send Feedback',
                      subtitle: 'Share your feedback with us',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'App version 1.0.0',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: ThemeAdapter.theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
