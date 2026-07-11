import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/worker_profile/presentation/pages/worker_profile_page.dart';
import '../../data/mock_workers.dart';

class WorkerListingPage extends StatelessWidget {
  final String category;

  const WorkerListingPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final workers = workersByCategory[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$category Services',
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.navy, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: workers.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_off, size: 56,
                      color: AppColors.navy.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text('No workers available yet',
                      style: GoogleFonts.nunito(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: workers.length,
              itemBuilder: (context, index) {
                return _WorkerCard(worker: workers[index]);
              },
            ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final MockWorker worker;

  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkerProfilePage(worker: worker),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  worker.name.split(' ').last[0],
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.name,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    worker.profession,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Rating
                      ...List.generate(5, (i) => Icon(
                            i < worker.rating.floor()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 14,
                            color: AppColors.primary,
                          )),
                      const SizedBox(width: 6),
                      Text(
                        '${worker.rating} (${worker.reviewCount})',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navyLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.work_outline, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Text(
                        '${worker.completedJobs} jobs',
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

            // Price & arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  worker.hourlyRate,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: worker.isAvailable
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    worker.isAvailable ? 'Available' : 'Busy',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: worker.isAvailable ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
