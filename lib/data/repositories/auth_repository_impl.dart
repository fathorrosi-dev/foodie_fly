import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie_fly/data/data_source/local/user_session_manager.dart';
import 'package:foodie_fly/data/model/user_model.dart';
import 'package:foodie_fly/domain/entities/user_entity.dart';
import 'package:foodie_fly/domain/repository/auth_repository.dart';
import 'package:foodie_fly/utils/failures.dart';
import 'package:foodie_fly/utils/helpers/auth_error_hendler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;
  final UserSessionManager _userSessionManager;

  AuthRepositoryImpl(
    this._auth,
    this._firestore,
    this._prefs,
    this._userSessionManager,
  );

  @override
  Future<bool> checkSessionTimeout() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final lastActivityTime = _prefs.getInt('lastActivityTime');

        if (lastActivityTime != null) {
          final lastActivity = DateTime.fromMillisecondsSinceEpoch(
            lastActivityTime,
          );
          if (DateTime.now().difference(lastActivity) >
              const Duration(hours: 1)) {
            await logout();
            return true;
          }
        }

        await _prefs.setInt(
          'lastActivityTime',
          DateTime.now().millisecondsSinceEpoch,
        );
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left(AuthFailure('Login failed'));
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return const Left(AuthFailure('User not found'));
      }

      await _prefs.setInt(
        'lastActivityTime',
        DateTime.now().millisecondsSinceEpoch,
      );

      final userData = UserModel.fromFirestore(userDoc.data()!);

      return Right(userData);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(AuthErrorHandler.handleError(e)));
    } catch (e) {
      return Left(AuthFailure('Login failed ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left(AuthFailure('Registration failed'));
      }

      final userData = UserModel(id: user.uid, email: email);

      int maxRetries = 3;
      for (int i = 0; i < maxRetries; i++) {
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userData.toMap());
          break;
        } catch (e) {
          if (i == maxRetries - 1) {
            await user.delete();
            return const Left(
              AuthFailure('Failed to create user profile. Please try again.'),
            );
          }
          // Wait before retry
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      await _prefs.setInt(
        'lastActivityTime',
        DateTime.now().millisecondsSinceEpoch,
      );

      return Right(userData);
    } on FirebaseAuthException catch (e) {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      return Left(AuthFailure(AuthErrorHandler.handleError(e)));
    } catch (e) {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      return Left(AuthFailure('Registration failed ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserData() async {
    final user = _auth.currentUser;

    try {
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        return const Left(AuthFailure('User not found'));
      }

      final userData = UserModel.fromFirestore(userDoc.data()!);
      return Right(userData);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(AuthErrorHandler.handleError(e)));
    } catch (e) {
      return Left(AuthFailure('Failed to fetch user data ${e.toString()}'));
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _prefs.remove('lastActivityTime');
    await _userSessionManager.clearSession();
  }
}
