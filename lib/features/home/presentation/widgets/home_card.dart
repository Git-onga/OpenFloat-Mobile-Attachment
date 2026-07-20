import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../home/domain/entities/home_item.dart';

class HomeCard extends StatelessWidget {
  final HomeItem item;

  const HomeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Row(
          children: [
            if (item.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                child: Image.network(
                  item.imageUrl!,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 72,
                    height: 72,
                    color: context.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    item.description,
                    style: context.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    Helpers.formatDate(item.createdAt),
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
