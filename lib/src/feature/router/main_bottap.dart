import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/bottapScreens/add/add_screen.dart';
import 'package:hocflutter/src/feature/bottapScreens/kanban/notifications_screen.dart';
import 'package:hocflutter/src/feature/bottapScreens/profile/profile_screen.dart';
import 'package:hocflutter/src/feature/bottapScreens/list_off/view/listoff_screen.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/view/home_screen.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(accessToken: ''), // Placeholder for accessToken
    ListoffScreen(),
    AddScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens.map((screen) {
          if (screen is HomeScreen) {
            return HomeScreen(accessToken: accessToken);
          }
          return screen;
        }).toList(),
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 55,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.list, title: 'ListOff'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.notifications, title: 'Notifi'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        style: TabStyle.fixedCircle,
        backgroundColor: dark_blue,
        onTap: _onTabTapped,
      ),
    );
  }
}
