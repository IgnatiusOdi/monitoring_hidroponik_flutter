import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

import './views/graph_view.dart';
import './views/template_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
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
        builder: (context, state) => const TemplateView()),
    GoRoute(
      path: '/:page/:node',
      name: 'graph',
      builder: (context, state) => GraphView(
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Monitoring Hidroponik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
