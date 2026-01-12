import 'package:flutter/material.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          hintStyle: $styles.text.bodyMedium.copyWith(
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.darkSecondaryText
                : $styles.colors.lightSecondaryText,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: HelperFunction.isDarkMode(context)
                  ? $styles.colors.darkBorder
                  : $styles.colors.lightBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HelperFunction.isDarkMode(context)
                  ? $styles.colors.darkSecondaryText
                  : $styles.colors.lightSecondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
