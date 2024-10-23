import 'package:connectingfamilies/screen/main/pages/favourite_page.dart';
import 'package:connectingfamilies/screen/main/pages/home_page.dart';
import 'package:connectingfamilies/screen/main/pages/message_page.dart';
import 'package:connectingfamilies/screen/main/pages/profile_page.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(), // Replace with your screen widgets
    FavouritePage(),
    Webpage(
      title: "",
      url:
          'https://mamadepluton.com/mamadepluton/?taxonomy=nav_menu&term=menu-secundario',
    ),
    MessagePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              _currentIndex == 0 ? 'assets/homecolor.png' : 'assets/home.png',
              height: 25,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              _currentIndex == 1 ? 'assets/heartcolor.png' : 'assets/heart.png',
              height: 25,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              _currentIndex == 2 ? 'assets/m.png' : 'assets/m.png',
              height: 25,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              _currentIndex == 3 ? 'assets/chatcolor.png' : 'assets/chat.png',
              height: 25,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              _currentIndex == 4 ? 'assets/barcolor.png' : 'assets/bar.png',
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}
