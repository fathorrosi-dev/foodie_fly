import 'package:foodie_fly/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromFirestore(Map<String, dynamic> map) {
    return UserModel(id: map['id'] as String, email: map['email'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email};
  }
}
