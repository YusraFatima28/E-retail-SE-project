import 'package:flutter/material.dart';

class NavigationModelAdmin {
  String title;
  IconData icon;

  NavigationModelAdmin({this.title, this.icon});
}

List<NavigationModelAdmin> navigationItems = [
  NavigationModelAdmin(title: "Home", icon: Icons.home),
  NavigationModelAdmin(title: "My Profile", icon: Icons.account_circle_sharp),
  NavigationModelAdmin(title: "My Orders", icon: Icons.reorder),
  NavigationModelAdmin(title: "Log Out", icon: Icons.logout),

];