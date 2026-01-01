import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';

import '../base_service.dart';

class ItemsService with FirestoreService {
  ItemsService._();
  static final ItemsService instance = ItemsService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _itemsCollection =
      _firestore.collection('items');
  static final CollectionReference _itemDefaultsCollection =
      _firestore.collection('itemsDefaultValue');

  Future<List<ItemsModel>> getAllItems() async {
    final snapshot = await _itemsCollection.get();
    return snapshot.docs
        .map((doc) => ItemsModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ItemsModel>> getAllItemsStream() {
    return _itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ItemsModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<ItemsModel>> getAllItemsWithDefaultsStream() {
    return _itemDefaultsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ItemsModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ItemsModel> getDefaultOfItem(String itemId) async {
    final snapshot = await _itemDefaultsCollection.doc(itemId).get();
    return ItemsModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> createItem(ItemsModel item) async {
    await FirestoreService.performFirestoreOperation(() async {
      // Create minimal item for 'items' collection
      // Only: name, noOfPack (0), packType (BOX), quantity (0), uid
      final minimalItem = {
        'uid': item.uid,
        'item': item.itemName,
        'noOfPack': 0,
        'packType': item.packType,
        'quantity': 0,
      };

      // Store all values in 'itemsDefaultValue' collection
      final defaultItem = item.toMap();

      // Save to both collections
      await _itemsCollection.doc(item.uid).set(minimalItem);
      await _itemDefaultsCollection.doc(item.uid).set(defaultItem);
    }, 'creating item with id: ${item.uid}');
  }

  Future<void> updateItem(ItemsModel item) async {
    await FirestoreService.performFirestoreOperation(() async {
      // Update minimal item in 'items' collection
      final minimalItem = {
        'uid': item.uid,
        'item': item.itemName,
        'noOfPack': 0,
        'packType': item.packType,
        'quantity': 0,
      };

      // Update all values in 'itemsDefaultValue' collection
      final defaultItem = item.toMap();

      // Update both collections
      await _itemsCollection.doc(item.uid).update(minimalItem);
      await _itemDefaultsCollection.doc(item.uid).update(defaultItem);
    }, 'updating item with id: ${item.uid}');
  }
}
