import 'package:dartz/dartz.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/utils/failures.dart';

/// Repository interface defining the contract for data operations.
/// Implements error handling using Either type from dartz package.
abstract class Repository {
  /// Fetches a list of foods by category
  ///
  /// Returns [Either] with [FirestoreFailure] on failure or [List<FoodEntity>] on success
  Future<Either<FirestoreFailure, List<FoodEntity>>> getFoods(String category);

  /// Fetches a list of addons by category
  ///
  /// Returns [Either] with [FirestoreFailure] on failure or [List<AddonEntity>] on success
  Future<Either<FirestoreFailure, List<AddonEntity>>> getAddons(
    String category,
  );

  /// Fetches cart items for a specific user
  ///
  /// Returns [Either] with [FirestoreFailure] on failure or [List<CartItemEntity>] on success
  Future<Either<FirestoreFailure, List<CartItemEntity>>> getCartItems();

  /// Adds a food item to the user's cart
  ///
  /// Returns [Either] with [FirestoreFailure] on failure or [Unit] on success
  Future<Either<FirestoreFailure, Unit>> addToCart(
    FoodEntity food,
    List<AddonEntity> addons,
    int quantity,
  );

  /// Updates the quantity of a cart item
  ///
  /// Returns [Either] with [FirestoreFailure] on failure or [Unit] on success
  Future<Either<FirestoreFailure, Unit>> updateCartItem(
    String cartItemId,
    int quantity,
  );

  /// Removes an item from the cart
  ///
  /// Returns [Either] with [FirestoreFailure] on failure or [Unit] on success
  Future<Either<FirestoreFailure, Unit>> removeFromCart(String cartItemId);
}
