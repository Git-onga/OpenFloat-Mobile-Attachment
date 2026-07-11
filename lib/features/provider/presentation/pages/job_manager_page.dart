import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/provider/data/mock_provider_data.dart';

class JobManagerPage extends StatelessWidget {
  const JobManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inProgress = providerJobs.where((j) => j.status == 'in_progress').toList();
    final upcoming = providerJobs.where((j) => j.status == 'accepted').toList();
    final completed = providerJobs.where((j) => j.status == 'completed').toList();
    final denied = providerJobs.where((j) => j.status == 'denied').toList();

    final totalEarnings = completed.fold<double>(0, (sum, j) {
      final val = j.totalEarned.replaceAll(RegExp(r'[^0-9]'), '');
      return sum + (double.tryParse(val) ?? 0);
    });
    final weekEarnings = totalEarnings * 0.35; // mock: ~35% earned this week

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ─── Header ──────────────────────
          Text('Job Manager',
              style: GoogleFonts.baloo2(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 4),
          Text('Track your work, earnings and job history',
              style: GoogleFonts.nunito(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),

          const SizedBox(height: 16),

          // ─── Earnings Summary ────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navy, Color(0xFF2A3A5F)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Earnings',
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600,
                            color: AppColors.textOnPrimary.withValues(alpha: 0.7))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text('+12%',
                          style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('KES ${totalEarnings.toInt()}/=',
                    style: GoogleFonts.baloo2(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textOnPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _earningsStat(context, 'This Week', 'KES ${weekEarnings.toInt()}/=', AppColors.primary),
                    const SizedBox(width: 20),
                    _earningsStat(context, 'Jobs Done', '${completed.length}', AppColors.success),
                    const SizedBox(width: 20),
                    _earningsStat(context, 'Active', '${inProgress.length}', AppColors.textOnPrimary),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ─── Job Progress Summary ────────
          Text('Job Summary',
              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 10),
          Row(
            children: [
              _summaryCard(context, 'In Progress', inProgress.length, AppColors.primary),
              const SizedBox(width: 10),
              _summaryCard(context, 'Upcoming', upcoming.length, AppColors.navy),
              const SizedBox(width: 10),
              _summaryCard(context, 'Completed', completed.length, AppColors.success),
              const SizedBox(width: 10),
              _summaryCard(context, 'Denied', denied.length, AppColors.error),
            ],
          ),

          const SizedBox(height: 20),

          // ─── In Progress ─────────────────
          if (inProgress.isNotEmpty) ...[
            Text('In Progress',
                style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            ...inProgress.map((j) => _JobRow(job: j)),
            const SizedBox(height: 12),
          ],

          // ─── Completed History ───────────
          Text('Completed',
              style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          ...completed.map((j) => _JobRow(job: j)),
          if (denied.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Denied',
                style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            ...denied.map((j) => _JobRow(job: j)),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _earningsStat(BuildContext context, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.nunito(fontSize: 10, color: color.withValues(alpha: 0.8))),
        const SizedBox(height: 2),
        Text(value,
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _summaryCard(BuildContext context, String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text('$count',
                style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _JobRow extends StatelessWidget {
  final ProviderJob job;
  const _JobRow({required this.job});

  Color _statusColor() {
    switch (job.status) {
      case 'in_progress': return AppColors.primary;
      case 'completed': return AppColors.success;
      case 'denied': return AppColors.error;
      default: return AppColors.navy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _statusColor().withValues(alpha: 0.12),
            ),
            child: Icon(
              job.status == 'completed' ? Icons.check : job.status == 'denied' ? Icons.close : Icons.timer,
              size: 16, color: _statusColor(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.service,
                    style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text('${job.clientName} • ${job.date}',
                    style: GoogleFonts.nunito(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          if (job.status == 'completed' || job.status == 'in_progress')
            Text(job.totalEarned,
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
          if (job.status == 'denied')
            Text('Denied',
                style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error)),
        ],
      ),
    );
  }
}
