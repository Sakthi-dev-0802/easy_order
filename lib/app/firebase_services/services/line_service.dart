import 'package:cloud_firestore/cloud_firestore.dart';

import '../base_service.dart';
import '../model/line_model.dart';

class LineService with FirestoreService {
  LineService._();
  static final LineService instance = LineService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _linesCollection =
      _firestore.collection('lines');

  Future<void> createLine(LineModel line) async {
    await _linesCollection.doc(line.lineId).set(line.toMap());
  }

  Future<void> updateLine(LineModel line) async {
    await _linesCollection.doc(line.lineId).update(line.toMap());
  }

  Future<void> deleteLine(String lineId) async {
    await _linesCollection.doc(lineId).delete();
  }

  Future<LineModel> getLine(String lineId) async {
    final doc = await _linesCollection.doc(lineId).get();
    return LineModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Stream<List<LineModel>> getLinesByMarketId(String marketId) {
    return _linesCollection
        .where('marketId', isEqualTo: marketId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LineModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
