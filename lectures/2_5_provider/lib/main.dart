// lib/main.dart
// Flutter Provider demos in one file with a simple menu to navigate
// Demos: Provider, ChangeNotifierProvider, FutureProvider, StreamProvider
// Requires: provider: ^6.0.5 (or newer) in pubspec.yaml

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ProviderDemoApp());
}

class ProviderDemoApp extends StatelessWidget {
  const ProviderDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demos',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DemoMenuPage(),
    );
  }
}

class DemoMenuPage extends StatelessWidget {
  const DemoMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = <_DemoItem>[
      _DemoItem(
        title: '1) Provider (simple value)',
        subtitle: 'Provide immutable config and read it',
        builder: (_) => const BasicProviderPage(),
      ),
      _DemoItem(
        title: '2) ChangeNotifierProvider',
        subtitle: 'Counter with watch/read/Consumer/Selector',
        builder: (_) => const ChangeNotifierProviderPage(),
      ),
      _DemoItem(
        title: '3) FutureProvider',
        subtitle: 'Load async data and render when ready',
        builder: (_) => const FutureProviderPage(),
      ),
      _DemoItem(
        title: '4) FutureProvider + ViewModel',
        subtitle: 'VM holds logic; FutureProvider exposes data',
        builder: (_) => const FutureProviderVmPage(),
      ),
      _DemoItem(
        title: '5) StreamProvider',
        subtitle: 'Live updates from a stream (ticker)',
        builder: (_) => const StreamProviderPage(),
      ),
      _DemoItem(
        title: '6) StreamProvider + ViewModel',
        subtitle: 'VM owns stream lifecycle; UI consumes it',
        builder: (_) => const StreamProviderVmPage(),
      ),
      _DemoItem(
        title: '7) ProxyProvider',
        subtitle: 'Build a value from other providers (reacts to changes)',
        builder: (_) => const ProxyProviderPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Provider Demos'),
      ),
      body: ListView.separated(
        itemCount: demos.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final d = demos[index];
          return ListTile(
            title: Text(d.title),
            subtitle: Text(d.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: d.builder),
            ),
          );
        },
      ),
    );
  }
}

class _DemoItem {
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
  const _DemoItem({
    required this.title,
    required this.subtitle,
    required this.builder,
  });
}

// ---------------------------------------------------------------------------
// 1) Provider — simple, immutable value
// ---------------------------------------------------------------------------

class AppConfig {
  final String appName;
  final String apiBaseUrl;
  const AppConfig({required this.appName, required this.apiBaseUrl});
}

