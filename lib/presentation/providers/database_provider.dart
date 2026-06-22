import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
