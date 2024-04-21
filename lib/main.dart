import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'services/realtime_database_service.dart';
import 'ui/graph/graph_screen.dart';
import 'ui/layout_screen.dart';
import 'firebase_options.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _router.goNamed('main'));
    return const SizedBox.shrink();
  },
  routes: [
    GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const LayoutScreen()),
    GoRoute(
      path: '/:page/:node',
      name: 'graph',
      builder: (context, state) => GraphScreen(
        page: state.pathParameters['page']!,
        node: state.pathParameters['node']!,
      ),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setPathUrlStrategy();
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => RealtimeDatabaseService(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Sistem Monitoring Hidroponik',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
