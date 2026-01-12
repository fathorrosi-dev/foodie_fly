import 'package:dartz/dartz.dart';
import 'package:foodie_fly/domain/entities/user_entity.dart';
import 'package:foodie_fly/utils/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(String email, String password);
  Future<Either<Failure, UserEntity>> getUserData();
  Future<bool> isUserLoggedIn();
  Future<void> logout();
  Future<bool> checkSessionTimeout();
}
