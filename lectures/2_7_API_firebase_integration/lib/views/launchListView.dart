import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/launchListVM.dart';
import '../repositories/launchRepository.dart';
import '../viewModels/launchDetailVM.dart';
import 'launchDetailView.dart';
import '../widgets/launchTileWidget.dart';

class LaunchListView extends StatefulWidget {
  const LaunchListView({super.key});
  @override
  State<LaunchListView> createState() => _LaunchListViewState();
}

class _LaunchListViewState extends State<LaunchListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<LaunchListVM>().load());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LaunchListVM>();

    Widget body;
    if (vm.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (vm.error != null) {
      body = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Error: ${vm.error}'),
          const SizedBox(height: 8),
          FilledButton(onPressed: vm.load, child: const Text('Retry')),
        ]),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: vm.load,
        child: ListView.separated(
          itemCount: vm.items.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (_, i) {
            final m = vm.items[i];
            final fav = vm.isFavorite(m.id);
            return LaunchTileWidget(
              launchModel: m,
              isFavorite: fav,
              onToggleFavorite: () => vm.toggleFavorite(m),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => LaunchDetailVM(context.read<LaunchRepository>(), m)..loadRocket(),
                    child: const LaunchDetailView(),
                  ),
                ));
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Launches'),
        actions: [
          // Optional quick filter: show count of favorites
          if (vm.favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: Text('★ ${vm.favorites.length}')),
            ),
        ],
      ),
      body: body,
    );
  }
}