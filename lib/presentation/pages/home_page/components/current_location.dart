import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';

class CurrentLocation extends StatelessWidget {
  const CurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deliver Now',
            style: $styles.text.titleMedium.copyWith(
              color: HelperFunction.isDarkMode(context)
                  ? $styles.colors.darkSecondaryText
                  : $styles.colors.lightSecondaryText,
            ),
          ),
          Row(
            children: [
              Text(
                '6901 Hollywood Blv',
                style: $styles.text.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.lightBackground
                    : $styles.colors.darkBackground,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
