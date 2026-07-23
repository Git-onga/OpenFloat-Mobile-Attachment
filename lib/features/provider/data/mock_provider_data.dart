class ProviderJob {
  final String id;
  final String clientName;
  final String service;
  final String description;
  final String status; // 'pending', 'accepted', 'in_progress', 'completed', 'denied'
  final String? denialReason;
  final String date;
  final String time;
  final String location;
  final String hourlyRate;
  final String totalEarned;
  final String? elapsedTime;
  final double clientRating;
  final String? clientPhone;

  const ProviderJob({
    required this.id,
    required this.clientName,
    required this.service,
    required this.description,
    required this.status,
    this.denialReason,
    required this.date,
    required this.time,
    required this.location,
    required this.hourlyRate,
    required this.totalEarned,
    this.elapsedTime,
    this.clientRating = 0,
    this.clientPhone,
  });
}

class ProviderReview {
  final String customerName;
  final double rating;
  final String comment;
  final String date;
  final String service;

  const ProviderReview({
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.service,
  });
}

// ─── Mock Provider Profile ─────────────────────

const String providerName = 'Muriuki James';
const String providerProfession = 'Plumber';
const String providerBio =
    'Certified plumber with 10+ years of experience in residential and commercial plumbing. Specializing in pipe repairs, bathroom installations, water heater systems, and emergency leak detection. Committed to quality workmanship and customer satisfaction.';
const String providerPhone = '+254 745 678 901';
const String providerEmail = 'muriuki.james@kaziconnect.co.ke';
const String providerLocation = 'Karen, Nairobi';
const double providerRating = 4.7;
const int providerReviewCount = 156;
const int providerCompletedJobs = 430;
const int providerYearsExp = 10;
const String providerHourlyRate = 'KES 100/=';

const List<String> providerServices = [
  'Pipe repair & replacement',
  'Drain unblocking & cleaning',
  'Bathroom & kitchen installation',
  'Water heater installation & repair',
  'Leak detection & repair',
  'Septic tank services',
  'Water pump installation',
  'Rainwater harvesting systems',
];

const List<String> providerPortfolio = [
  'Bathroom complete remodel - Karen',
  'Kitchen plumbing overhaul - Westlands',
  'Burst pipe emergency repair - Kilimani',
  'Water heater installation - Lavington',
  'Drainage system upgrade - Parklands',
];

// ─── Mock Jobs ─────────────────────────────────

final List<ProviderJob> providerJobs = [
  ProviderJob(
    id: 'JOB-001',
    clientName: 'Alex Mwangi',
    service: 'Kitchen Plumbing Fix',
    description: 'Burst pipe under kitchen sink. Water leaking onto floor. Needs urgent repair.',
    status: 'in_progress',
    date: 'Jul 10, 2024',
    time: '10:30 AM',
    location: 'Westlands, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 300/=',
    elapsedTime: '02:45:18',
    clientRating: 4.5,
    clientPhone: '+254 712 345 678',
  ),
  ProviderJob(
    id: 'JOB-002',
    clientName: 'Grace Muthoni',
    service: 'Bathroom Renovation',
    description: 'Full bathroom remodel including tiling, new fixtures, and plumbing rerouting.',
    status: 'accepted',
    date: 'Jul 18, 2024',
    time: '10:00 AM',
    location: 'Kilimani, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 0/=',
    clientRating: 0,
    clientPhone: '+254 723 456 789',
  ),
  ProviderJob(
    id: 'JOB-003',
    clientName: 'Robert Kamau',
    service: 'Water Heater Installation',
    description: 'Install new 150L solar water heater system. Includes plumbing connections and safety valve setup.',
    status: 'completed',
    date: 'Jul 05, 2024',
    time: '8:00 AM',
    location: 'Karen, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 400/=',
    elapsedTime: '04:00:00',
    clientRating: 5.0,
    clientPhone: '+254 734 567 890',
  ),
  ProviderJob(
    id: 'JOB-004',
    clientName: 'Cynthia Wanjiku',
    service: 'Drain Unblocking',
    description: 'Kitchen and bathroom drains completely clogged. Water backing up. Need hydro-jetting service.',
    status: 'completed',
    date: 'Jun 28, 2024',
    time: '2:00 PM',
    location: 'Lavington, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 200/=',
    elapsedTime: '02:00:00',
    clientRating: 5.0,
    clientPhone: '+254 745 678 901',
  ),
  ProviderJob(
    id: 'JOB-005',
    clientName: 'Daniel Ochieng',
    service: 'Septic Tank Service',
    description: 'Septic tank inspection, pumping, and minor repairs. Tank hasn\'t been serviced in 3 years.',
    status: 'completed',
    date: 'Jun 20, 2024',
    time: '7:00 AM',
    location: 'Lang\'ata, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 500/=',
    elapsedTime: '05:00:00',
    clientRating: 4.0,
    clientPhone: '+254 756 789 012',
  ),
  ProviderJob(
    id: 'JOB-006',
    clientName: 'Faith Njeri',
    service: 'Leak Detection',
    description: 'Suspected water leak behind walls. Water bill tripled this month. Need specialized leak detection equipment.',
    status: 'denied',
    denialReason: 'Already booked for the entire week. Recommended Wanjala Ben for same-day service.',
    date: 'Jul 08, 2024',
    time: '11:00 AM',
    location: 'Parklands, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 0/=',
    clientRating: 0,
    clientPhone: '+254 767 890 123',
  ),
];

