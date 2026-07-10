import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/chat/presentation/pages/chat_page.dart';
import '../../../../features/home/domain/entities/home_item.dart';

class JobDetailsPage extends StatelessWidget {
  final HomeItem job;

  const JobDetailsPage({super.key, required this.job});

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
          'Job Details',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTimeline(),
            const SizedBox(height: 16),
            _buildWorkerCard(context),
            const SizedBox(height: 12),
            _buildJobDescription(),
            const SizedBox(height: 12),
            _buildPaymentCard(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(Icons.build_rounded, color: AppColors.navy, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job ${job.jobId ?? job.id}',
                  style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  job.jobStatus ?? 'In Progress',
                  style: GoogleFonts.nunito(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, color: AppColors.primary, size: 14),
                  const SizedBox(width: 4),
                  Text('Elapsed',
                    style: GoogleFonts.nunito(fontSize: 10,
                      color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                job.elapsedTime ?? '00:00:00',
                style: GoogleFonts.nunito(
                  fontSize: 16, fontWeight: FontWeight.w800,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final stages = [
      _TimelineStage('Booking Confirmed', 'Your booking has been confirmed',
          'Jul 10, 09:30 AM', true, false),
      _TimelineStage('Worker Assigned',
          '${job.workerName ?? "Worker"} has been assigned',
          'Jul 10, 10:00 AM', true, false),
      _TimelineStage('En Route', 'Worker is on the way to your location',
          'Jul 10, 10:15 AM', true, false),
      _TimelineStage('In Progress', 'Work is currently being done',
          'Jul 10, 10:30 AM',
          job.jobStatus == 'In Progress',
          job.jobStatus == 'In Progress'),
      _TimelineStage('Completed', 'Job finished and reviewed',
          'Pending', false, false),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timeline',
            style: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < stages.length; i++)
            _buildTimelineItem(stages[i], i == stages.length - 1),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_TimelineStage stage, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: stage.isCurrent ? 16 : 12,
                height: stage.isCurrent ? 16 : 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stage.isCompleted ? AppColors.navy : AppColors.border,
                  border: stage.isCurrent
                      ? Border.all(color: AppColors.primary, width: 3)
                      : null,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 48,
                  color: stage.isCompleted
                      ? AppColors.navy.withValues(alpha: 0.4)
                      : AppColors.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stage.title,
                  style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700,
                    color: stage.isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(stage.subtitle,
                  style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(stage.time,
                  style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600,
                    color: stage.isCompleted ? AppColors.navyLight : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Provider',
            style: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.inputFill,
                  border: Border.all(
                    color: AppColors.navy.withValues(alpha: 0.15), width: 2,
                  ),
                ),
                child: const Icon(Icons.person, color: AppColors.navy, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.workerName ?? 'Worker',
                      style: GoogleFonts.nunito(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(job.workerProfession ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        final rating = job.workerRating ?? 0;
                        return Icon(
                          index < rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 14, color: AppColors.primary,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _iconBtn(Icons.call, AppColors.primaryDark, () {}),
                  const SizedBox(height: 8),
                  _iconBtn(Icons.chat_bubble_outline, AppColors.navy, () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChatPage(
                        workerName: job.workerName ?? 'Worker',
                        workerProfession: job.workerProfession ?? '',
                      ),
                    ));
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildJobDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Job Description',
            style: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            job.jobDetails ?? job.description,
            style: GoogleFonts.nunito(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: AppColors.textPrimary, height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment',
            style: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          _payRow('Hourly Rate', job.hourlyRate ?? 'KES 0/='),
          const SizedBox(height: 8),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          _payRow('Estimated Total', 'KES 300/='),
        ],
      ),
    );
  }

  Widget _payRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
          style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(value,
          style: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.call, size: 18),
            label: Text('Call Worker',
              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChatPage(
                  workerName: job.workerName ?? 'Worker',
                  workerProfession: job.workerProfession ?? '',
                ),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: Text('Message',
              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStage {
  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  const _TimelineStage(
    this.title,
    this.subtitle,
    this.time,
    this.isCompleted,
    this.isCurrent,
  );
}
