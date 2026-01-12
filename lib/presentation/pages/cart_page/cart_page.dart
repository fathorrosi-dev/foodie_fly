import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartOperationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Cart', style: $styles.text.titleLarge),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: HelperFunction.isDarkMode(context)
                      ? $styles.colors.lightBackground
                      : $styles.colors.darkBackground,
                ),
                onPressed: () => context.pop(),
              ),
              backgroundColor: HelperFunction.isDarkMode(context)
                  ? $styles.colors.darkBackground
                  : $styles.colors.lightBackground,
            ),
            body: _buildBody(context, state),
            bottomNavigationBar: _buildBottomBar(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: HelperFunction.isDarkMode(context)
              ? $styles.colors.darkBackground
              : $styles.colors.lightBackground,
          size: 24,
        ),
      );
    }

    if (state is CartLoaded && state.items.isEmpty) {
      return Center(
        child: Text('Your cart is empty', style: $styles.text.titleMedium),
      );
    }

    if (state is CartLoaded) {
      return ListView.builder(
        padding: EdgeInsets.all($styles.insets.sm),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          return _buildCartItem(context, state.items[index]);
        },
      );
    }

    if (state is CartError) {
      return Center(
        child: Text(
          state.message,
          style: $styles.text.titleMedium.copyWith(color: Colors.red),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCartItem(BuildContext context, CartItemEntity cartItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Slidable(
        key: ValueKey(cartItem.id),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => context.read<CartBloc>().add(
                RemoveFromCartEvent(cartItemId: cartItem.id),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          // margin: EdgeInsets.only(bottom: $styles.insets.sm),
          padding: EdgeInsets.all($styles.insets.sm),
          decoration: BoxDecoration(
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.darkCard
                : $styles.colors.lightCard,
            borderRadius: BorderRadius.circular($styles.corners.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular($styles.corners.sm),
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
                    Text(cartItem.food.name, style: $styles.text.titleMedium),
                    if (cartItem.addons.isNotEmpty) ...[
                      SizedBox(height: $styles.insets.xs),
                      Text(
                        'Add-ons: ${cartItem.addons.map((e) => e.name).join(", ")}',
                        style: $styles.text.bodySmall,
                      ),
                    ],
                    SizedBox(height: $styles.insets.xs),
                    Text(
                      '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                      style: $styles.text.titleSmall,
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: HelperFunction.isDarkMode(context)
                      ? $styles.colors.darkPrimaryButton
                      : $styles.colors.lightPrimaryButton,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQuantityButton(
                      context,
                      icon: Icons.remove,
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          context.read<CartBloc>().add(
                            UpdateCartItemEvent(
                              cartItemId: cartItem.id,
                              quantity: cartItem.quantity - 1,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(width: $styles.insets.xs),
                    Text(
                      '${cartItem.quantity}',
                      style: $styles.text.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: HelperFunction.isDarkMode(context)
                            ? $styles.colors.lightPrimaryText
                            : $styles.colors.darkPrimaryText,
                      ),
                    ),
                    SizedBox(width: $styles.insets.xs),
                    _buildQuantityButton(
                      context,
                      icon: Icons.add,
                      onPressed: () {
                        context.read<CartBloc>().add(
                          UpdateCartItemEvent(
                            cartItemId: cartItem.id,
                            quantity: cartItem.quantity + 1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: HelperFunction.isDarkMode(context)
            ? $styles.colors.lightPrimaryText
            : $styles.colors.darkPrimaryText,
      ),
      padding: EdgeInsets.all($styles.insets.xs),
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState state) {
    if (state is! CartLoaded || state.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = state.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    return Container(
      padding: EdgeInsets.all($styles.insets.sm),
      decoration: BoxDecoration(
        color: HelperFunction.isDarkMode(context)
            ? $styles.colors.darkCard
            : $styles.colors.lightCard,
        border: Border(
          top: BorderSide(
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.darkBorder
                : $styles.colors.lightBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total', style: $styles.text.titleSmall),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: $styles.text.titleLarge,
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkPrimaryButton
                    : $styles.colors.lightPrimaryButton,
              ),
            ),
            onPressed: () {
              context.push('/checkout', extra: state.items);
            },
            child: Text(
              'Checkout',
              style: $styles.text.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkBackground
                    : $styles.colors.lightBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
