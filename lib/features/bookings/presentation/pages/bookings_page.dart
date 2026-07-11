import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/home/domain/entities/home_item.dart';
import '../../../../features/job_details/presentation/pages/job_details_page.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() => _activeTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<HomeItem> _filteredBookings() {
    switch (_activeTab) {
      case 0:
        return _bookings.where((b) =>
            b.jobStatus == 'Confirmed' || b.jobStatus == 'Scheduled').toList();
      case 1:
        return _bookings.where((b) =>
            b.jobStatus == 'In Progress' || b.jobStatus == 'En Route').toList();
      case 2:
        return _bookings.where((b) =>
            b.jobStatus == 'Completed' || b.jobStatus == 'Cancelled').toList();
      default:
        return _bookings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ──────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Bookings',
                style: GoogleFonts.baloo2(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_bookings.length} total',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Track and manage your service bookings',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ─── Tab Bar ─────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.textOnPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: GoogleFonts.nunito(
                  fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: GoogleFonts.nunito(
                  fontSize: 13, fontWeight: FontWeight.w600),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ─── Booking List ────────────────────
        Expanded(
          child: bookings.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) =>
                      _BookingCard(booking: bookings[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final messages = [
      ['No upcoming bookings', 'Book a service to get started!', Icons.event_note],
      ['No active bookings', 'Your in-progress jobs will appear here', Icons.play_circle_outline],
      ['No booking history', 'Completed jobs will show up here', Icons.history],
    ];
    final msg = messages[_activeTab];

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.navy.withValues(alpha: 0.06),
            ),
            child: Icon(
              msg[2] as IconData,
              size: 36,
              color: AppColors.navy.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            msg[0] as String,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            msg[1] as String,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final HomeItem booking;

  const _BookingCard({required this.booking});

  Color _statusColor(String? status) {
    switch (status) {
      case 'Confirmed':
      case 'Scheduled':
        return AppColors.success;
      case 'In Progress':
      case 'En Route':
        return AppColors.primary;
      case 'Completed':
        return AppColors.navy;
      case 'Cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status) {
      case 'Confirmed':
        return Icons.check_circle_outline;
      case 'Scheduled':
        return Icons.schedule;
      case 'In Progress':
        return Icons.play_circle_filled;
      case 'En Route':
        return Icons.directions_car;
      case 'Completed':
        return Icons.verified;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(booking.jobStatus);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => JobDetailsPage(job: booking),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.navy.withValues(alpha: 0.2)
                : AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            // ─── Top status bar ────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(_statusIcon(booking.jobStatus),
                      size: 16, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    booking.jobStatus ?? 'Unknown',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Job ${booking.jobId ?? booking.id}',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Main content ──────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Worker avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        (booking.workerName ?? 'W')[0].toUpperCase(),
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Booking details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.title,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          booking.workerName ?? 'Worker',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                booking.jobDetails ?? booking.description,
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Price & arrow
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        booking.hourlyRate ?? 'KES 0/=',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/hr',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (booking.jobStatus == 'In Progress') ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 11,
                                color: AppColors.primary),
                            const SizedBox(width: 3),
                            Text(
                              booking.elapsedTime ?? '00:00',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ─── Bottom actions ────────────
            if (booking.jobStatus == 'Confirmed' ||
                booking.jobStatus == 'Scheduled')
              Container(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(
                              color: AppColors.error.withValues(alpha: 0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Cancel',
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => JobDetailsPage(job: booking),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('View Details',
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),

            if (booking.jobStatus == 'Completed')
              Container(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.star_outline, size: 16),
                        label: Text('Review',
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Book Again',
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Mock Booking Data ────────────────────────

final List<HomeItem> _bookings = [
  // Upcoming (Confirmed / Scheduled)
  HomeItem(
    id: 'BK-001',
    title: 'Full House Rewiring',
    description: 'Complete rewiring of 4-bedroom house in Karen',
    createdAt: DateTime.now(),
    jobId: 'BK-001',
    jobStatus: 'Confirmed',
    elapsedTime: '00:00:00',
    workerName: 'Otieno Kip',
    workerProfession: 'Electrician',
    workerRating: 4.8,
    jobDetails: 'Westlands, Nairobi • Jul 15, 2024 • 8:00 AM',
    hourlyRate: 'KES 150/=',
    category: 'booking',
  ),
  HomeItem(
    id: 'BK-002',
    title: 'Bathroom Renovation',
    description: 'Full bathroom remodel with tiling and fixtures',
    createdAt: DateTime.now(),
    jobId: 'BK-002',
    jobStatus: 'Scheduled',
    elapsedTime: '00:00:00',
    workerName: 'Muriuki James',
    workerProfession: 'Plumber',
    workerRating: 4.7,
    jobDetails: 'Kilimani, Nairobi • Jul 18, 2024 • 10:00 AM',
    hourlyRate: 'KES 100/=',
    category: 'booking',
  ),
  HomeItem(
    id: 'BK-003',
    title: 'Garden Landscaping',
    description: 'Front yard makeover with flowers and stone path',
    createdAt: DateTime.now(),
    jobId: 'BK-003',
    jobStatus: 'Confirmed',
    elapsedTime: '00:00:00',
    workerName: 'Kamau Mwangi',
    workerProfession: 'Landscaper',
    workerRating: 4.7,
    jobDetails: 'Karen, Nairobi • Jul 22, 2024 • 7:00 AM',
    hourlyRate: 'KES 120/=',
    category: 'booking',
  ),

  // Active (In Progress)
  HomeItem(
    id: 'BK-004',
    title: 'Kitchen Plumbing Fix',
    description: 'Burst pipe under kitchen sink repair',
    createdAt: DateTime.now(),
    jobId: 'BK-004',
    jobStatus: 'In Progress',
    elapsedTime: '02:45:18',
    workerName: 'Muriuki James',
    workerProfession: 'Plumber',
    workerRating: 4.7,
    jobDetails: 'Westlands, Nairobi • Started Jul 10',
    hourlyRate: 'KES 100/=',
    category: 'booking',
  ),
  HomeItem(
    id: 'BK-005',
    title: 'Living Room Painting',
    description: 'Interior wall painting and ceiling touch-up',
    createdAt: DateTime.now(),
    jobId: 'BK-005',
    jobStatus: 'In Progress',
    elapsedTime: '05:12:33',
    workerName: 'Wanjiku Njeri',
    workerProfession: 'Painter',
    workerRating: 4.6,
    jobDetails: 'Lavington, Nairobi • Started Jul 09',
    hourlyRate: 'KES 80/=',
    category: 'booking',
  ),

  // History (Completed / Cancelled)
  HomeItem(
    id: 'BK-006',
    title: 'Ceiling Fan Installation',
    description: 'Install 3 ceiling fans in living areas',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    jobId: 'BK-006',
    jobStatus: 'Completed',
    elapsedTime: '01:30:00',
    workerName: 'Wanjala Ben',
    workerProfession: 'Electrician',
    workerRating: 4.6,
    jobDetails: 'Parklands, Nairobi • Completed Jul 05',
    hourlyRate: 'KES 120/=',
    category: 'booking',
  ),
  HomeItem(
    id: 'BK-007',
    title: 'Deep House Cleaning',
    description: 'Full house deep clean including carpets',
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
    jobId: 'BK-007',
    jobStatus: 'Completed',
    elapsedTime: '04:00:00',
    workerName: 'Akinyi Chebet',
    workerProfession: 'Home Cleaner',
    workerRating: 4.9,
    jobDetails: 'Lavington, Nairobi • Completed Jul 02',
    hourlyRate: 'KES 60/=',
    category: 'booking',
  ),
  HomeItem(
    id: 'BK-008',
    title: 'Custom Bookshelf Build',
    description: 'Floor-to-ceiling bookshelf for home library',
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
    jobId: 'BK-008',
    jobStatus: 'Completed',
    elapsedTime: '08:00:00',
    workerName: 'Njuguna Peter',
    workerProfession: 'Carpenter',
    workerRating: 4.8,
    jobDetails: 'Karen, Nairobi • Completed Jun 26',
    hourlyRate: 'KES 130/=',
    category: 'booking',
  ),
  HomeItem(
    id: 'BK-009',
    title: 'AC Maintenance',
    description: 'Annual service for 3 split AC units',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    jobId: 'BK-009',
    jobStatus: 'Cancelled',
    elapsedTime: '00:00:00',
    workerName: 'Kiprotich Allan',
    workerProfession: 'HVAC Technician',
    workerRating: 4.8,
    jobDetails: 'Westlands, Nairobi • Cancelled',
    hourlyRate: 'KES 200/=',
    category: 'booking',
  ),
];
