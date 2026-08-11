import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/settings/presentation/cubit/theme_cubit.dart';
import '../../../../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  // Mock user data
  final _nameCtrl = TextEditingController(text: 'Alex Mwangi');
  final _emailCtrl = TextEditingController(text: 'alex.mwangi@gmail.com');
  final _phoneCtrl = TextEditingController(text: '+254 712 345 678');
  final _bioCtrl = TextEditingController(
    text: 'Homeowner in Nairobi. I believe in quality workmanship and supporting local artisans.',
  );
  final _locationCtrl = TextEditingController(text: 'Westlands, Nairobi');

  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out',
          style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        content: Text('Are you sure you want to log out?',
          style: GoogleFonts.nunito(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.roleSelection,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Log Out',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final languages = ['English', 'Swahili', 'French', 'Kikuyu', 'Luo'];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Language',
                style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              const SizedBox(height: 16),
              ...languages.map((lang) => GestureDetector(
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(ctx);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: _selectedLanguage == lang
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(lang,
                        style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w600,
                          color: _selectedLanguage == lang ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                      ),
                      if (_selectedLanguage == lang)
                        const Icon(Icons.check_circle, color: AppColors.primaryDark, size: 22),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ─── Header ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile',
                style: GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              GestureDetector(
                onTap: () {
                  if (_isEditing) {
                    _saveProfile();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isEditing ? AppColors.success : AppColors.navy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isEditing ? Icons.check : Icons.edit_outlined,
                        size: 16,
                        color: _isEditing ? Colors.white : AppColors.navy,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isEditing ? 'Save' : 'Edit',
                        style: GoogleFonts.nunito(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: _isEditing ? Colors.white : AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ─── Profile Avatar ──────────────────
          Center(
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.2),
                    border: Border.all(color: AppColors.navy.withValues(alpha: 0.15), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      _nameCtrl.text.isNotEmpty ? _nameCtrl.text.split(' ').last[0].toUpperCase() : 'A',
                      style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                    ),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── Personal Info ───────────────────
          _sectionHeader('Personal Information'),
          const SizedBox(height: 10),
          _buildField('Full Name', _nameCtrl, Icons.person_outline),
          const SizedBox(height: 10),
          _buildField('Email', _emailCtrl, Icons.email_outlined, TextInputType.emailAddress),
          const SizedBox(height: 10),
          _buildField('Phone', _phoneCtrl, Icons.phone_outlined, TextInputType.phone),
          const SizedBox(height: 10),
          _buildField('Location', _locationCtrl, Icons.location_on_outlined),
          const SizedBox(height: 10),
          _buildField('Bio', _bioCtrl, Icons.info_outline, TextInputType.multiline, 3),

          const SizedBox(height: 24),

          // ─── Account Stats ──────────────────
          _sectionHeader('Account'),
          const SizedBox(height: 10),
          _buildStatTile(
            Icons.work_history_outlined,
            'Jobs Booked',
            '12',
            AppColors.navy,
          ),
          _buildStatTile(
            Icons.star_outline,
            'Reviews Given',
            '8',
            AppColors.primary,
          ),
          _buildStatTile(
            Icons.payments_outlined,
            'Total Spent',
            'KES 4,500',
            AppColors.success,
          ),

          const SizedBox(height: 24),

          // ─── Settings ────────────────────────
          _sectionHeader('Settings'),
          const SizedBox(height: 10),

          // Language
          _buildSettingTile(
            Icons.language,
            'Language',
            _selectedLanguage,
            onTap: _showLanguagePicker,
          ),

          // Notifications
          _buildSwitchTile(
            Icons.notifications_outlined,
            'Push Notifications',
            _notificationsEnabled,
            (v) => setState(() => _notificationsEnabled = v),
          ),

          // Dark mode
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _buildSwitchTile(
                Icons.dark_mode_outlined,
                'Dark Mode',
                themeMode == ThemeMode.dark,
                (v) => context.read<ThemeCubit>().toggle(),
              );
            },
          ),

          const SizedBox(height: 24),

          // ─── Support & About ────────────────
          _sectionHeader('Support & About'),
          const SizedBox(height: 10),

          _buildSettingTile(
            Icons.help_outline,
            'Help Center',
            null,
            onTap: () {},
          ),

          _buildSettingTile(
            Icons.report_problem_outlined,
            'Report an Issue',
            null,
            onTap: () => _showReportDialog(),
          ),

          _buildSettingTile(
            Icons.shield_outlined,
            'Privacy Policy',
            null,
            onTap: () {},
          ),

          _buildSettingTile(
            Icons.description_outlined,
            'Terms of Service',
            null,
            onTap: () {},
          ),

          _buildSettingTile(
            Icons.info_outline,
            'About KaziConnect',
            'v1.0.0',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // ─── Logout ─────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout, size: 20),
              label: Text('Log Out',
                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title,
      style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon,
      [TextInputType? keyboardType, int maxLines = 1]) {
    if (!_isEditing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.navy.withValues(alpha: 0.5)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(ctrl.text,
                    style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.nunito(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
        prefixIcon: Icon(icon, size: 20, color: AppColors.navy),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor!,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildStatTile(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Text(label,
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
          ),
          const Spacer(),
          Text(value,
            style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String? subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.navy.withValues(alpha: 0.7)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            if (subtitle != null) ...[
              Text(subtitle,
                style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.navy.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    final issueCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Report an Issue',
          style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Describe the issue you\'re experiencing:',
              style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: issueCtrl,
              maxLines: 4,
              style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Tell us what went wrong...',
                hintStyle: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor!,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Issue reported. We\'ll get back to you soon!'),
                  backgroundColor: AppColors.navy,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Submit',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
