part of 'cart_bloc.dart';

/// Base event class for cart operations
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load cart items
class LoadCartItems extends CartEvent {
  const LoadCartItems();

  @override
  List<Object?> get props => [];
}

/// Event to add item to cart
class AddToCartEvent extends CartEvent {
  final FoodEntity food;
  final List<AddonEntity> addons;
  final int quantity;

  const AddToCartEvent({
    required this.food,
    required this.addons,
    required this.quantity,
  });

  @override
  List<Object?> get props => [food, addons, quantity];
}

/// Event to update cart item quantity
class UpdateCartItemEvent extends CartEvent {
  final String cartItemId;
  final int quantity;

  const UpdateCartItemEvent({required this.cartItemId, required this.quantity});

  @override
  List<Object?> get props => [cartItemId, quantity];
}

/// Event to remove item from cart
class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;

  const RemoveFromCartEvent({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}
