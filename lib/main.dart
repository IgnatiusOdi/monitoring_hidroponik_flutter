import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoring_hidroponik_flutter/ui/history/detail_screen.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bloc/login/login_bloc.dart';
import 'repository/authentication_repository.dart';
import 'repository/firestore_repository.dart';
import 'repository/messaging_repository.dart';
import 'repository/mqtt_repository.dart';
import 'repository/realtimedb_repository.dart';
import 'ui/graph/graph_screen.dart';
import 'ui/history/history_screen.dart';
import 'ui/login/login_screen.dart';
import 'ui/error_screen.dart';
import 'ui/layout_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    await MessagingRepository().initNotifications();
  }
  setPathUrlStrategy();

  final authenticationRepository = AuthenticationRepository();
  runApp(App(authenticationRepository: authenticationRepository));
}

final class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const App({super.key, required this.authenticationRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => authenticationRepository),
        RepositoryProvider(create: (_) => FirestoreRepository()),
        RepositoryProvider(create: (_) => MqttRepository()),
        RepositoryProvider(create: (_) => RealtimedbRepository()),
      ],
      child: BlocProvider(
        create: (context) =>
            LoginBloc(authenticationRepository: authenticationRepository),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Monitoring Hidroponik',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          routerConfig: getRouterConfig(authenticationRepository),
        ),
      ),
    );
  }
}

getRouterConfig(authenticationRepository) {
  return GoRouter(
    initialLocation: '/history',
    // debugLogDiagnostics: true,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        redirect: (context, state) =>
            (authenticationRepository.user != null) ? '/home' : null,
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const LayoutScreen(),
        redirect: (context, state) =>
            (authenticationRepository.user == null) ? '/' : null,
      ),
      GoRoute(
        path: '/:node/:page',
        name: 'graph',
        builder: (context, state) => GraphScreen(
          node: state.pathParameters['node']!,
          page: state.pathParameters['page']!,
        ),
        redirect: (context, state) =>
            (authenticationRepository.user == null) ? '/' : null,
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
        redirect: (context, state) =>
            (authenticationRepository.user == null) ? '/' : null,
      ),
      GoRoute(
        path: '/history/:node/:docid',
        name: 'detail',
        builder: (context, state) => DetailScreen(
          node: state.pathParameters['node']!,
          docid: state.pathParameters['docid']!,
          tanggal: state.extra.toString(),
        ),
        redirect: (context, state) =>
            (authenticationRepository.user == null) ? '/' : null,
      ),
    ],
  );
}
