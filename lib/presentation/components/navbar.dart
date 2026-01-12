import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/pages/cart_page/cart_page.dart';
import 'package:foodie_fly/presentation/pages/home_page/home_page.dart';
import 'package:foodie_fly/presentation/pages/order_page/order_page.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:foodie_fly/utils/navbar_utils.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HelperFunction.isDarkMode(context)
            ? $styles.colors.darkBackground
            : $styles.colors.lightBackground,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: HelperFunction.isDarkMode(context)
            ? $styles.colors.lightBackground
            : $styles.colors.darkBackground,
        unselectedItemColor: HelperFunction.isDarkMode(context)
            ? $styles.colors.darkSecondaryText
            : $styles.colors.lightSecondaryText,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: appBarDestinations,
      ),
      body: <Widget>[
        const HomePage(),
        const CartPage(),
        const OrderPage(),
      ][selectedIndex],
    );
  }
}
