import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FoodCard extends StatelessWidget {
  final FoodEntity food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/food_detail_page', extra: food),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: HelperFunction.isDarkMode(context)
              ? $styles.colors.darkCard
              : $styles.colors.lightCard,
          border: Border(
            top: BorderSide(
              color: HelperFunction.isDarkMode(context)
                  ? $styles.colors.darkBorder
                  : $styles.colors.lightBorder,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: $styles.text.titleMedium),
                  Text(
                    '\$${food.price.toStringAsFixed(2)}',
                    style: $styles.text.titleMedium.copyWith(
                      color: HelperFunction.isDarkMode(context)
                          ? $styles.colors.darkSecondaryText
                          : $styles.colors.lightSecondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(food.description, style: $styles.text.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkCard
                    : $styles.colors.lightCard,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: HelperFunction.isDarkMode(context)
                          ? $styles.colors.darkBackground
                          : $styles.colors.lightBackground,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
