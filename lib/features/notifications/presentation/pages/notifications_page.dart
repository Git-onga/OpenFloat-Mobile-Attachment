import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          return _NotificationCard(notification: notif);
        },
      ),
    );
  }
}

class _Notification {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  const _Notification({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    this.isUnread = false,
  });
}

final List<_Notification> _notifications = [
  _Notification(
    icon: Icons.build_circle,
    iconColor: AppColors.primaryDark,
    title: 'Job Started',
    body: 'Muriuki James has started working on your plumbing repair job.',
    time: '2 min ago',
    isUnread: true,
  ),
  _Notification(
    icon: Icons.chat_bubble,
    iconColor: AppColors.navy,
    title: 'New Message',
    body: 'Wanjiku Njeri sent you a message about the ceiling painting job.',
    time: '15 min ago',
    isUnread: true,
  ),
  _Notification(
    icon: Icons.payment,
    iconColor: AppColors.success,
    title: 'Payment Confirmed',
    body: 'Your payment of KES 500/= for booking #JOB-2024-056 has been confirmed.',
    time: '1 hour ago',
  ),
  _Notification(
    icon: Icons.schedule,
    iconColor: AppColors.navyLight,
    title: 'Booking Confirmed',
    body: 'Otieno Kip has confirmed your booking for Electrical Wiring. Scheduled for July 12, 2024.',
    time: '3 hours ago',
  ),
  _Notification(
    icon: Icons.star,
    iconColor: AppColors.primary,
    title: 'Review Received',
    body: 'You received a 5-star review from your last service. Keep up the great work!',
    time: 'Yesterday',
  ),
  _Notification(
    icon: Icons.info_outline,
    iconColor: AppColors.navyLight,
    title: 'Job Update',
    body: 'The landscaping job with Kamau Mwangi has been rescheduled to July 14, 2024.',
    time: 'Yesterday',
  ),
  _Notification(
    icon: Icons.check_circle,
    iconColor: AppColors.success,
    title: 'Job Completed',
    body: 'Your electrical repair job #JOB-2024-001 has been marked as completed.',
    time: '2 days ago',
  ),
  _Notification(
    icon: Icons.local_offer,
    iconColor: AppColors.error,
    title: 'Special Offer',
    body: 'Get 15% off on your next plumbing service booking. Offer valid until July 20.',
    time: '3 days ago',
  ),
];

class _NotificationCard extends StatelessWidget {
  final _Notification notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isUnread
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              notification.icon,
              color: notification.iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (notification.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  notification.time,
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navyLight,
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
