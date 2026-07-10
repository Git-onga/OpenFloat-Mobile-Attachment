import 'package:equatable/equatable.dart';

class HomeItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  // Job-specific fields
  final String? jobId;
  final String? jobStatus;
  final String? elapsedTime;
  final String? workerName;
  final String? workerProfession;
  final double? workerRating;
  final String? workerImageUrl;
  final String? jobDetails;
  final String? hourlyRate;
  final String? category; // 'ongoing' or 'booking'

  const HomeItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.jobId,
    this.jobStatus,
    this.elapsedTime,
    this.workerName,
    this.workerProfession,
    this.workerRating,
    this.workerImageUrl,
    this.jobDetails,
    this.hourlyRate,
    this.category,
  });

  HomeItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    String? jobId,
    String? jobStatus,
    String? elapsedTime,
    String? workerName,
    String? workerProfession,
    double? workerRating,
    String? workerImageUrl,
    String? jobDetails,
    String? hourlyRate,
    String? category,
  }) {
    return HomeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      jobId: jobId ?? this.jobId,
      jobStatus: jobStatus ?? this.jobStatus,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      workerName: workerName ?? this.workerName,
      workerProfession: workerProfession ?? this.workerProfession,
      workerRating: workerRating ?? this.workerRating,
      workerImageUrl: workerImageUrl ?? this.workerImageUrl,
      jobDetails: jobDetails ?? this.jobDetails,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        createdAt,
        jobId,
        jobStatus,
        elapsedTime,
        workerName,
        workerProfession,
        workerRating,
        workerImageUrl,
        jobDetails,
        hourlyRate,
        category,
      ];
}
