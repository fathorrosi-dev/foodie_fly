import 'package:dartz/dartz.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

class GetAddons {
  final Repository _repository;

  GetAddons(this._repository);

  Future<Either<FirestoreFailure, List<AddonEntity>>> execute(
    String category,
  ) async {
    return await _repository.getAddons(category);
  }
}
