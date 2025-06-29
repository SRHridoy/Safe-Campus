import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:safe_campus/screens/emergency_contacts.dart';
import 'package:safe_campus/screens/report_screen.dart';

import 'home_screen.dart';


class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _currentIndex = 0;
  final List<String> imgList = [
    'assets/images/admin_building1.jpg',
    'assets/images/hstu_main_gate.jpg',
  ];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Campus'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          ReportScreen(),
          EmergencyContacts(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        kBottomRadius: 15.0,
        notchColor: Colors.green,
        color: Colors.white,
        showLabel: true,
        notchBottomBarController: NotchBottomBarController(index: _currentIndex),
        durationInMilliSeconds: 300,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: Colors.green),
            activeItem: Icon(Icons.home, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.photo_album_outlined, color: Colors.green),
            activeItem: Icon(Icons.photo_album, color: Colors.white),
            itemLabel: 'Report',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.contact_emergency_outlined, color: Colors.green),
            activeItem: Icon(Icons.contact_emergency, color: Colors.white),
            itemLabel: 'Emergency Contacts',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        kIconSize: 20.0,
      ),
    );
  }
}
