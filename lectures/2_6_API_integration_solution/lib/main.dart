import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'services/LaunchLibraryApi.dart';
import 'repositories/launchRepository.dart';
import 'viewModels/launchListVM.dart';
import 'views/launchListView.dart';

void main() => runApp(const LaunchPadApp());

class LaunchPadApp extends StatelessWidget {
  const LaunchPadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(create: (_) => http.Client()),
        Provider<LaunchLibraryApi>(create: (localContext) => LaunchLibraryApi(localContext.read<http.Client>())),
        ProxyProvider<LaunchLibraryApi, LaunchRepository>(update: (localContext2, api, __) => LaunchRepository(api),),
        ChangeNotifierProvider<LaunchListVM>(create: (localContext3) => LaunchListVM(localContext3.read<LaunchRepository>()),),
      ],
      child: MaterialApp(
        title: 'LaunchPad',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const LaunchListView(),
      ),
    );
  }
}