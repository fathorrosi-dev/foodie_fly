import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  CustomTabBar({super.key, required this.tabController});

  final List<String> tabs = [
    'Burgers',
    'Salads',
    'Sides',
    'Desserts',
    'Drinks',
  ];

  List<Tab> _buildCategoryTabs() {
    return tabs.map((tab) {
      return Tab(text: tab);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabColor = HelperFunction.isDarkMode(context)
        ? $styles.colors.lightBackground
        : $styles.colors.darkBackground;
    final unselectedTabColor = HelperFunction.isDarkMode(context)
        ? $styles.colors.darkSecondaryText
        : $styles.colors.darkSecondaryText;

    return SizedBox(
      child: TabBar(
        labelStyle: $styles.text.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
        indicatorColor: tabColor,
        unselectedLabelColor: unselectedTabColor,
        labelColor: tabColor,
        dividerColor: Colors.transparent,
        controller: tabController,
        tabs: _buildCategoryTabs(),
      ),
    );
  }
}
