import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'complains.dart';
import 'emergency_complains.dart';



class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  final NotchBottomBarController _notchController = NotchBottomBarController(index: 0);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ComplainsScreen(),
      EmergencyComplainsScreen(),
      Center(child: Text('Notifications', style: TextStyle(fontSize: 18))),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Proctorial Body'),
        centerTitle: true,
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: AnimatedNotchBottomBar(
        kBottomRadius: 15.0,
        notchColor: Colors.green,
        color: Colors.white,
        showLabel: true,
        notchBottomBarController: _notchController,
        durationInMilliSeconds: 300,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.list_alt, color: Colors.green),
            activeItem: Icon(Icons.list_alt, color: Colors.white),
            itemLabel: 'Complains',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.warning_amber_rounded, color: Colors.green),
            activeItem: Icon(Icons.warning_amber_rounded, color: Colors.white),
            itemLabel: 'Emergency',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.notifications_none, color: Colors.green),
            activeItem: Icon(Icons.notifications, color: Colors.white),
            itemLabel: 'Notifications',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _notchController.jumpTo(index);
          });
        },
        kIconSize: 20.0,
      ),
    );
  }
}
