import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../features/provider/data/mock_provider_data.dart';
import 'booking_details_page.dart';

/// Displays incoming bookings and the provider's decisions for this session.
class BookingRequestsPage extends StatefulWidget {
  const BookingRequestsPage({super.key});

  @override
  State<BookingRequestsPage> createState() => _BookingRequestsPageState();
}

class _BookingRequestsPageState extends State<BookingRequestsPage> {
  // Requests are kept in separate lists so each status renders in its own section.
  final List<ProviderJob> _requests = List.from(pendingRequests);
  final List<ProviderJob> _accepted = [];
  final List<ProviderJob> _denied = [];

  void _acceptRequest(ProviderJob job) {
    // Move the selected request out of the pending queue before confirming it.
    setState(() {
      _requests.remove(job);
      _accepted.add(job);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted booking from ${job.clientName}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _denyRequest(ProviderJob job) {
    // Capture a provider-supplied explanation before moving the job to denied.
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Deny Request',
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please provide a reason for denying ${job.clientName}\'s request. This shows you\'re considerate.',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText:
                    'E.g., Already booked, schedule conflict, outside service area...',
                hintStyle: GoogleFonts.nunito(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.navy,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // A denial must include context that can be shown back to the client.
              if (reasonCtrl.text.trim().isEmpty) return;
              setState(() {
                _requests.remove(job);
                _denied.add(
                  ProviderJob(
                    id: job.id,
                    clientName: job.clientName,
                    service: job.service,
                    description: job.description,
                    status: 'denied',
                    denialReason: reasonCtrl.text.trim(),
                    date: job.date,
                    time: job.time,
                    location: job.location,
                    hourlyRate: job.hourlyRate,
                    totalEarned: job.totalEarned,
                    clientRating: job.clientRating,
                    clientPhone: job.clientPhone,
                  ),
                );
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Denied request from ${job.clientName}'),
                  backgroundColor: AppColors.navy,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Deny',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show pending, accepted, and denied requests together while any exist.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Requests',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              if (_requests.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_requests.length} new',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Accept or deny incoming booking requests',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _requests.isEmpty && _accepted.isEmpty && _denied.isEmpty
              ? _emptyState()
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (_requests.isNotEmpty) ...[
                      _sectionLabel(
                        'Pending',
                        AppColors.primary,
                        '${_requests.length}',
                      ),
                      ..._requests.map(
                        (r) => _RequestCard(
                          request: r,
                          onAccept: () => _acceptRequest(r),
                          onDeny: () => _denyRequest(r),
                        ),
                      ),
                    ],
                    if (_accepted.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _sectionLabel(
                        'Accepted',
                        AppColors.success,
                        '${_accepted.length}',
                      ),
                      ..._accepted.map(
                        (r) => _RequestCard(request: r, accepted: true),
                      ),
                    ],
                    if (_denied.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _sectionLabel(
                        'Denied',
                        AppColors.error,
                        '${_denied.length}',
                      ),
                      ..._denied.map(
                        (r) => _RequestCard(request: r, denied: true),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label, Color color, String count) {
    // Reuses a color-coded heading for every request-status group.
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    // The page is empty only after every incoming request has been handled.
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
              Icons.inbox_outlined,
              size: 36,
              color: AppColors.navy.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No booking requests',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'New requests from clients will appear here',
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

/// Presents one booking and exposes actions only while it is still pending.
class _RequestCard extends StatelessWidget {
  final ProviderJob request;
  final VoidCallback? onAccept;
  final VoidCallback? onDeny;
  final bool accepted;
  final bool denied;

  const _RequestCard({
    required this.request,
    this.onAccept,
    this.onDeny,
    this.accepted = false,
    this.denied = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookingDetailsPage(
              request: request,
              onAccept: onAccept,
              onDeny: onDeny,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: denied
                ? AppColors.error.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The status icon and booking essentials give a quick overview.
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          (accepted
                                  ? AppColors.success
                                  : denied
                                  ? AppColors.error
                                  : AppColors.primary)
                              .withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      accepted
                          ? Icons.check_circle
                          : denied
                          ? Icons.cancel
                          : Icons.pending_actions,
                      size: 20,
                      color: accepted
                          ? AppColors.success
                          : denied
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.service,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${request.clientName} • ${request.location}',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        request.date,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        request.time,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Keep long client descriptions compact inside the list.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                request.description,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // A denied request retains the explanation entered by the provider.
            if (denied && request.denialReason != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Reason: ${request.denialReason}',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.error.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),

            // Show the offered rate and, when available, the client's rating.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request.hourlyRate,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  if (request.clientRating > 0) ...[
                    const Spacer(),
                    Icon(Icons.star, size: 13, color: AppColors.primary),
                    const SizedBox(width: 2),
                    Text(
                      '${request.clientRating}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Completed requests have no actions; pending ones can be accepted or denied.
            if (onAccept != null && onDeny != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDeny,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Deny',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Accept',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
