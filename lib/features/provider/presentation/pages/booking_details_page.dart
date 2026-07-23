import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/mock_provider_data.dart';

class BookingDetailsPage extends StatelessWidget {
  final ProviderJob request;
  final VoidCallback? onAccept;
  final VoidCallback? onDeny;

  const BookingDetailsPage({
    super.key,
    required this.request,
    this.onAccept,
    this.onDeny,
  });

  Color get statusColor {
    switch (request.status) {
      case 'accepted':
        return AppColors.success;
      case 'completed':
        return Colors.blue;
      case 'denied':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String get statusText {
    switch (request.status) {
      case 'accepted':
        return "Accepted";
      case 'completed':
        return "Completed";
      case 'denied':
        return "Denied";
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: AppColors.navy,
        title: Text(
          "Booking Details",
          style: GoogleFonts.baloo2(
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SERVICE TITLE
            Text(
              request.service,
              style: GoogleFonts.baloo2(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                statusText,
                style: GoogleFonts.nunito(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            //--------------------------------------
            // CLIENT INFORMATION
            //--------------------------------------
            Text(
              "Client Information",
              style: GoogleFonts.baloo2(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primary.withOpacity(.15),
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      request.clientName,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.phone),
                        const SizedBox(width: 10),
                        Text(
                          request.clientPhone ?? "No phone number",
                          style: GoogleFonts.nunito(fontSize: 15),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            request.location,
                            style: GoogleFonts.nunito(fontSize: 15),
                          ),
                        ),
                      ],
                    ),

                    if (request.clientRating > 0) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 10),
                          Text(
                            request.clientRating.toString(),
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Quick Actions",
              style: GoogleFonts.baloo2(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Call client
                    },
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 184, 77),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Open Chat
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text("Chat"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            //--------------------------------------
            // BOOKING DETAILS
            //--------------------------------------
            Text(
              "Booking Details",
              style: GoogleFonts.baloo2(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _detailTile(Icons.badge, "Booking ID", request.id),

                    const Divider(),

                    _detailTile(Icons.calendar_today, "Date", request.date),

                    const Divider(),

                    _detailTile(Icons.access_time, "Time", request.time),

                    const Divider(),

                    _detailTile(Icons.payments, "Price", request.hourlyRate),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            //--------------------------------------
            // DESCRIPTION
            //--------------------------------------
            Text(
              "Job Description",
              style: GoogleFonts.baloo2(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  request.description,
                  style: GoogleFonts.nunito(fontSize: 16, height: 1.6),
                ),
              ),
            ),

            if (request.denialReason != null) ...[
              const SizedBox(height: 25),

              Text(
                "Denial Reason",
                style: GoogleFonts.baloo2(
                  fontSize: 20,
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                color: AppColors.error.withOpacity(.08),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    request.denialReason!,
                    style: GoogleFonts.nunito(),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 35),

            //--------------------------------------
            // BUTTONS
            //--------------------------------------
            if (onAccept != null && onDeny != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDeny,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Deny"),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _detailTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            title,
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
          ),
        ),

        Text(value, style: GoogleFonts.nunito()),
      ],
    );
  }
}
