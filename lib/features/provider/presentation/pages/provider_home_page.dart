import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/provider/data/mock_provider_data.dart';

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ongoing = providerJobs.where((j) => j.status == 'in_progress').toList();
    final upcoming = providerJobs.where((j) => j.status == 'accepted').toList();
    final todayEarnings = providerJobs
        .where((j) => j.status == 'completed' || j.status == 'in_progress')
        .fold<double>(0, (sum, j) {
      final val = j.totalEarned.replaceAll(RegExp(r'[^0-9]'), '');
      return sum + (double.tryParse(val) ?? 0);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ─── Header ──────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back,',
                    style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  Text(providerName.split(' ').first,
                    style: GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy),
                  ),
                ],
              ),
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Text(providerName.split(' ').last[0],
                    style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ─── Stats Cards ─────────────────
          Row(
            children: [
              _statCard(context, 'Ongoing', '${ongoing.length}', Icons.play_circle, AppColors.primary),
              const SizedBox(width: 10),
              _statCard(context, 'Upcoming', '${upcoming.length}', Icons.event, AppColors.navy),
              const SizedBox(width: 10),
              _statCard(context, 'Earnings', 'KES ${todayEarnings.toInt()}', Icons.payments, AppColors.success),
            ],
          ),

          const SizedBox(height: 20),

          // ─── Active Job Card ─────────────
          Text('Currently Working',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 10),

          if (ongoing.isNotEmpty)
            ...ongoing.map((j) => _ActiveJobCard(job: j))
          else
            _emptyCard(context, 'No active jobs', 'Your ongoing jobs will appear here', Icons.work_outline),

          const SizedBox(height: 18),

          // ─── Upcoming ────────────────────
          Text('Upcoming',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 10),

          if (upcoming.isNotEmpty)
            ...upcoming.map((j) => _UpcomingJobCard(job: j))
          else
            _emptyCard(context, 'No upcoming jobs', 'Accepted bookings appear here', Icons.calendar_today),

          const SizedBox(height: 18),

          // ─── Quick Stats ─────────────────
          Text('Your Performance',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 10),
          _buildPerformanceCard(context),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(value,
              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 2),
            Text(label,
              style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _perfRow(context, 'Rating', '⭐ $providerRating', '($providerReviewCount reviews)'),
          _perfRow(context, 'Completed Jobs', '$providerCompletedJobs', ''),
          _perfRow(context, 'Experience', '$providerYearsExp years', ''),
          _perfRow(context, 'Hourly Rate', providerHourlyRate, ''),
        ],
      ),
    );
  }

  Widget _perfRow(BuildContext context, String label, String value, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
            style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          Row(
            children: [
              Text(value,
                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              if (sub.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(sub,
                  style: GoogleFonts.nunito(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(BuildContext context, String title, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.navy.withValues(alpha: 0.2)),
          const SizedBox(height: 8),
          Text(title,
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700,
                color: AppColors.navy.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 2),
          Text(sub,
            style: GoogleFonts.nunito(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ActiveJobCard extends StatelessWidget {
  final ProviderJob job;
  const _ActiveJobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.play_arrow, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.service, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 2),
                Text('${job.clientName} • ${job.location}',
                    style: GoogleFonts.nunito(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(job.elapsedTime ?? '', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const SizedBox(height: 2),
              Text(job.totalEarned, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingJobCard extends StatelessWidget {
  final ProviderJob job;
  const _UpcomingJobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.navy.withValues(alpha: 0.08),
            ),
            child: const Icon(Icons.event, color: AppColors.navy, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.service, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text('${job.clientName} • ${job.date} ${job.time}',
                    style: GoogleFonts.nunito(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
