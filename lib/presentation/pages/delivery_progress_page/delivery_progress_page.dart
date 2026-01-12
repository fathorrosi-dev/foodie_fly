import 'package:flutter/material.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/components/custom_button.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';

class DeliveryProgressPage extends StatelessWidget {
  final List<CartItemEntity> cartItems;
  const DeliveryProgressPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.lightBackground
                : $styles.colors.darkBackground,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Delivery Progress'),
        centerTitle: true,
        backgroundColor: HelperFunction.isDarkMode(context)
            ? $styles.colors.darkBackground
            : $styles.colors.lightBackground,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all($styles.insets.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: $styles.insets.xl),
              Text('Thank you for your order!', style: $styles.text.titleLarge),
              SizedBox(height: $styles.insets.md),
              Container(
                margin: EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                padding: EdgeInsets.all($styles.insets.sm),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HelperFunction.isDarkMode(context)
                        ? $styles.colors.darkBorder
                        : $styles.colors.lightBorder,
                  ),
                  borderRadius: BorderRadius.circular($styles.corners.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Here's your receipt",
                      style: $styles.text.titleMedium,
                    ),
                    SizedBox(height: $styles.insets.md),
                    Text(
                      '2024-07-17 10:00 AM',
                      style: $styles.text.titleMedium,
                    ),
                    SizedBox(height: $styles.insets.md),
                    const Text('-----------------'),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: $styles.insets.xs,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cartItem.quantity} x ${cartItem.food.name} - \$${cartItem.food.price.toStringAsFixed(2)}',
                                style: $styles.text.titleMedium,
                              ),
                              Text(
                                '     Addons: ${cartItem.addons.map((addon) => '${addon.name} (\$${addon.price.toStringAsFixed(2)})').join(', ')}',
                                style: $styles.text.titleMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: $styles.insets.md),
                    const Text('-----------------'),
                    SizedBox(height: $styles.insets.md),
                    Text(
                      'Total Items: ${cartItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
                      style: $styles.text.titleMedium,
                    ),
                    Text(
                      'Total Price: \$${cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice)}',
                      style: $styles.text.titleMedium,
                    ),
                    SizedBox(height: $styles.insets.md),
                  ],
                ),
              ),
              SizedBox(height: $styles.insets.md),
              Text(
                'Estimated delivery time: 30 minutes',
                style: $styles.text.titleLarge,
              ),
              SizedBox(height: $styles.insets.xl),
              CustomButton(
                onPressed: () => context.push('/navbar'),
                child: const Text('Go to Home'),
              ),
              SizedBox(height: $styles.insets.md),
            ],
          ),
        ),
      ),
    );
  }
}
