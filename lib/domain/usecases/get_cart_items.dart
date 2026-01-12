import 'package:dartz/dartz.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

/// Use case for getting cart items for a user
class GetCartItems {
  final Repository _repository;

  GetCartItems(this._repository);

  /// Calls the repository to get cart items
  /// Returns [Either] with [FirestoreFailure] on failure or [List<CartItemEntity>] on success
  Future<Either<FirestoreFailure, List<CartItemEntity>>> call() async {
    return await _repository.getCartItems();
  }
}
