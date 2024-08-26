import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:hocflutter/config/constants/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      height: 55,
      items: [
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.search, title: 'Search'),
        TabItem(icon: Icons.add, title: 'Add'),
        TabItem(icon: Icons.notifications, title: 'Notification'),
        TabItem(icon: Icons.person, title: 'Profile'),
      ],
      onTap: onTap,
      style: TabStyle.fixedCircle,
      backgroundColor: dark_blue,
    );
  }
}
