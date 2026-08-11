import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<UserModel?> getCachedUser();

  Future<void> clearCachedUser();

  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _userKey = 'cached_user';

  /// Also checks FirebaseAuth.currentUser so login state is always in sync
  /// with the actual Firebase session, even after SharedPreferences is cleared.
  @override
  Future<bool> isLoggedIn() async {
    final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) return true;

    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // Always prefer the live Firebase session user first
    final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      // If Firebase session is still alive, ensure cached id matches
      if (firebaseUser != null && json['id'] != firebaseUser.uid) {
        // Stale cache — clear it
        await clearCachedUser();
        return null;
      }
      return UserModel.fromJson(json);
    } catch (_) {
      await clearCachedUser();
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
