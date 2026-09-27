import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/launchModel.dart';

class LaunchTileWidget extends StatelessWidget {
  final LaunchModel launchModel;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const LaunchTileWidget({
    super.key,
    required this.launchModel,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final local = launchModel.net.toLocal();
    final dateStr = DateFormat.yMMMEd().add_jm().format(local);

    return ListTile(
      leading: launchModel.imageThumbUrl != null
          ? CircleAvatar(backgroundImage: NetworkImage(launchModel.imageThumbUrl!))
          : const CircleAvatar(child: Icon(Icons.rocket_launch)),
      title: Text(launchModel.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${launchModel.rocketFullName} • $dateStr',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: onToggleFavorite,
        tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
      ),
      onTap: onTap,
    );
  }
}