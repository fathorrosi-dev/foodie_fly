import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/components/custom_button.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItemEntity> cartItems;
  const CheckoutPage({super.key, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.cartItems.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final totalQuantity = widget.cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.lightBackground
                : $styles.colors.darkBackground,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        backgroundColor: HelperFunction.isDarkMode(context)
            ? $styles.colors.darkBackground
            : $styles.colors.lightBackground,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: '1234 5678 9012 3456',
              expiryDate: '07/27',
              cardHolderName: 'FATHORROSI',
              isHolderNameVisible: true,
              isChipVisible: true,
              cvvCode: '700',
              showBackView: false, //true when you want to show cvv(back) view
              onCreditCardWidgetChange:
                  (
                    CreditCardBrand brand,
                  ) {}, // Callback for anytime credit card brand is changed
            ),
            ListView.builder(
              itemCount: widget.cartItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                final price = cartItem.totalPrice / cartItem.quantity;
                return Container(
                  margin: EdgeInsets.only(bottom: $styles.insets.xs),
                  padding: EdgeInsets.all($styles.insets.sm),
                  decoration: BoxDecoration(
                    color: HelperFunction.isDarkMode(context)
                        ? $styles.colors.darkCard
                        : $styles.colors.lightCard,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER ${index + 1}',
                        style: $styles.text.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: $styles.insets.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              $styles.corners.sm,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: cartItem.food.imageUrl,
                              height: 80,
                              width: 80,
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
                          SizedBox(width: $styles.insets.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.food.name,
                                  style: $styles.text.titleMedium,
                                ),
                                if (cartItem.addons.isNotEmpty) ...[
                                  SizedBox(height: $styles.insets.xs),
                                  Text(
                                    'Add-ons: ${cartItem.addons.map((e) => e.name).join(", ")}',
                                    style: $styles.text.bodySmall,
                                  ),
                                ],
                                SizedBox(height: $styles.insets.xs),
                                Text(
                                  '${cartItem.quantity} x \$${price.toStringAsFixed(2)}',
                                  style: $styles.text.titleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              width: HelperFunction.screenWidth(context),
              padding: EdgeInsets.symmetric(vertical: $styles.insets.sm),
              decoration: BoxDecoration(
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkCard
                    : $styles.colors.lightCard,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: $styles.insets.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check your shopping summary',
                          style: $styles.text.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: $styles.insets.xs),
                        Row(
                          children: [
                            Text(
                              'Total price ($totalQuantity items)',
                              style: $styles.text.titleSmall.copyWith(
                                color: HelperFunction.isDarkMode(context)
                                    ? $styles.colors.darkSecondaryText
                                    : $styles.colors.lightSecondaryText,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: $styles.text.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Total shipping cost',
                              style: $styles.text.titleSmall.copyWith(
                                color: HelperFunction.isDarkMode(context)
                                    ? $styles.colors.darkSecondaryText
                                    : $styles.colors.lightSecondaryText,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$3.00',
                              style: $styles.text.titleSmall.copyWith(
                                color: HelperFunction.isDarkMode(context)
                                    ? $styles.colors.darkSecondaryText
                                    : $styles.colors.lightSecondaryText,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              ' \$0',
                              style: $styles.text.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: $styles.insets.xs),
                        Divider(
                          color: HelperFunction.isDarkMode(context)
                              ? const Color(0xFF2A3038)
                              : const Color(0xFFE0E0E0),
                          thickness: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total spending',
                              style: $styles.text.titleSmall,
                            ),
                            const Spacer(),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: $styles.text.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: HelperFunction.isDarkMode(context)
                        ? const Color(0xFF2A3038)
                        : const Color(0xFFE0E0E0),
                    thickness: 2,
                  ),
                  SizedBox(height: $styles.insets.sm),
                  CustomButton(
                    onPressed: () =>
                        context.push('/delivery', extra: widget.cartItems),
                    child: const Text('Place order'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
