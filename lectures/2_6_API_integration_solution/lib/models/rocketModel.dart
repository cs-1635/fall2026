class RocketModel {
  final int id;
  final String fullName;
  final String? description;
  final String? imageUrl;

  RocketModel({
    required this.id,
    required this.fullName,
    this.description,
    this.imageUrl,
  });

  factory RocketModel.fromJson(Map<String, dynamic> j) {
    final image = j['image'] as Map<String, dynamic>?;
    return RocketModel(
      id: (j['id'] as num).toInt(),
      fullName: (j['full_name'] as String?) ?? (j['name'] as String?) ?? 'Unknown',
      description: j['description'] as String?,
      imageUrl: image?['image_url'] as String?,
    );
  }
}