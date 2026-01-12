import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: HelperFunction.isDarkMode(context)
          ? $styles.colors.darkBackground
          : $styles.colors.lightBackground,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.lightBackground
                : $styles.colors.darkBackground,
            size: 40,
          ),
        ),
      ),
    );
  }
}
