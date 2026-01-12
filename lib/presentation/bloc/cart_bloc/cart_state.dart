part of 'cart_bloc.dart';

/// Base state class for cart operations
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the cart
class CartInitial extends CartState {
  const CartInitial();
}

/// State when cart is loading
class CartLoading extends CartState {
  const CartLoading();
}

/// State when cart items are loaded successfully
class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final double totalAmount;

  const CartLoaded({required this.items, required this.totalAmount});

  @override
  List<Object?> get props => [items, totalAmount];
}

/// State when cart operation fails
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when cart operation is successful
class CartOperationSuccess extends CartState {
  final String message;

  const CartOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
