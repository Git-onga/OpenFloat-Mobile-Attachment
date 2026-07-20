import 'package:flutter/material.dart';
import 'package:home_link/core/constants/app_colors.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'See what customers are saying about your work',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < 4 ? Icons.star : Icons.star_half,
                              color: AppColors.warning,
                              size: 24,
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Based on 24 reviews',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _RatingBar(
                          label: '5 ★',
                          percentage: 0.75,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 4),
                        _RatingBar(
                          label: '4 ★',
                          percentage: 0.15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 4),
                        _RatingBar(
                          label: '3 ★',
                          percentage: 0.05,
                          color: AppColors.warning,
                        ),
                        const SizedBox(height: 4),
                        _RatingBar(
                          label: '2 ★',
                          percentage: 0.03,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 4),
                        _RatingBar(
                          label: '1 ★',
                          percentage: 0.02,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _ReviewCard(
                  customerName: 'Jane Muthoni',
                  rating: 5,
                  date: '2 days ago',
                  comment:
                      'Excellent plumber! Very professional and completed the job on time. Highly recommend!',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const _RatingBar({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: TextStyle()),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.surface,
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${(percentage * 100).toInt()}%',
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String customerName;
  final int rating;
  final String date;
  final String comment;

  const _ReviewCard({
    required this.customerName,
    required this.rating,
    required this.date,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  customerName[0],
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: AppColors.warning,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(date),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
        ],
      ),
    );
  }
}
