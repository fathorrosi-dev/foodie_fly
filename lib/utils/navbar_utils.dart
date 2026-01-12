import 'package:flutter/material.dart';

List<BottomNavigationBarItem> appBarDestinations = [
  const BottomNavigationBarItem(
    tooltip: '',
    icon: Icon(Icons.home),
    activeIcon: Icon(Icons.home_filled),
    label: 'Home',
  ),
  const BottomNavigationBarItem(
    tooltip: '',
    icon: Icon(Icons.shopping_cart),
    activeIcon: Icon(Icons.shopping_cart_checkout),
    label: 'Cart',
  ),
  const BottomNavigationBarItem(
    tooltip: '',
    icon: Icon(Icons.list_alt),
    activeIcon: Icon(Icons.receipt_long),
    label: 'Orders',
  ),
];
