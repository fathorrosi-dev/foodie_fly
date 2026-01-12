import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;
  const CustomSliverAppBar({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      collapsedHeight: 80,
      floating: false,
      pinned: true,
      backgroundColor: HelperFunction.isDarkMode(context)
          ? $styles.colors.darkBackground
          : $styles.colors.lightBackground,
      elevation: 0,
      title: const Text('Midnight Dinner'),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        title: title,
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: const EdgeInsets.only(left: 0, right: 0),
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: child,
        ),
      ),
    );
  }
}
