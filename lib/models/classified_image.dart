import 'parsers.dart';

class ClassifiedImage {
  const ClassifiedImage({
    required this.id,
    required this.classifiedId,
    required this.imagePath,
    this.isMain = false,
    this.createdAt,
  });

  final int id;
  final int classifiedId;
  final String imagePath;
  final bool isMain;
  final DateTime? createdAt;

  factory ClassifiedImage.fromJson(Map<String, dynamic> json) {
    return ClassifiedImage(
      id: parseInt(json['id']),
      classifiedId: parseInt(json['classified_id']),
      imagePath: json['image_path']?.toString() ?? '',
      isMain: parseInt(json['is_main'], fallback: 0) == 1,
      createdAt: parseDate(json['created_at']),
    );
  }
}
