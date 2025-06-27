import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:safe_campus/screens/emergency_contacts.dart';
import 'package:safe_campus/screens/report_screen.dart';


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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Carousel Slider
                CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: imgList.map((item) => Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                    ),
                  )).toList(),
                ),
                SizedBox(height: 20),
                // Things, Photos, Documents on Ragging
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Things, Photos & Documents on Ragging', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('Photos and documents will be shown here.')),
                ),
                SizedBox(height: 20),
                // Quotes Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Quotes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('"Courage is not the absence of fear, but the triumph over it."'),
                ),
                SizedBox(height: 20),
                // Movie Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Movie: Table No. 21', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.movie, size: 40, color: Colors.orange),
                      SizedBox(width: 16),
                      Expanded(child: Text('A must-watch movie on the topic of ragging and its consequences.')),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
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
