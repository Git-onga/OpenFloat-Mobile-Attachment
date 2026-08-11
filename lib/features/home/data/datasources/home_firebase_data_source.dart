import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../../../core/errors/exceptions.dart';
import '../models/home_item_model.dart';

abstract class HomeFirebaseDataSource {
  Future<List<HomeItemModel>> getHomeItemsForUser();
}

class HomeFirebaseDataSourceImpl implements HomeFirebaseDataSource {
  final FirebaseFirestore firestore;

  HomeFirebaseDataSourceImpl({required this.firestore});

  @override
  Future<List<HomeItemModel>> getHomeItemsForUser() async {
    try {
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw AuthException(message: 'User not authenticated');
      }

      final snapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('home_items')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => HomeItemModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.code == 'permission-denied' 
          ? 'Permission denied. Please check your database rules.'
          : e.message ?? 'Failed to load home items');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
