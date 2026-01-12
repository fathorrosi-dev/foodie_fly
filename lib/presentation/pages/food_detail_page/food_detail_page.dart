import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/injection.dart' as di;
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/bloc/addons_bloc/addons_bloc.dart';
import 'package:foodie_fly/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:foodie_fly/presentation/components/custom_button.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Maximum quantity that can be ordered for a single food item
const int _maxQuantity = 99;

class FoodDetailPage extends StatefulWidget {
  final FoodEntity food;

  /// Creates a food detail page that displays information about a specific food item
  /// and allows users to customize their order with addons
  const FoodDetailPage({super.key, required this.food});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final List<AddonEntity> selectedAddons = [];
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: _handleCartState,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFoodImage(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: $styles.insets.md,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFoodDetails(),
                        const SizedBox(height: 12),
                        _buildDivider(),
                        const SizedBox(height: 12),
                        _buildAddonsSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBackButton(),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  void _handleCartState(BuildContext context, CartState state) {
    if (state is CartOperationSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
      context.pop();
    } else if (state is CartError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildFoodImage() {
    return Container(
      height: 400,
      width: double.infinity,
      color: HelperFunction.isDarkMode(context)
          ? $styles.colors.darkCard
          : $styles.colors.lightCard,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.food.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkBackground
                    : $styles.colors.lightBackground,
                size: 24,
              ),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
          ),
          if (widget.food.imageUrl.isEmpty)
            const Center(
              child: Icon(Icons.fastfood, size: 48, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.food.name,
          style: $styles.text.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${widget.food.price.toStringAsFixed(2)}',
              style: $styles.text.titleLarge.copyWith(
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkSecondaryText
                    : $styles.colors.lightSecondaryText,
              ),
            ),
            _buildQuantitySelector(),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.food.description,
          style: $styles.text.titleSmall,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (quantity > 1) {
              setState(() {
                quantity--;
              });
            }
          },
          icon: Icon(
            Icons.remove_circle_outline,
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.lightBackground
                : $styles.colors.darkBackground,
          ),
        ),
        Text(quantity.toString(), style: $styles.text.titleMedium),
        IconButton(
          onPressed: () {
            if (quantity < _maxQuantity) {
              setState(() {
                quantity++;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maximum quantity reached'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          icon: Icon(
            Icons.add_circle_outline,
            color: HelperFunction.isDarkMode(context)
                ? $styles.colors.lightBackground
                : $styles.colors.darkBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 2,
      color: HelperFunction.isDarkMode(context)
          ? $styles.colors.darkDivider
          : $styles.colors.lightDivider,
    );
  }

  Widget _buildAddonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Addons',
          style: $styles.text.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: HelperFunction.isDarkMode(context)
                  ? $styles.colors.darkBorder
                  : $styles.colors.lightBorder,
            ),
          ),
          child: BlocProvider(
            create: (context) =>
                di.locator<AddonsBloc>()
                  ..add(GetAddonsEvent('${widget.food.category}_addons')),
            child: BlocBuilder<AddonsBloc, AddonsState>(
              builder: _buildAddonsList,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddonsList(BuildContext context, AddonsState state) {
    if (state is AddonsLoading) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: HelperFunction.isDarkMode(context)
              ? $styles.colors.darkBackground
              : $styles.colors.lightBackground,
          size: 24,
        ),
      );
    } else if (state is AddonsLoaded) {
      return ListView.builder(
        itemCount: state.addons.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => _buildAddonItem(state.addons[index]),
      );
    } else if (state is AddonsError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message, textAlign: TextAlign.center),
            TextButton(
              onPressed: () => context.read<AddonsBloc>().add(
                GetAddonsEvent('${widget.food.category}_addons'),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('Something went wrong'));
  }

  Widget _buildAddonItem(AddonEntity addon) {
    return CheckboxListTile(
      title: Text(addon.name),
      subtitle: Text('\$${addon.price.toStringAsFixed(2)}'),
      value: selectedAddons.contains(addon),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            selectedAddons.add(addon);
          } else {
            selectedAddons.remove(addon);
          }
        });
      },
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 16),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: HelperFunction.isDarkMode(context)
            ? $styles.colors.lightBackground
            : $styles.colors.darkBackground,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back,
          color: HelperFunction.isDarkMode(context)
              ? $styles.colors.darkBackground
              : $styles.colors.lightBackground,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Container(
          height: 67,
          padding: const EdgeInsets.only(top: 7),
          child: CustomButton(
            onPressed: state is CartLoading
                ? null
                : () => _handleAddToCart(context),
            child: state is CartLoading
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 24,
                  )
                : Text(
                    'Add to cart (\$${calculateTotal().toStringAsFixed(2)})',
                  ),
          ),
        );
      },
    );
  }

  void _handleAddToCart(BuildContext context) {
    if (quantity <= 0 || quantity > _maxQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<CartBloc>().add(
      AddToCartEvent(
        food: widget.food,
        addons: selectedAddons,
        quantity: quantity,
      ),
    );
  }

  /// Calculates the total price of the order including selected addons
  double calculateTotal() {
    double total = widget.food.price * quantity;
    for (var addon in selectedAddons) {
      total += addon.price * quantity;
    }
    return total;
  }
}
