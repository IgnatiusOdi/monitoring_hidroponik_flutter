import 'package:flutter/material.dart';

import 'home/home_screen.dart';
import 'nutrisi/nutrisi_screen.dart';
import 'panen/panen_screen.dart';
import 'tambah/tambah_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const NutrisiScreen(),
    const PanenScreen(),
    const TambahScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Sistem Monitoring Hidroponik'),
          backgroundColor: theme.primaryColor),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.colorScheme.secondary,
          type: BottomNavigationBarType.shifting,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop),
              label: 'Nutrisi',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.compost), label: 'Panen'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
          ]),
    );
  }
}
