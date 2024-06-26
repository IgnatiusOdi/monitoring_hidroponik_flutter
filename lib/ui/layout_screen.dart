import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/login/login_bloc.dart';
import 'home/home_screen.dart';
import 'nutrisi/nutrisi_screen.dart';
import 'panen/panen_screen.dart';
import 'update/update_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  final List<dynamic> _pages = [
    const HomeScreen(),
    const NutrisiScreen(),
    const PanenScreen(),
    const UpdateScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (!state.status) {
          context.goNamed('login');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Monitoring Hidroponik'),
              foregroundColor: theme.colorScheme.surface,
              backgroundColor: theme.primaryColor,
              actions: [
                IconButton(
                  tooltip: 'History',
                  color: theme.colorScheme.surface,
                  icon: const Icon(Icons.assignment),
                  onPressed: () {
                    context.goNamed('history');
                  },
                ),
                IconButton(
                  tooltip: 'Logout',
                  color: theme.colorScheme.surface,
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<LoginBloc>().add(SignOut());
                  },
                )
              ],
            ),
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: theme.primaryColor,
                unselectedItemColor: theme.colorScheme.secondary,
                type: BottomNavigationBarType.shifting,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    tooltip: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.water_drop),
                    label: 'Nutrisi',
                    tooltip: 'Nutrisi',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.compost),
                    label: 'Panen',
                    tooltip: 'Panen',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.update),
                    label: 'Update',
                    tooltip: 'Update',
                  ),
                ]),
          );
        },
      ),
    );
  }
}
