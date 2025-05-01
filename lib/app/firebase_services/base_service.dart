import 'package:flutter/foundation.dart';

mixin FirestoreService {
  static Future<T> performFirestoreOperation<T>(
      Future<T> Function() operation, String operationDescription) async {
    debugPrint(operationDescription);
    try {
      return await operation();
    } catch (e) {
      debugPrint('Error $operationDescription: $e');
      rethrow;
    }
  }
}
