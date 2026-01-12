import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

/// Parameters for updating cart item
class UpdateCartItemParams extends Equatable {
  final String cartItemId;
  final int quantity;

  const UpdateCartItemParams({
    required this.cartItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartItemId, quantity];
}

/// Use case for updating cart item quantity
class UpdateCartItem {
  final Repository _repository;

  UpdateCartItem(this._repository);

  /// Calls the repository to update cart item quantity
  /// Returns [Either] with [FirestoreFailure] on failure or [Unit] on success
  Future<Either<FirestoreFailure, Unit>> call(
    UpdateCartItemParams params,
  ) async {
    return await _repository.updateCartItem(params.cartItemId, params.quantity);
  }
}