// ─── Mock Booking Requests (Pending) ──────────

final List<ProviderJob> pendingRequests = [
  ProviderJob(
    id: 'REQ-001',
    clientName: 'Susan Wambui',
    service: 'Bathroom Plumbing',
    description: 'Need to install new shower, toilet, and vanity unit. Full bathroom plumbing for new extension.',
    status: 'pending',
    date: 'Jul 22, 2024',
    time: '9:00 AM',
    location: 'Runda, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 0/=',
    clientRating: 4.0,
    clientPhone: '+254 778 901 234',
  ),
  ProviderJob(
    id: 'REQ-002',
    clientName: 'Michael Otieno',
    service: 'Emergency Pipe Repair',
    description: 'Main water line burst in the compound. Water flooding the driveway. Need immediate assistance.',
    status: 'pending',
    date: 'Jul 11, 2024',
    time: 'ASAP',
    location: 'Spring Valley, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 0/=',
    clientRating: 0,
    clientPhone: '+254 789 012 345',
  ),
  ProviderJob(
    id: 'REQ-003',
    clientName: 'Janet Chepkoech',
    service: 'Rainwater Harvesting Setup',
    description: 'Want to install a complete rainwater collection system. 10,000L tank, gutters, filtration, and pump.',
    status: 'pending',
    date: 'Jul 25, 2024',
    time: '8:00 AM',
    location: 'Kitisuru, Nairobi',
    hourlyRate: 'KES 100/=',
    totalEarned: 'KES 0/=',
    clientRating: 4.5,
    clientPhone: '+254 790 123 456',
  ),
];

// ─── Mock Reviews ─────────────────────────────

final List<ProviderReview> providerReviews = [
  ProviderReview(customerName: 'Grace Muthoni', rating: 5, comment: 'James fixed a burst pipe that flooded my kitchen. Fast response, reasonable price, and left everything spotless. Highly recommended!', date: '1 week ago', service: 'Plumbing Repair'),
  ProviderReview(customerName: 'Robert Kamau', rating: 5, comment: 'Did a complete bathroom remodel. Beautiful work. The tiling and fixture installation were perfect. Very professional.', date: '2 weeks ago', service: 'Bathroom Renovation'),
  ProviderReview(customerName: 'Alice Njoki', rating: 4, comment: 'Good work on the drain unblocking. Slightly over the time estimate but the result was worth it. Would hire again.', date: '1 month ago', service: 'Drain Unblocking'),
  ProviderReview(customerName: 'Peter Mwangi', rating: 5, comment: 'Installed a rainwater harvesting system. Saves so much on water bills now. Great advice on setup and maintenance.', date: '1 month ago', service: 'Rainwater System'),
  ProviderReview(customerName: 'Cynthia Wanjiku', rating: 5, comment: 'Emergency call at 2am for a burst geyser. Arrived within 30 minutes. Absolute lifesaver! Highly professional.', date: '2 months ago', service: 'Emergency Repair'),
  ProviderReview(customerName: 'Daniel Ochieng', rating: 4, comment: 'Fixed a stubborn toilet leak that two others couldn\'t. Affordable and efficient. Knowledgeable plumber.', date: '3 months ago', service: 'Leak Repair'),
  ProviderReview(customerName: 'The Patel Family', rating: 5, comment: 'Complete plumbing for our new home. James coordinated with the contractor perfectly. Zero issues 6 months later.', date: '3 months ago', service: 'New Construction'),
  ProviderReview(customerName: 'Hotel Westlands', rating: 5, comment: 'Maintenance contract for 20 rooms. Reliable, clean work, never had a guest complaint about plumbing since.', date: '4 months ago', service: 'Maintenance'),
];
