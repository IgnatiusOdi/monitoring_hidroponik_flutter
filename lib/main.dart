import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoring_hidroponik_flutter/views/template_view.dart';
import 'package:monitoring_hidroponik_flutter/views/nutrisi_view.dart';
import 'package:monitoring_hidroponik_flutter/views/panen_view.dart';
import 'package:monitoring_hidroponik_flutter/views/ph_view.dart';
import 'package:monitoring_hidroponik_flutter/views/ppm_view.dart';
import 'package:monitoring_hidroponik_flutter/views/suhu_view.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const TemplateView()),
    GoRoute(
        path: '/nutrisi',
        name: 'nutrisi',
        builder: (context, state) => const NutrisiView()),
    GoRoute(
        path: '/panen',
        name: 'panen',
        builder: (context, state) => const PanenView()),
    GoRoute(
        path: '/ph', name: 'ph', builder: (context, state) => const PhView()),
    GoRoute(
        path: '/ppm',
        name: 'ppm',
        builder: (context, state) => const PpmView()),
    GoRoute(
        path: '/suhu',
        name: 'suhu',
        builder: (context, state) => const SuhuView()),
  ],
);

void main() {
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sistem Monitoring Hidroponik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
