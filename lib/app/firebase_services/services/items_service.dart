import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';

import '../base_service.dart';

class ItemsService with FirestoreService {
  ItemsService._();
  static final ItemsService instance = ItemsService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _itemsCollection =
      _firestore.collection('items');

  Future<List<ItemsModel>> getAllItems() async {
    final snapshot = await _itemsCollection.get();
    return snapshot.docs
        .map((doc) => ItemsModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
