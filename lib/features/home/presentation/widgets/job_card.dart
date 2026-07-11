import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../job_details/presentation/pages/job_details_page.dart';
import '../../domain/entities/home_item.dart';

class JobCard extends StatelessWidget {
  final HomeItem item;

  const JobCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // === Top Navy Bar (10%) ===
          _buildTopBar(),

          // === Bottom White Area (90%) ===
          _buildBottomContent(context),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final headerBg = isDark ? Theme.of(context).colorScheme.surface : AppColors.navy;
        final headerText = isDark ? AppColors.navy : AppColors.textOnPrimary;
        final headerAccent = AppColors.primary;
        final headerSubtext = isDark
            ? AppColors.navy.withValues(alpha: 0.6)
            : AppColors.textOnPrimary.withValues(alpha: 0.7);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: headerBg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Row(
            children: [
              // -- Left: Notification circle --
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: headerAccent,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: headerText,
                  size: 16,
                ),
              ),

              const SizedBox(width: 12),

              // -- Middle: Job ID + Status --
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Job ${item.jobId ?? item.id}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: headerText,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.jobStatus ?? 'In Progress',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: headerAccent,
                      ),
                    ),
                  ],
                ),
              ),

              // -- Right: Clock + Elapsed Time --
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: headerAccent,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Elapsed Time',
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: headerSubtext,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.elapsedTime ?? '00:00:00',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: headerText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Left Column (30%) - Worker Info ===
          SizedBox(
            width: 110,
            child: Column(
              children: [
                // Profile circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).inputDecorationTheme.fillColor!,
                    border: Border.all(
                      color: AppColors.navy.withValues(alpha: 0.15),
                      width: 2,
                    ),
                  ),
                  child: item.workerImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            item.workerImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.person,
                              color: AppColors.navy,
                              size: 24,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.navy,
                          size: 24,
                        ),
                ),

                const SizedBox(height: 8),

                // Name
                Text(
                  item.workerName ?? 'Worker',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // Profession + Rating
                Text(
                  item.workerProfession ?? '',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // Star rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final rating = item.workerRating ?? 0;
                    return Icon(
                      index < rating.floor()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 12,
                      color: AppColors.primary,
                    );
                  }),
                ),

                const SizedBox(height: 10),

                // Call & Text buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Call button
                    _buildIconButton(Icons.call, () {
                      _makeCall(context);
                    }),
                    const SizedBox(width: 8),
                    // Message button
                    _buildIconButton(Icons.chat_bubble_outline, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            workerName: item.workerName ?? 'Worker',
                            workerProfession: item.workerProfession ?? '',
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // === Right Column (70%) - Job Details ===
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job description
                Text(
                  item.jobDetails ?? item.description,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                // Hourly rate
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 15,
                      color: AppColors.navy.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.hourlyRate ?? 'KES 0/=',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const Spacer(),
                    // Details button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => JobDetailsPage(job: item),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Details',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        child: Icon(
          icon,
          size: 15,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Future<void> _makeCall(BuildContext context) async {
    if (!context.mounted) return;
    final uri = Uri(scheme: 'tel', path: '+254700000000');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not initiate call')),
      );
    }
  }
}
