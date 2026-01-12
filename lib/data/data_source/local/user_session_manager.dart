import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserSessionManager {
  String? getCurrentUserId();
  Future<void> clearSession();
  bool get isUserLoggedIn;
}

class UserSessionManagerImpl implements UserSessionManager {
  final FirebaseAuth _auth;
  final SharedPreferences _prefs;

  static const String userIdKey = 'userId';

  UserSessionManagerImpl(this._auth, this._prefs);

  @override
  String? getCurrentUserId() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Cache the userId in SharedPreferences
      _prefs.setString(userIdKey, currentUser.uid);
      return currentUser.uid;
    }
    // Second priority: Get from cached SharedPreferences
    return _prefs.getString(userIdKey);
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(userIdKey);
  }

  @override
  bool get isUserLoggedIn => getCurrentUserId() != null;
}
