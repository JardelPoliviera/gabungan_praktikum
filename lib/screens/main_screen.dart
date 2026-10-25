import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart'; 
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String userEmail; // Menampung email dari login
  const MainScreen({super.key, required this.userEmail});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List kumpulan halaman
  late final List<Widget> _pages;

 @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(email: widget.userEmail),
      const HistoryScreen(), 
      ProfileScreen(email: widget.userEmail), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}