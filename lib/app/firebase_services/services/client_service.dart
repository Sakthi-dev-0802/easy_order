import 'package:cloud_firestore/cloud_firestore.dart';

import '../base_service.dart';
import '../model/client_model.dart';

class ClientService with FirestoreService {
  ClientService._();
  static final ClientService instance = ClientService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _clientsCollection =
      _firestore.collection('clients');

  Stream<List<ClientModel>> getClientsByMarketId(String marketId) {
    return _clientsCollection
        .where('marketId', isEqualTo: marketId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ClientModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
