import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(
    String email,
    String password,
    String name, {
    String role = 'client',
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw AuthException(message: 'Authentication failed');
      }

      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = uid;
        return UserModel.fromJson(data);
      } else {
        // Fallback user document if Firestore document is missing
        final userModel = UserModel(
          id: uid,
          email: email,
          name: userCredential.user?.displayName ?? email.split('@').first,
          role: 'client',
          createdAt: DateTime.now(),
        );
        await firestore.collection('users').doc(uid).set(userModel.toJson());
        return userModel;
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Login failed');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String name, {
    String role = 'client',
  }) async {
    try {
      final userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw AuthException(message: 'Registration failed');
      }

      await userCredential.user?.updateDisplayName(name);

      final userModel = UserModel(
        id: uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(uid).set(userModel.toJson());
      return userModel;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Registration failed');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final doc = await firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = currentUser.uid;
        return UserModel.fromJson(data);
      }

      return UserModel(
        id: currentUser.uid,
        email: currentUser.email ?? '',
        name: currentUser.displayName ?? '',
        role: 'client',
        createdAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
