import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'worker_listing_page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _searchQuery.isEmpty
        ? _categories
        : _categories
            .where((c) =>
                c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ──────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Text(
            'Services',
            style: GoogleFonts.baloo2(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Find the right professional for your project',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Search Bar ──────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.navy,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ─── Category Grid ───────────────────
            Expanded(
              child: filtered.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _CategoryCard(category: filtered[index]),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 56, color: AppColors.navy.withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          Text(
                            'No services found',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
    );
  }
}

class _ServiceCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final int availableProviders;

  const _ServiceCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.availableProviders,
  });
}

final List<_ServiceCategory> _categories = [
  _ServiceCategory(
    name: 'Electrician',
    icon: Icons.bolt_rounded,
    color: const Color(0xFFF5A623),
    description: 'Wiring, repairs, installations & maintenance',
    availableProviders: 48,
  ),
  _ServiceCategory(
    name: 'Plumber',
    icon: Icons.water_drop_rounded,
    color: const Color(0xFF4A90D9),
    description: 'Pipe repairs, installations, drainage & leaks',
    availableProviders: 35,
  ),
  _ServiceCategory(
    name: 'Home Cleaner',
    icon: Icons.cleaning_services_rounded,
    color: const Color(0xFF7ED321),
    description: 'Deep cleaning, regular upkeep & sanitation',
    availableProviders: 62,
  ),
  _ServiceCategory(
    name: 'Carpenter',
    icon: Icons.handyman_rounded,
    color: const Color(0xFF8B5E3C),
    description: 'Furniture, cabinetry, repairs & custom work',
    availableProviders: 29,
  ),
  _ServiceCategory(
    name: 'Painter',
    icon: Icons.format_paint_rounded,
    color: const Color(0xFFE8596C),
    description: 'Interior, exterior, decorative & waterproofing',
    availableProviders: 41,
  ),
  _ServiceCategory(
    name: 'Landscaper',
    icon: Icons.yard_rounded,
    color: const Color(0xFF50C878),
    description: 'Garden design, lawn care, planting & irrigation',
    availableProviders: 22,
  ),
  _ServiceCategory(
    name: 'Mason',
    icon: Icons.foundation_rounded,
    color: const Color(0xFF6C757D),
    description: 'Brickwork, concrete, tiling & stonework',
    availableProviders: 18,
  ),
  _ServiceCategory(
    name: 'HVAC Technician',
    icon: Icons.ac_unit_rounded,
    color: const Color(0xFF17A2B8),
    description: 'AC repair, heating, ventilation & cooling systems',
    availableProviders: 15,
  ),
  _ServiceCategory(
    name: 'Roofer',
    icon: Icons.roofing_rounded,
    color: const Color(0xFFD35400),
    description: 'Roof installation, repair, waterproofing & gutters',
    availableProviders: 12,
  ),
  _ServiceCategory(
    name: 'Welder',
    icon: Icons.build_circle_rounded,
    color: const Color(0xFF2C3E50),
    description: 'Metal fabrication, gates, grills & repairs',
    availableProviders: 10,
  ),
];

class _CategoryCard extends StatelessWidget {
  final _ServiceCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkerListingPage(category: category.name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 24,
                ),
              ),

              const Spacer(),

              // Name
              Text(
                category.name,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Description
              Text(
                category.description,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Available count
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 12,
                    color: AppColors.navy.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${category.availableProviders} available',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
