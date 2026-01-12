import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_fly/data/model/addon_model.dart';
import 'package:foodie_fly/data/model/cart_item_model.dart';
import 'package:foodie_fly/data/model/food_model.dart';

/// Abstract class defining the contract for remote data operations.
/// Handles all remote data source operations for the food delivery application.
abstract class RemoteDataSource {
  /// Fetches a list of foods by category
  /// Throws [FirebaseException] if the operation fails
  Future<List<FoodModel>> getFoods(String category);

  /// Fetches a list of addons by category
  /// Throws [FirebaseException] if the operation fails
  Future<List<AddonModel>> getAddons(String category);

  /// Fetches cart items for a specific user
  /// Throws [FirebaseException] if the operation fails
  Future<List<CartItemModel>> getCartItems(String userId);

  /// Adds a food item to the user's cart
  /// Throws [FirebaseException] if the operation fails
  Future<void> addToCart(
    String userId,
    FoodModel food,
    List<AddonModel> addons,
    int quantity,
    double totalPrice,
  );

  /// Updates the quantity of a cart item
  /// Throws [FirebaseException] if the operation fails
  Future<void> updateCartItem(String cartItemId, int quantity);

  /// Removes an item from the cart
  /// Throws [FirebaseException] if the operation fails
  Future<void> removeFromCart(String cartItemId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseFirestore _firestore;

  RemoteDataSourceImpl(this._firestore);

  @override
  Future<List<FoodModel>> getFoods(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('foods')
          .where('category', isEqualTo: category)
          .get();

      final foods = querySnapshot.docs
          .map((doc) => FoodModel.fromJson(doc.data()))
          .toList();

      return foods;
    } catch (e) {
      throw Exception('Unexpected error while fetching foods: $e');
    }
  }

  @override
  Future<List<AddonModel>> getAddons(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('addons')
          .where('category', isEqualTo: category)
          .get();

      final addons = querySnapshot.docs
          .map((doc) => AddonModel.fromJson(doc.data()))
          .toList();

      return addons;
    } catch (e) {
      throw Exception('Unexpected error while fetching addons: $e');
    }
  }

  @override
  Future<List<CartItemModel>> getCartItems(String userId) async {
    try {
      // First, create the query
      Query query = _firestore
          .collection('carts')
          .where('userId', isEqualTo: userId);

      // Check if the index exists by attempting a small query first
      try {
        await query.orderBy('createdAt', descending: true).limit(1).get();
        // If we reach here, the index exists, so we can use the ordered query
        final querySnapshot = await query
            .orderBy('createdAt', descending: true)
            .get();
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return CartItemModel.fromJson(<String, dynamic>{
            ...data as Map<String, dynamic>,
            'id': doc.id,
          });
        }).toList();
      } catch (e) {
        if (e is FirebaseException && e.code == 'failed-precondition') {
          // If index doesn't exist, fall back to unordered query
          final querySnapshot = await query.get();
          final items = querySnapshot.docs.map((doc) {
            final data = doc.data();
            return CartItemModel.fromJson(<String, dynamic>{
              ...data as Map<String, dynamic>,
              'id': doc.id,
            });
          }).toList();

          // Sort the items in memory instead
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return items;
        }
        rethrow;
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Failed to fetch cart items: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw Exception('Unexpected error while fetching cart items: $e');
    }
  }

  @override
  Future<void> addToCart(
    String userId,
    FoodModel food,
    List<AddonModel> addons,
    int quantity,
    double totalPrice,
  ) async {
    try {
      final docRef = _firestore.collection('carts').doc();

      final cartItem = CartItemModel(
        id: docRef.id,
        userId: userId,
        food: food,
        addons: addons,
        quantity: quantity,
        totalPrice: totalPrice,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('carts').add(cartItem.toJson());
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Failed to add item to cart: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw Exception('Unexpected error while adding item to cart: $e');
    }
  }

  @override
  Future<void> updateCartItem(String cartItemId, int quantity) async {
    try {
      final docRef = _firestore.collection('carts').doc(cartItemId);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Cart item not found');
      }

      final cartItem = CartItemModel.fromJson({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });

      double newTotalPrice =
          (cartItem.food.price +
              cartItem.addons.fold(
                0.0,
                (total, addon) => total + addon.price,
              )) *
          quantity;

      await docRef.update({'quantity': quantity, 'totalPrice': newTotalPrice});
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Failed to update cart item: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw Exception('Unexpected error while updating cart item: $e');
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _firestore.collection('carts').doc(cartItemId).delete();
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Failed to remove item from cart: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw Exception('Unexpected error while removing item from cart: $e');
    }
  }
}
