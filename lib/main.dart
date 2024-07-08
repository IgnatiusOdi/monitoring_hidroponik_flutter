import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bloc/login/login_bloc.dart';
import 'repository/authentication_repository.dart';
import 'repository/firestore_repository.dart';
import 'repository/messaging_repository.dart';
import 'repository/mqtt_repository.dart';
import 'repository/realtimedb_repository.dart';
import 'ui/graph/graph_screen.dart';
import 'ui/history/detail_screen.dart';
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
  final firestoreRepository = FirestoreRepository();
  final realtimedbRepository = RealtimedbRepository();

  runApp(App(
    authenticationRepository: authenticationRepository,
    firestoreRepository: firestoreRepository,
    realtimedbRepository: realtimedbRepository,
  ));
}

final class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final FirestoreRepository firestoreRepository;
  final RealtimedbRepository realtimedbRepository;

  const App({
    super.key,
    required this.authenticationRepository,
    required this.firestoreRepository,
    required this.realtimedbRepository,
  });

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
        create: (context) => LoginBloc(authenticationRepository),
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
    initialLocation: '/home',
    // debugLogDiagnostics: true,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const LayoutScreen(),
      ),
      GoRoute(
        path: '/:node/:page',
        name: 'graph',
        builder: (context, state) => GraphScreen(
          node: state.pathParameters['node']!,
          page: state.pathParameters['page']!,
        ),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/history/:node/:docid',
        name: 'detail',
        builder: (context, state) => DetailScreen(
          node: state.pathParameters['node']!,
          docid: state.pathParameters['docid']!,
          tanggal: state.extra.toString(),
        ),
      ),
    ],
    redirect: (context, state) {
      if (authenticationRepository.user == null) {
        return '/';
      } else if (state.matchedLocation == '/' &&
          authenticationRepository.user != null) {
        return '/home';
      }

      return null;
    },
  );
}
