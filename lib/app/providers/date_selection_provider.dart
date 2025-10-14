import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateSelectionProvider = StateProvider<DateTime>((ref) => DateTime.now());
