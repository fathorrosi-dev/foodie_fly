import 'package:dartz/dartz.dart';
import 'package:foodie_fly/data/data_source/local/user_session_manager.dart';
import 'package:foodie_fly/data/data_source/remote/remote_data_source.dart';
import 'package:foodie_fly/data/model/addon_model.dart';
import 'package:foodie_fly/data/model/food_model.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final UserSessionManager _userSessionManager;

  RepositoryImpl(this._remoteDataSource, this._userSessionManager);

  @override
  Future<Either<FirestoreFailure, List<FoodEntity>>> getFoods(
    String category,
  ) async {
    try {
      final foods = await _remoteDataSource.getFoods(category);
      return Right(foods);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<FirestoreFailure, List<AddonEntity>>> getAddons(
    String category,
  ) async {
    try {
      final addons = await _remoteDataSource.getAddons(category);

      return Right(addons);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<FirestoreFailure, List<CartItemEntity>>> getCartItems() async {
    try {
      final userId = _userSessionManager.getCurrentUserId();

      if (userId == null) {
        return const Left(FirestoreFailure('User not authenticated'));
      }

      final cartItems = await _remoteDataSource.getCartItems(userId);
      return Right(cartItems);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<FirestoreFailure, Unit>> addToCart(
    FoodEntity food,
    List<AddonEntity> addons,
    int quantity,
  ) async {
    try {
      final userId = _userSessionManager.getCurrentUserId();

      if (userId == null) {
        return const Left(FirestoreFailure('User not authenticated'));
      }

      double totalPrice = food.price;
      for (var addon in addons) {
        totalPrice += addon.price * quantity;
      }

      final foodModel = food as FoodModel;
      final addonModels = addons.map((addon) => addon as AddonModel).toList();

      await _remoteDataSource.addToCart(
        userId,
        foodModel,
        addonModels,
        quantity,
        totalPrice,
      );

      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<FirestoreFailure, Unit>> updateCartItem(
    String cartItemId,
    int quantity,
  ) async {
    try {
      await _remoteDataSource.updateCartItem(cartItemId, quantity);
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<FirestoreFailure, Unit>> removeFromCart(
    String cartItemId,
  ) async {
    try {
      await _remoteDataSource.removeFromCart(cartItemId);
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
