import 'package:flutter/material.dart';
import 'package:monitoring_hidroponik_flutter/views/home_view.dart';
import 'package:monitoring_hidroponik_flutter/views/nutrisi_view.dart';
import 'package:monitoring_hidroponik_flutter/views/panen_view.dart';
import 'package:monitoring_hidroponik_flutter/views/ph_view.dart';
import 'package:monitoring_hidroponik_flutter/views/ppm_view.dart';
import 'package:monitoring_hidroponik_flutter/views/suhu_view.dart';

class TemplateView extends StatefulWidget {
  const TemplateView({super.key});

  @override
  State<TemplateView> createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const NutrisiView(),
    const PanenView(),
    const PhView(),
    const PpmView(),
    const SuhuView()
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nutrisi'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Panen'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'PH'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'PPM'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Suhu'),
        ],
      ),
    );
  }
}
