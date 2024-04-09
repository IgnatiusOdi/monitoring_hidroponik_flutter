import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

import './views/ph_view.dart';
import './views/ppm_view.dart';
import './views/suhu_view.dart';
import './views/template_view.dart';

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
        builder: (context, state) => const TemplateView()),
    GoRoute(
      path: '/ph/:node',
      name: 'ph',
      builder: (context, state) => PhView(
        node: state.pathParameters['node']!,
      ),
    ),
    GoRoute(
      path: '/ppm/:node',
      name: 'ppm',
      builder: (context, state) => PpmView(
        node: state.pathParameters['node']!,
      ),
    ),
    GoRoute(
      path: '/suhu/:node',
      name: 'suhu',
      builder: (context, state) => SuhuView(
        node: state.pathParameters['node']!,
      ),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
