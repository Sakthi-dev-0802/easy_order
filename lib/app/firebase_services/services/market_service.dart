import 'package:cloud_firestore/cloud_firestore.dart';

import '../base_service.dart';
import '../model/market_model.dart';

class MarketService with FirestoreService {
  MarketService._();
  static final MarketService instance = MarketService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _marketCollection =
      _firestore.collection('markets');

  static Future<List<MarketModel>> getAllMarkets() async {
    return await FirestoreService.performFirestoreOperation(() async {
      QuerySnapshot querySnapshot = await _marketCollection.get();
      return querySnapshot.docs
          .map((doc) => MarketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    }, 'fetching all markets');
  }

  static Future<MarketModel?> getMarketById(String marketId) async {
    // Return null if marketId is empty to prevent Firestore error
    if (marketId.isEmpty) {
      return null;
    }

    return await FirestoreService.performFirestoreOperation(() async {
      DocumentSnapshot doc = await _marketCollection.doc(marketId).get();
      return doc.exists
          ? MarketModel.fromMap(doc.data() as Map<String, dynamic>)
          : null;
    }, 'fetching market with id: $marketId');
  }

  // static Future<void> createUser(UserModel newUser) async {
  //   await FirestoreService.performFirestoreOperation(() async {
  //     await _usersCollection.doc(newUser.email).set(newUser.toMap());
  //   }, 'creating user with email: ${newUser.email}');
  // }

  // static Future<UserModel?> getCurrentUser(String email) async {
  //   return await FirestoreService.performFirestoreOperation(() async {
  //     DocumentSnapshot doc = await _usersCollection.doc(email).get();
  //     return doc.exists
  //         ? UserModel.fromMap(doc.data() as Map<String, dynamic>)
  //         : null;
  //   }, 'fetching user with email: $email');
  // }

  // static Future<void> updateUser(String phone,
  //     {String? name, String? email, String? dob, String? role}) async {
  //   await FirestoreService.performFirestoreOperation(() async {
  //     Map<String, dynamic> updateData = {
  //       if (name != null) 'name': name,
  //       if (email != null) 'email': email,
  //       if (dob != null) 'dateOfBirth': dob,
  //       if (role != null) 'role': role,
  //     };
  //     await _usersCollection.doc(phone).update(updateData);
  //   }, 'updating user with phone: $phone');
  // }

  // static Future<List<UserModel>> getNonAdminUsers() async {
  //   return await FirestoreService.performFirestoreOperation(() async {
  //     QuerySnapshot querySnapshot = await _usersCollection
  //         .where('isAdmin', isEqualTo: false)
  //         .orderBy('name', descending: false)
  //         .get();

  //     return querySnapshot.docs
  //         .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   }, 'fetching non-admin users');
  // }
}
