import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'assets/images/admin_building1.jpg',
    'assets/images/hstu_main_gate.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
