import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../services/data/mock_workers.dart';

class WorkerProfilePage extends StatefulWidget {
  final MockWorker worker;

  const WorkerProfilePage({super.key, required this.worker});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  final _bookingNameCtrl = TextEditingController();
  final _bookingPhoneCtrl = TextEditingController();
  final _bookingDescCtrl = TextEditingController();
  String _selectedService = '';
  bool _showBookingForm = false;

  @override
  void dispose() {
    _bookingNameCtrl.dispose();
    _bookingPhoneCtrl.dispose();
    _bookingDescCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.worker;
    _selectedService = _selectedService.isEmpty ? w.services.first : _selectedService;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── AppBar ──────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(w.name,
              style: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Profile Header ────────────────
                _buildProfileHeader(w),

                const SizedBox(height: 10),

                // ─── Quick Stats Row ───────────────
                _buildStatsRow(w),

                const SizedBox(height: 16),

                // ─── Bio ───────────────────────────
                _buildSection('About', w.bio),

                const SizedBox(height: 16),

                // ─── Services ──────────────────────
                _buildServicesList(w),

                const SizedBox(height: 16),

                // ─── Portfolio ─────────────────────
                _buildPortfolio(w),

                const SizedBox(height: 16),

                // ─── Reviews ───────────────────────
                _buildReviews(w),

                const SizedBox(height: 16),

                // ─── Location ──────────────────────
                _buildLocation(w),

                const SizedBox(height: 16),

                // ─── Booking Form ──────────────────
                _buildBookingSection(w),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // ─── Bottom Action Bar ────────────────────
      bottomNavigationBar: _buildBottomBar(w),
    );
  }

  Widget _buildProfileHeader(MockWorker w) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.2),
              border: Border.all(color: AppColors.navy.withValues(alpha: 0.1), width: 3),
            ),
            child: Center(
              child: Text(
                w.name.split(' ').last[0],
                style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(w.name,
            style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(w.profession,
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 8),
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (i) => Icon(
                    i < w.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 20, color: AppColors.primary,
                  )),
              const SizedBox(width: 8),
              Text('${w.rating}  •  ${w.reviewCount} reviews',
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyLight),
              ),
            ],
          ),

          const SizedBox(height: 12),
          // Availability badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: (w.isAvailable ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: w.isAvailable ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: 6),
                Text(w.isAvailable ? 'Available for work' : 'Currently busy',
                  style: GoogleFonts.nunito(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: w.isAvailable ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(MockWorker w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statBox(Icons.work_history, '${w.completedJobs}', 'Jobs Done'),
          const SizedBox(width: 10),
          _statBox(Icons.timer, '${w.yearsExperience} yrs', 'Experience'),
          const SizedBox(width: 10),
          _statBox(Icons.payments_outlined, w.hourlyRate, '/hr'),
        ],
      ),
    );
  }

  Widget _statBox(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.navy),
            const SizedBox(height: 6),
            Text(value,
              style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy),
            ),
            const SizedBox(height: 2),
            Text(label,
              style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 8),
          Text(content,
            style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w500,
              color: AppColors.textPrimary, height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(MockWorker w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Services Offered',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: w.services.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('✓  $s',
                style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolio(MockWorker w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Portfolio',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: w.portfolioImages.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final colors = [AppColors.navy, AppColors.primaryDark, AppColors.navyLight, AppColors.success, AppColors.error];
                return Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length].withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library_rounded, size: 36,
                          color: colors[index % colors.length].withValues(alpha: 0.4)),
                      const SizedBox(height: 8),
                      Text('Project ${index + 1}',
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600,
                          color: colors[index % colors.length].withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(MockWorker w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Customer Reviews',
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              Text('See all',
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyLight),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...w.reviews.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.customerName,
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(r.date,
                      style: GoogleFonts.nunito(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < r.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 12, color: AppColors.primary,
                  )),
                ),
                const SizedBox(height: 6),
                Text(r.comment,
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary, height: 1.4,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLocation(MockWorker w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location',
            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 10),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 40, color: AppColors.error),
                const SizedBox(height: 8),
                Text(w.location,
                  style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: 4),
                Text('${w.lat.toStringAsFixed(4)}, ${w.lng.toStringAsFixed(4)}',
                  style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(
                      'https://www.google.com/maps?q=${w.lat},${w.lng}',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Open in Maps',
                      style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection(MockWorker w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Book ${w.name.split(' ').first}',
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              TextButton(
                onPressed: () => setState(() => _showBookingForm = !_showBookingForm),
                child: Text(
                  _showBookingForm ? 'Cancel' : 'Book Now',
                  style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                ),
              ),
            ],
          ),

          if (_showBookingForm) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _bookingNameCtrl,
                    style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textPrimary),
                    decoration: _inputDeco('Your Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bookingPhoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textPrimary),
                    decoration: _inputDeco('Phone Number'),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedService,
                        isExpanded: true,
                        style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textPrimary),
                        items: w.services.map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, style: GoogleFonts.nunito(fontSize: 13)),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedService = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bookingDescCtrl,
                    maxLines: 3,
                    style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textPrimary),
                    decoration: _inputDeco('Describe the job...'),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking request sent to ${w.name}!'),
                            backgroundColor: AppColors.navy,
                          ),
                        );
                        setState(() => _showBookingForm = false);
                        _bookingNameCtrl.clear();
                        _bookingPhoneCtrl.clear();
                        _bookingDescCtrl.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Send Booking Request',
                        style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
      ),
    );
  }

  Widget _buildBottomBar(MockWorker w) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Call
            _bottomBtn(Icons.call, AppColors.primaryDark, () async {
              final uri = Uri(scheme: 'tel', path: w.phone);
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }),

            const SizedBox(width: 10),

            // Message
            _bottomBtn(Icons.chat_bubble_outline, AppColors.navy, () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChatPage(workerName: w.name, workerProfession: w.profession),
              ));
            }),

            const SizedBox(width: 10),

            // Book
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _showBookingForm = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text('Book', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
