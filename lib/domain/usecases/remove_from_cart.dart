import 'package:dartz/dartz.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

/// Use case for removing item from cart
class RemoveFromCart {
  final Repository _repository;

  RemoveFromCart(this._repository);

  /// Calls the repository to remove item from cart
  /// Returns [Either] with [FirestoreFailure] on failure or [Unit] on success
  Future<Either<FirestoreFailure, Unit>> call(String cartItemId) async {
    return await _repository.removeFromCart(cartItemId);
  }
}
