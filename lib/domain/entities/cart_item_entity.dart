import 'package:equatable/equatable.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';

/// Entity class representing a cart item in the domain layer.
/// This is the base class for cart items in the application.
class CartItemEntity extends Equatable {
  /// Unique identifier for the cart item
  final String id;

  /// User identifier who owns this cart item
  final String userId;

  /// The food item in the cart
  final FoodEntity food;

  /// List of addons selected for this food item
  final List<AddonEntity> addons;

  /// Quantity of the food item
  final int quantity;

  /// Total price including food and addons
  final double totalPrice;

  /// Timestamp when the item was added to cart
  final DateTime createdAt;

  /// Creates a new [CartItemEntity] instance
  ///
  /// Throws [AssertionError] if quantity is less than 1
  /// or if totalPrice is less than 0
  const CartItemEntity({
    required this.id,
    required this.userId,
    required this.food,
    required this.addons,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
  }) : assert(quantity > 0, 'Quantity must be greater than 0'),
       assert(totalPrice >= 0, 'Total price cannot be negative');

  @override
  List<Object?> get props => [
    id,
    userId,
    food,
    addons,
    quantity,
    totalPrice,
    createdAt,
  ];

  /// Creates a copy of this CartItemEntity with the given fields replaced with the new values.
  CartItemEntity copyWith({
    String? id,
    String? userId,
    covariant FoodEntity? food,
    covariant List<AddonEntity>? addons,
    int? quantity,
    double? totalPrice,
    DateTime? createdAt,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      food: food ?? this.food,
      addons: addons ?? this.addons,
      quantity: quantity ?? this.quantity,
      totalPrice:
          totalPrice ??
          (quantity != null
              ? (this.totalPrice / this.quantity) * quantity
              : this.totalPrice),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'CartItemEntity(id: $id, userId: $userId, food: ${food.name}, '
      'addons: ${addons.length}, quantity: $quantity, totalPrice: $totalPrice)';
}
