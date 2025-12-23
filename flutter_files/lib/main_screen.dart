import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_first_app/class_list_page.dart';
import 'package:my_first_app/main.dart';
import 'package:my_first_app/statistics_page.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final File? initialImage; // Add this to receive the recovered photo
  const MainScreen({super.key, this.initialIndex = 0, this.initialImage});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = [
      ClassListPage(onNavigateToClassifier: () => _changeTab(1)),
      ImageClassifier(initialImage: widget.initialImage), // Pass the photo here
      const StatisticsPage(),
    ];
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.sports_basketball_outlined), activeIcon: Icon(Icons.sports_basketball), label: 'Ball Types'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), activeIcon: Icon(Icons.camera_alt), label: 'Classifier'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Predictions'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _changeTab,
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0: return 'Ball Types';
      case 1: return 'Ball Classifier';
      case 2: return 'Class Predictions';
      default: return '';
    }
  }
}
