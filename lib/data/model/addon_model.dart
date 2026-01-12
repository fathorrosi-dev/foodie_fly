import 'package:foodie_fly/domain/entities/addon_entity.dart';

class AddonModel extends AddonEntity {
  const AddonModel({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    return AddonModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'category': category};
  }
}