class BasicProviderPage extends StatelessWidget {
  const BasicProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AppConfig>(
      create: (_) => const AppConfig(
        appName: 'Provider Demos',
        apiBaseUrl: 'https://api.example.com',
      ),
      child: Builder(
        builder: (context) {
          // READ ONCE (does not listen for changes — there won’t be any for a const value)
          final cfg = Provider.of<AppConfig>(context, listen: false);
          return Scaffold(
            appBar: AppBar(title: const Text('Provider (simple value)')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App name: ${cfg.appName}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('API base URL: ${cfg.apiBaseUrl}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Notes:\n• Use Provider<T> for immutable/shared objects (config, repositories).\n'
                        '• Access with context.read<T>() or Provider.of<T>(listen: false).\n'
                        '• Since the value never changes, widgets won’t rebuild.\n',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2) ChangeNotifierProvider — mutable state + notifications
// ---------------------------------------------------------------------------

class CounterVM extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  bool get isEven => _count % 2 == 0;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

class ChangeNotifierProviderPage extends StatelessWidget {
  const ChangeNotifierProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put the whole UI into a separate widget so its BuildContext is
    // unquestionably under the provider. This avoids 'no Provider found' in
    // certain hot-reload / rebuild edge cases.
    return ChangeNotifierProvider(
      create: (_) => CounterVM(),
      child: const _CounterBody(),
    );
  }
}

class _CounterBody extends StatelessWidget {
  const _CounterBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChangeNotifierProvider')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Demonstrates watch/read/Consumer/Selector'),
            const SizedBox(height: 16),
            // WATCH — rebuilds when count changes
            Builder(
              builder: (context) {
                final count = context.watch<CounterVM>().count;
                return Text('count (watch): $count', style: Theme.of(context).textTheme.headlineMedium);
              },
            ),
            const SizedBox(height: 8),
            // SELECTOR — rebuilds only when isEven changes
            Selector<CounterVM, bool>(
              selector: (_, vm) => vm.isEven,
              builder: (_, isEven, __) => Text('isEven (selector): $isEven'),
            ),
            const SizedBox(height: 8),
            // CONSUMER — rebuild only this subtree when CounterVM notifies
            Consumer<CounterVM>(
              builder: (_, vm, __) => Text('double (consumer): ${vm.count * 2}'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.read<CounterVM>().decrement(),
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement (read)'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => context.read<CounterVM>().increment(),
                  icon: const Icon(Icons.add),
                  label: const Text('Increment (read)'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _CodeHint(
              lines: [
                'context.watch<T>()  -> listen and rebuild',
                'context.read<T>()   -> read once, no rebuild',
                'Consumer<T>         -> rebuild a constrained subtree',
                'Selector<T,R>       -> rebuild when selected R changes',
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// 3) FutureProvider — async value once
// ---------------------------------------------------------------------------

class UserProfile {
  final String id;
  final String name;
  final int favoriteNumber;
  const UserProfile({required this.id, required this.name, required this.favoriteNumber});
}

Future<UserProfile> fetchUserProfile(String id) async {
  // Simulate network latency
  await Future<void>.delayed(const Duration(seconds: 2));
  return UserProfile(id: id, name: 'Ada Lovelace', favoriteNumber: 7);
}

class FutureProviderPage extends StatelessWidget {
  const FutureProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureProvider<UserProfile?>(
      // Provide null initially; filled when Future completes
      initialData: null,
      create: (_) => fetchUserProfile('user-123'),
      child: Scaffold(
        appBar: AppBar(title: const Text('FutureProvider')),
        body: Center(
          child: Consumer<UserProfile?>(
            builder: (context, profile, _) {
              if (profile == null) {
                return const _LoadingCard(text: 'Loading user profile…');
              }
              return _UserCard(profile: profile);
            },
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserProfile profile;
  const _UserCard({required this.profile});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${profile.id}', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text('Name: ${profile.name}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Favorite number: ${profile.favoriteNumber}'),
          ],
        ),
      ),
    );
  }
}

// -------- ViewModel variant (FutureProvider + VM) --------

/// Simple ViewModel that owns the *logic* for loading a profile.
class ProfileVM {
  final String userId;
  ProfileVM(this.userId);

  Future<UserProfile> load() => fetchUserProfile(userId);
}

class FutureProviderVmPage extends StatelessWidget {
  const FutureProviderVmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the VM itself so the UI (or other layers) can access commands later
        Provider<ProfileVM>(create: (_) => ProfileVM('user-123')),
        // Use FutureProvider to expose the *data* from the VM
        FutureProvider<UserProfile?>(
          initialData: null,
          create: (ctx) => ctx.read<ProfileVM>().load(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('FutureProvider + ViewModel')),
        body: Center(
          child: Consumer<UserProfile?>(
            builder: (context, profile, _) {
              if (profile == null) return const _LoadingCard(text: 'Loading via VM…');
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _UserCard(profile: profile),
                  const SizedBox(height: 12),
                  const _CodeHint(
                    lines: [
                      'VM encapsulates logic -> FutureProvider exposes data',
                      'Use Provider<ProfileVM> to access commands (e.g., refresh)',
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4) StreamProvider — async value many times (live updates)
// ---------------------------------------------------------------------------

Stream<int> tickerStream({int start = 0}) async* {
  var i = start;
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield i++;
  }
}

class StreamProviderPage extends StatelessWidget {
  const StreamProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<int>(
      // Provide a starting value to use until the first event arrives
      initialData: 0,
      create: (_) => tickerStream(start: 1),
      child: Scaffold(
        appBar: AppBar(title: const Text('StreamProvider')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<int>(
                builder: (context, value, child) => Text(
                  'Tick: $value',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Live integer stream via Stream.periodic loop'),
              const SizedBox(height: 24),
              const _CodeHint(
                lines: [
                  'StreamProvider<T> listens to Stream<T>',
                  'Provide initialData to avoid nulls before first event',
                  'Use Consumer<T> / context.watch<T>() to rebuild on new events',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------- ViewModel variant (StreamProvider + VM) --------

class TickerVM {
  final int start;
  late final StreamController<int> _controller;
  late final Timer _timer;
  int _i = 0;

  TickerVM({this.start = 1}) {
    _i = start;
    _controller = StreamController<int>.broadcast();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _controller.add(_i++);
    });
  }

  Stream<int> get stream => _controller.stream;

  void dispose() {
    _timer.cancel();
    _controller.close();
  }
}

class StreamProviderVmPage extends StatelessWidget {
  const StreamProviderVmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // VM owns the stream lifecycle (timer + controller)
        Provider<TickerVM>(
          create: (_) => TickerVM(start: 1),
          dispose: (_, vm) => vm.dispose(),
        ),
        // Expose the data as a Stream<int> via StreamProvider
        StreamProvider<int>(
          initialData: 0,
          create: (ctx) => ctx.read<TickerVM>().stream,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('StreamProvider + ViewModel')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<int>(
                builder: (context, value, child) => Text(
                  'VM Tick: $value',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Use a Builder to obtain a context that is *definitely* under the providers
                  Builder(
                    builder: (ctx) => ElevatedButton(
                      onPressed: () {
                        final vm = ctx.read<TickerVM>();
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('VM is running the stream…')),
                        );
                      },
                      child: const Text('Talk to VM'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _CodeHint(
                lines: [
                  'Provider<TickerVM> exposes commands/lifecycle',
                  'StreamProvider<int> exposes the data to the UI',
                  'Use dispose: to clean up timers/streams',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// 7) ProxyProvider — derive a value from other providers
// ---------------------------------------------------------------------------

/// Simple auth view-model. When `token` changes, dependents should update.
class AuthVM extends ChangeNotifier {
  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login() async {
    // Fake a login delay and produce a token
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _token = 'fake.jwt.token.${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}

/// An API client that needs both the base URL (from AppConfig) and the current
/// auth token (from AuthVM). We keep it as a single long-lived instance whose
/// fields are updated by ProxyProvider to avoid recreating clients constantly.
class ApiClient {
  String _baseUrl = '';
  String? _token;

  void configure({required String baseUrl, required String? token}) {
    _baseUrl = baseUrl;
    _token = token;
  }

  String get baseUrl => _baseUrl;
  String? get token => _token;

  /// Fake "GET" call that just returns a string describing the request.
  Future<String> get(String path) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final authHeader = _token == null ? 'none' : 'Bearer ${_token!.substring(0, 10)}…';
    return 'GET $_baseUrl$path\nAuthorization: $authHeader';
  }
}

class ProxyProviderPage extends StatelessWidget {
  const ProxyProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // (Re)use the AppConfig from your earlier demo, or provide a fresh one here:
        Provider<AppConfig>(
          create: (_) => const AppConfig(
            appName: 'Provider Demos',
            apiBaseUrl: 'https://api.example.com',
          ),
        ),
        ChangeNotifierProvider<AuthVM>(create: (_) => AuthVM()),

        // Create one ApiClient and keep it; update it whenever AppConfig/AuthVM change.
        ProxyProvider2<AppConfig, AuthVM, ApiClient>(
          // Create a single instance once:
          create: (_) => ApiClient(),
          // Update is called whenever AppConfig or AuthVM change.
          update: (context, cfg, auth, client) {
            client ??= ApiClient();
            client.configure(baseUrl: cfg.apiBaseUrl, token: auth.token);
            return client;
          },
        ),
      ],
      child: const _ProxyBody(),
    );
  }
}

class _ProxyBody extends StatelessWidget {
  const _ProxyBody();

  @override
  Widget build(BuildContext context) {
    final cfg = context.read<AppConfig>(); // immutable, read once
    final auth = context.watch<AuthVM>();  // watch to repaint login state
    final api  = context.watch<ApiClient>(); // watch to reflect latest config/token

    return Scaffold(
      appBar: AppBar(title: const Text('ProxyProvider')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App: ${cfg.appName}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('ApiClient.baseUrl: ${api.baseUrl}'),
            Text('Auth token present: ${api.token != null}'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: auth.isLoggedIn ? null : () => auth.login(),
                  icon: const Icon(Icons.login),
                  label: const Text('Login (sets token)'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: auth.isLoggedIn ? () => auth.logout() : null,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout (clears token)'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await api.get('/profile');
                // Show the "request" we made with current token/baseUrl
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('ApiClient GET'),
                      content: Text(result),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Call api.get("/profile")'),
            ),
            const SizedBox(height: 24),
            const _CodeHint(
              lines: [
                'ProxyProvider2<AppConfig, AuthVM, ApiClient>',
                '• create: (_) => ApiClient()  // single instance',
                '• update: (ctx, cfg, auth, client) {',
                '    client.configure(baseUrl: cfg.apiBaseUrl, token: auth.token);',
                '    return client;',
                '  }',
                '',
                'Changes in AppConfig/AuthVM automatically refresh ApiClient.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// ---------------------------------------------------------------------------
// Shared UI helpers
// ---------------------------------------------------------------------------

class _LoadingCard extends StatelessWidget {
  final String text;
  const _LoadingCard({required this.text});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _CodeHint extends StatelessWidget {
  final List<String> lines;
  const _CodeHint({required this.lines});
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      color: Theme.of(context).colorScheme.primary,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final l in lines) Text(l, style: style),
        ],
      ),
    );
  }
}
