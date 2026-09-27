import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewModels/launchDetailVM.dart';

class LaunchDetailView extends StatelessWidget {
  const LaunchDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LaunchDetailVM>();
    final launch = vm.launchModel;

    final local = launch.net.toLocal();
    final dateStr = DateFormat.yMMMEd().add_jm().format(local);

    return Scaffold(
      appBar: AppBar(title: Text(launch.name, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (vm.loading) const LinearProgressIndicator(),
          Text('Launch Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(launch.missionDescription ?? 'No details provided.'),
          const SizedBox(height: 16),
          Text('Scheduled (local): $dateStr'),
          const SizedBox(height: 24),
          Text('Rocket', style: Theme.of(context).textTheme.titleLarge),

          if (vm.error != null)
            Text(
              'Failed: ${vm.error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),

          if (vm.rocket != null) ...[
            Text(vm.rocket!.fullName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (vm.rocket!.description != null) Text(vm.rocket!.description!),
            const SizedBox(height: 12),
            if (vm.rocket!.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  vm.rocket!.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ],
      ),
    );
  }
}