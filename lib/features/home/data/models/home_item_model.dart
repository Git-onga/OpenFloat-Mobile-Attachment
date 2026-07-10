import '../../domain/entities/home_item.dart';

class HomeItemModel extends HomeItem {
  const HomeItemModel({
    required super.id,
    required super.title,
    required super.description,
    super.imageUrl,
    required super.createdAt,
    super.jobId,
    super.jobStatus,
    super.elapsedTime,
    super.workerName,
    super.workerProfession,
    super.workerRating,
    super.workerImageUrl,
    super.jobDetails,
    super.hourlyRate,
    super.category,
  });

  factory HomeItemModel.fromJson(Map<String, dynamic> json) {
    return HomeItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      jobId: json['job_id'] as String?,
      jobStatus: json['job_status'] as String?,
      elapsedTime: json['elapsed_time'] as String?,
      workerName: json['worker_name'] as String?,
      workerProfession: json['worker_profession'] as String?,
      workerRating: (json['worker_rating'] as num?)?.toDouble(),
      workerImageUrl: json['worker_image_url'] as String?,
      jobDetails: json['job_details'] as String?,
      hourlyRate: json['hourly_rate'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'job_id': jobId,
      'job_status': jobStatus,
      'elapsed_time': elapsedTime,
      'worker_name': workerName,
      'worker_profession': workerProfession,
      'worker_rating': workerRating,
      'worker_image_url': workerImageUrl,
      'job_details': jobDetails,
      'hourly_rate': hourlyRate,
      'category': category,
    };
  }
}
