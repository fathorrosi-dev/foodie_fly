import 'package:foodie_fly/data/model/addon_model.dart';
import 'package:foodie_fly/data/model/food_model.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';

/// Model class representing a cart item in the application.
/// Extends [CartItemEntity] and provides JSON serialization capabilities.
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.userId,
    required super.food,
    required super.addons,
    required super.quantity,
    required super.totalPrice,
    required super.createdAt,
  });

  /// Creates a [CartItemModel] from JSON data
  /// Throws [FormatException] if the JSON data is invalid
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || !json.containsKey('userId')) {
      throw const FormatException('Missing required fields in cart item JSON');
    }

    return CartItemModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      food: FoodModel.fromJson(json['food'] as Map<String, dynamic>),
      addons: (json['addons'] as List)
          .map((addon) => AddonModel.fromJson(addon as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'food': (food as FoodModel).toJson(),
    'addons': addons.map((addon) => (addon as AddonModel).toJson()).toList(),
    'quantity': quantity,
    'totalPrice': totalPrice,
    'createdAt': createdAt.toIso8601String(),
  };

  /// Creates a copy of this CartItemModel with the given fields replaced with the new values
  @override
  CartItemModel copyWith({
    String? id,
    String? userId,
    FoodModel? food,
    List<AddonModel>? addons,
    int? quantity,
    double? totalPrice,
    DateTime? createdAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      food: food ?? (this.food as FoodModel),
      addons: addons ?? (this.addons as List<AddonModel>),
      quantity: quantity ?? this.quantity,
      totalPrice:
          totalPrice ??
          (quantity != null
              ? (this.totalPrice / this.quantity) * quantity
              : this.totalPrice),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
