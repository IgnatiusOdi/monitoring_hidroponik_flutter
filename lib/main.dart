import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bloc/login/login_bloc.dart';
import 'repository/authentication_repository.dart';
import 'repository/mqtt_repository.dart';
import 'repository/realtimedb_repository.dart';
import 'ui/error_screen.dart';
import 'ui/graph/graph_screen.dart';
import 'ui/layout_screen.dart';
import 'ui/login/login_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        RepositoryProvider(
          create: (_) => authenticationRepository,
        ),
        RepositoryProvider(
          create: (_) => MqttRepository(),
        ),
        RepositoryProvider(
          create: (_) => RealtimedbRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            LoginBloc(authenticationRepository: authenticationRepository),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Sistem Monitoring Hidroponik',
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
    initialLocation: '/',
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
    redirect: (context, state) async {
      final bool loggedIn = authenticationRepository.user != null;
      if (!loggedIn) return '/';

      final bool loggingIn = state.matchedLocation == '/';
      if (loggingIn) return '/home';

      return null;
    },
  );
}
