import 'package:equatable/equatable.dart';

class AddonEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final String category;

  const AddonEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, price, category];
}
