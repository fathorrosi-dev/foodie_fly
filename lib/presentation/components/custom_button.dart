import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const CustomButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: $styles.insets.md),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          ),
          foregroundColor: WidgetStatePropertyAll(
            HelperFunction.isDarkMode(context)
                ? $styles.colors.darkBackground
                : $styles.colors.lightBackground,
          ),
          backgroundColor: WidgetStatePropertyAll(
            HelperFunction.isDarkMode(context)
                ? $styles.colors.lightBackground
                : $styles.colors.darkBackground,
          ),
          textStyle: WidgetStatePropertyAll(
            HelperFunction.isDarkMode(context)
                ? $styles.text.titleMedium.copyWith(
                    color: $styles.colors.darkBackground,
                    fontWeight: FontWeight.bold,
                  )
                : $styles.text.titleMedium.copyWith(
                    color: $styles.colors.lightBackground,
                    fontWeight: FontWeight.bold,
                  ),
          ),
        ),
        child: child,
      ),
    );
  }
}
