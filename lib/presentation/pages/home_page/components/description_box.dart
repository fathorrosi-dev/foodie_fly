import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      decoration: BoxDecoration(
        border: Border.all(
          color: HelperFunction.isDarkMode(context)
              ? $styles.colors.darkDivider
              : $styles.colors.lightDivider,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('\$0.99', style: $styles.text.titleMedium),
              Text(
                'Delivery Fee',
                style: $styles.text.titleMedium.copyWith(
                  color: HelperFunction.isDarkMode(context)
                      ? $styles.colors.darkSecondaryText
                      : $styles.colors.lightSecondaryText,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text('15-30 min', style: $styles.text.titleMedium),
              Text(
                'Delivery Time',
                style: $styles.text.titleMedium.copyWith(
                  color: HelperFunction.isDarkMode(context)
                      ? $styles.colors.darkSecondaryText
                      : $styles.colors.lightSecondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
