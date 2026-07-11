import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/provider/data/mock_provider_data.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  bool _isEditing = false;
  final _bioCtrl = TextEditingController(text: providerBio);
  final _phoneCtrl = TextEditingController(text: providerPhone);
  final _emailCtrl = TextEditingController(text: providerEmail);
  final _locationCtrl = TextEditingController(text: providerLocation);
  bool _showAddPortfolio = false;
  final _portfolioDescCtrl = TextEditingController();
  List<String> _portfolio = List.from(providerPortfolio);

  @override
  void dispose() {
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _portfolioDescCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Text('My Profile',
                  style: GoogleFonts.baloo2(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.navy)),
              GestureDetector(
                onTap: () => setState(() { if (_isEditing) { setState(() => _isEditing = false); } else { setState(() => _isEditing = true); } }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: _isEditing ? AppColors.success : AppColors.navy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_isEditing ? Icons.check : Icons.edit_outlined, size: 16,
                          color: _isEditing ? Colors.white : AppColors.navy),
                      const SizedBox(width: 4),
                      Text(_isEditing ? 'Save' : 'Edit',
                          style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700,
                              color: _isEditing ? Colors.white : AppColors.navy)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ─── Avatar & Stats ──────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.2),
                    border: Border.all(color: AppColors.navy.withValues(alpha: 0.15), width: 3),
                  ),
                  child: Center(
                    child: Text(providerName.split(' ').last[0],
                        style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(providerName,
                    style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                Text(providerProfession,
                    style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(5, (i) => Icon(
                        i < providerRating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 16, color: AppColors.primary)),
                    const SizedBox(width: 6),
                    Text('$providerRating ($providerReviewCount)',
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navyLight)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _miniStat('${providerCompletedJobs}', 'Jobs'),
                    _miniStat('$providerYearsExp yrs', 'Exp'),
                    _miniStat(providerHourlyRate, '/hr'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ─── Bio ─────────────────────────
          _section('About Me'),
          if (_isEditing)
            _buildEditField(_bioCtrl, maxLines: 4)
          else
            Text(providerBio, style: GoogleFonts.nunito(fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface, height: 1.5)),

          const SizedBox(height: 16),

          // ─── Contact ────────────────────
          _section('Contact'),
          if (_isEditing) ...[
            _buildEditField(_phoneCtrl, label: 'Phone'),
            const SizedBox(height: 8),
            _buildEditField(_emailCtrl, label: 'Email'),
            const SizedBox(height: 8),
            _buildEditField(_locationCtrl, label: 'Location'),
          ] else ...[
            _contactRow(Icons.phone, providerPhone),
            _contactRow(Icons.email, providerEmail),
            _contactRow(Icons.location_on, providerLocation),
          ],

          const SizedBox(height: 16),

          // ─── Services ───────────────────
          _section('My Services'),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: providerServices.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('✓ $s', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
            )).toList(),
          ),

          const SizedBox(height: 20),

          // ─── Portfolio ──────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Portfolio', style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
              GestureDetector(
                onTap: () => setState(() => _showAddPortfolio = !_showAddPortfolio),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_showAddPortfolio ? Icons.close : Icons.add, size: 14, color: AppColors.primaryDark),
                      const SizedBox(width: 4),
                      Text(_showAddPortfolio ? 'Cancel' : 'Add', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_showAddPortfolio)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _portfolioDescCtrl,
                      style: GoogleFonts.nunito(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Describe your project...',
                        hintStyle: GoogleFonts.nunito(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_portfolioDescCtrl.text.trim().isNotEmpty) {
                        setState(() {
                          _portfolio.insert(0, _portfolioDescCtrl.text.trim());
                          _portfolioDescCtrl.clear();
                          _showAddPortfolio = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Add', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

          ..._portfolio.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.photo_library, size: 22, color: AppColors.navy.withValues(alpha: 0.3)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface)),
                      Text('Added ${e.key == 0 ? "just now" : "${e.key + 1} items ago"}',
                          style: GoogleFonts.nunito(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                  onPressed: () => setState(() => _portfolio.removeAt(e.key)),
                ),
              ],
            ),
          )),

          const SizedBox(height: 20),

          // ─── Reviews ─────────────────────
          _section('Customer Reviews'),
          ...providerReviews.take(4).map((r) => _reviewCard(r)),
          if (providerReviews.length > 4)
            GestureDetector(
              onTap: () => _showAllReviews(context),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('See all ${providerReviews.length} reviews →',
                    style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navyLight)),
              ),
            ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showAllReviews(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Reviews', style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: AppColors.navy)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: providerReviews.map((r) => _reviewCard(r)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
    );
  }

  Widget _miniStat(String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
          Text(label, style: GoogleFonts.nunito(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.navy.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildEditField(TextEditingController ctrl, {int maxLines = 1, String label = ''}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.nunito(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.navy, width: 1.5)),
      ),
    );
  }

  Widget _reviewCard(ProviderReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.customerName,
                  style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface)),
              Text(review.date,
                  style: GoogleFonts.nunito(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(5, (i) => Icon(
                  i < review.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 12, color: AppColors.primary)),
              const SizedBox(width: 8),
              Text('• ${review.service}',
                  style: GoogleFonts.nunito(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 6),
          Text(review.comment,
              style: GoogleFonts.nunito(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, height: 1.4)),
        ],
      ),
    );
  }
}
