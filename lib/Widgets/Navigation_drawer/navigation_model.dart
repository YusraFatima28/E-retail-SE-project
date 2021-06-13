import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Home", icon: Icons.home),
  NavigationModel(title: "My Profile", icon: Icons.account_circle_sharp),
  NavigationModel(title: "My Orders", icon: Icons.reorder),
  NavigationModel(title: "My Carts", icon: Icons.shopping_cart),
  NavigationModel(title: "Search ", icon: Icons.search),
  NavigationModel(title: "Add New Address", icon: Icons.add_location),
  NavigationModel(title: "Settings", icon: Icons.settings),
];