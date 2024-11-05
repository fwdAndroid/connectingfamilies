import 'dart:io';

import 'package:connectingfamilies/screen/auth/login_screen.dart';
import 'package:connectingfamilies/screen/main/pages/favourite_page.dart';
import 'package:connectingfamilies/screen/main/pages/home_page.dart';
import 'package:connectingfamilies/screen/main/pages/message_page.dart';
import 'package:connectingfamilies/screen/main/pages/profile_page.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await _showExitDialog(context);
          return shouldPop ?? false;
        },
        child: Scaffold(
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
                  _currentIndex == 0
                      ? 'assets/homecolor.png'
                      : 'assets/home.png',
                  height: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Image.asset(
                  _currentIndex == 1
                      ? 'assets/heartcolor.png'
                      : 'assets/heart.png',
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
                  _currentIndex == 3
                      ? 'assets/chatcolor.png'
                      : 'assets/chat.png',
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
        ));
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop(); // For Android
              } else if (Platform.isIOS) {
                exit(0); // For iOS
              }
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
