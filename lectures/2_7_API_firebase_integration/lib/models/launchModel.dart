class LaunchModel {
  final String id;
  final String name;
  final DateTime net;           // LL2 'net'
  final int rocketConfigId;     // rocket.configuration.id
  final String rocketFullName;  // rocket.configuration.full_name (fallback to name)
  final String? imageThumbUrl;  // image.thumbnail_url
  final String? missionDescription; // mission.description

  LaunchModel({
    required this.id,
    required this.name,
    required this.net,
    required this.rocketConfigId,
    required this.rocketFullName,
    this.imageThumbUrl,
    this.missionDescription,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> j) {
    final rocket  = j['rocket'] as Map<String, dynamic>?;
    final config  = rocket?['configuration'] as Map<String, dynamic>?;
    final image   = j['image'] as Map<String, dynamic>?;
    final mission = j['mission'] as Map<String, dynamic>?;

    return LaunchModel(
      id: j['id'] as String,
      name: j['name'] as String,
      net: DateTime.parse(j['net'] as String),
      rocketConfigId: (config?['id'] as num?)?.toInt() ?? -1,
      rocketFullName: (config?['full_name'] as String?) ??
          (config?['name'] as String?) ?? 'Unknown',
      imageThumbUrl: image?['thumbnail_url'] as String?,
      missionDescription: mission?['description'] as String?,
    );
  }
}