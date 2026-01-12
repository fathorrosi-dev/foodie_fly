import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodie_fly/domain/usecases/add_to_cart.dart';
import 'package:foodie_fly/domain/usecases/get_cart_items.dart';
import 'package:foodie_fly/domain/usecases/remove_from_cart.dart';
import 'package:foodie_fly/domain/usecases/update_cart_item.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';

part 'cart_event.dart';
part 'cart_state.dart';

/// BLoC for managing cart state and operations
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems _getCartItems;
  final AddToCart _addToCart;
  final UpdateCartItem _updateCartItem;
  final RemoveFromCart _removeFromCart;

  CartBloc(
    Object object, {
    required GetCartItems getCartItems,
    required AddToCart addToCart,
    required UpdateCartItem updateCartItem,
    required RemoveFromCart removeFromCart,
  }) : _getCartItems = getCartItems,
       _addToCart = addToCart,
       _updateCartItem = updateCartItem,
       _removeFromCart = removeFromCart,
       super(const CartInitial()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onLoadCartItems(
    LoadCartItems event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    final result = await _getCartItems();

    result.fold((failure) => emit(CartError(failure.toString())), (items) {
      double total = 0;
      for (final item in items) {
        total += item.totalPrice;
      }
      emit(CartLoaded(items: items, totalAmount: total));
    });
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    final result = await _addToCart(
      AddToCartParams(
        food: event.food,
        addons: event.addons,
        quantity: event.quantity,
      ),
    );

    result.fold((failure) => emit(CartError(failure.toString())), (_) {
      emit(const CartOperationSuccess('Item added to cart successfully'));
      add(const LoadCartItems());
    });
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedItems = List<CartItemEntity>.from(currentState.items);
        final itemIndex = updatedItems.indexWhere(
          (item) => item.id == event.cartItemId,
        );

        if (itemIndex != -1) {
          // Update locally first
          final updatedItem = updatedItems[itemIndex].copyWith(
            quantity: event.quantity,
          );
          updatedItems[itemIndex] = updatedItem;
          double total = updatedItems.fold(
            0,
            (sum, item) => sum + (item.totalPrice * item.quantity),
          );
          emit(CartLoaded(items: updatedItems, totalAmount: total));

          // Then update in backend
          final result = await _updateCartItem(
            UpdateCartItemParams(
              cartItemId: event.cartItemId,
              quantity: event.quantity,
            ),
          );

          result.fold(
            (failure) {
              // Revert to previous state on failure
              emit(
                CartLoaded(
                  items: currentState.items,
                  totalAmount: currentState.totalAmount,
                ),
              );
              emit(CartError(failure.toString()));
            },
            (_) => null, // Success case already handled with local update
          );
        }
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedItems = List<CartItemEntity>.from(currentState.items);
        final itemIndex = updatedItems.indexWhere(
          (item) => item.id == event.cartItemId,
        );

        if (itemIndex != -1) {
          // Remove locally first
          updatedItems.removeAt(itemIndex);
          double total = updatedItems.fold(
            0,
            (sum, item) => sum + (item.totalPrice * item.quantity),
          );
          emit(CartLoaded(items: updatedItems, totalAmount: total));

          // Then remove from backend
          final result = await _removeFromCart(event.cartItemId);

          result.fold(
            (failure) {
              // Revert to previous state on failure
              emit(
                CartLoaded(
                  items: currentState.items,
                  totalAmount: currentState.totalAmount,
                ),
              );
              emit(CartError(failure.toString()));
            },
            (_) => null, // Success case already handled with local update
          );
        }
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
