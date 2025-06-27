import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:safe_campus/screens/user_home_screen.dart';

class BottomNavBarAssigment extends StatefulWidget {
  const BottomNavBarAssigment({super.key});

  @override
  State<BottomNavBarAssigment> createState() => _BottomNavBarAssigmentState();
}

class _BottomNavBarAssigmentState extends State<BottomNavBarAssigment> {
  int _selectedIndex = 0;

  List<IconData> iconList = [
    Icons.home,
    Icons.menu_book,
    Icons.quiz,
    Icons.bar_chart,
    Icons.person,
  ];

  List<Widget> pages = [
    CenterTextScreen(),
    CenterTextScreen(),
    CenterTextScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Colors.brown,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
