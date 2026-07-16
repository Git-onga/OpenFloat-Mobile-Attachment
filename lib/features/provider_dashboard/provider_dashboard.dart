import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/job_requests_page.dart';
import 'pages/my_jobs_page.dart';
import 'pages/calendar_page.dart';
import 'pages/earnings_page.dart';
import 'pages/reviews_page.dart';
import 'pages/messages_page.dart';
import 'pages/notifications_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'widgets/sidebar.dart';
import 'widgets/top_nav_bar.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const JobRequestsPage(),
    const MyJobsPage(),
    const CalendarPage(),
    const EarningsPage(),
    const ReviewsPage(),
    const MessagesPage(),
    const NotificationsPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onMenuItemSelected,
          ),
          Expanded(
            child: Column(
              children: [
                const TopNavBar(),
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
