import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/launchModel.dart';

class LaunchTileWidget extends StatelessWidget {
  final LaunchModel launchModel;
  final VoidCallback onTap;

  const LaunchTileWidget({
    super.key,
    required this.launchModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final local = launchModel.net.toLocal();
    final dateStr = DateFormat.yMMMEd().add_jm().format(local);

    return ListTile(
      leading: launchModel.imageThumbUrl != null
          ? CircleAvatar(backgroundImage: NetworkImage(launchModel.imageThumbUrl!))
          : const CircleAvatar(child: Icon(Icons.rocket_launch)),
      title: Text(
        launchModel.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${launchModel.rocketFullName} • $dateStr',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}